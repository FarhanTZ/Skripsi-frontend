import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:glupulse/app/theme/app_theme.dart';
import 'package:glupulse/navbar_button.dart';
import 'package:glupulse/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:glupulse/features/auth/presentation/pages/complete_password_reset_page.dart';
import 'package:glupulse/features/HealthData/presentation/pages/health_profile_page.dart';
import 'package:glupulse/features/auth/presentation/cubit/auth_state.dart';
import 'package:glupulse/features/profile/presentation/pages/edit_profile_page.dart';

class OtpVerificationPage extends StatefulWidget {
  final String? userId;
  final String? pendingId;
  final String? emailForReset; // Untuk alur lupa password
  final String? userIdForReset; // Untuk alur lupa password

  const OtpVerificationPage(
      {super.key,
      this.userId,
      this.pendingId,
      this.emailForReset, this.userIdForReset})
      // Pastikan salah satu dari userId atau pendingId tidak null
      : assert(userId != null || pendingId != null || emailForReset != null || userIdForReset != null, 'ID harus disediakan');

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  Timer? _timer;
  int _start = 60; // Durasi countdown dalam detik
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(6, (_) => TextEditingController());
    _focusNodes = List.generate(6, (_) => FocusNode());
    startTimer();
  }

  void startTimer() {
    _canResend = false;
    _start = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() => _canResend = true);
        timer.cancel();
      } else {
        setState(() => _start--);
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    // Gabungkan teks dari semua controller
    final otp = _controllers.map((c) => c.text).join();

    if (otp.isEmpty || otp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kode OTP harus 6 digit!')),
      );
      return;
    }

    // Cek apakah ini alur reset password
    if (widget.userIdForReset != null) {
      // Jika ya, navigasi ke halaman password baru dengan membawa data
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => CompletePasswordResetPage(
          userId: widget.userIdForReset!,
          otpCode: otp,
        ),
      ));
    } else {
      // Jika tidak, ini adalah alur login/signup biasa
      context.read<AuthCubit>().verifyOtp(
            userId: widget.userId,
            pendingId: widget.pendingId,
            otpCode: otp,
          );
    }
  }

  Future<void> _resendOtp() async {
    if (_canResend) {
      context.read<AuthCubit>().resendOtp(
        userId: widget.userId,
        pendingId: widget.pendingId,
        // TODO: Tambahkan logika resend OTP untuk reset password jika API-nya ada
      );
    }
  }

  void _onOtpChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      // Pindah ke field berikutnya jika digit dimasukkan
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      // Pindah ke field sebelumnya jika digit dihapus (backspace)
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fokus ke field pertama saat halaman dimuat
    FocusScope.of(context).requestFocus(_focusNodes[0]);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        // Listener untuk alur reset password
        if (state is AuthOtpRequired && widget.emailForReset != null) {
          // Setelah request reset, backend akan mengembalikan user_id
          // Kita navigasi ke halaman OTP lagi, tapi kali ini dengan user_id
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => OtpVerificationPage(
              userIdForReset: state.userId, // Ambil userId dari state
            ),
          ));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email ditemukan. Silakan masukkan OTP.')),
          );
        }

        debugPrint('OtpVerificationPage Listener: Menerima state -> ${state.runtimeType}'); // DEBUG
        if (state is AuthProfileIncomplete) {
          // Jika profil dasar belum lengkap, arahkan ke halaman edit profil.
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const EditProfilePage(isFromAuthFlow: true)),
            (route) => false,
          );
        } else if (state is AuthHealthProfileIncomplete) {
          // Jika profil dasar sudah lengkap tapi profil kesehatan belum, arahkan ke halaman profil kesehatan.
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const HealthProfilePage()),
            (route) => false,
          );
        } else if (state is AuthAuthenticated) {
          // Jika semua profil sudah lengkap, arahkan ke halaman utama.
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const HomePage()), (route) => false);
        } else if (state is AuthOtpResent) {
          // Tampilkan snackbar sukses dan mulai ulang timer
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.message)));
          startTimer(); // Mulai ulang countdown
          // Tidak perlu emit state baru, cukup reset timer di UI
        } else if (state is AuthError) {
          // Tampilkan error jika OTP salah atau ada masalah lain
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        debugPrint('OtpVerificationPage Builder: Membangun untuk state -> ${state.runtimeType}'); // DEBUG
        final isLoading = state is AuthLoading;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Verifikasi OTP'),
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 75),
                  Text(
                    'Masukkan Kode OTP',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.emailForReset != null
                        ? 'Kami telah mengirimkan kode verifikasi ke ${widget.emailForReset}.'
                        : 'Kami telah mengirimkan kode verifikasi ke email Anda.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  // --- OTP Fields ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) {
                      return _buildOtpField(index);
                    }),
                  ),
                  const SizedBox(height: 40),
                  // --- Resend OTP ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _canResend
                            ? "Tidak menerima kode? "
                            : "Kirim ulang kode dalam ",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      if (!_canResend)
                        Text(
                          "0:${_start.toString().padLeft(2, '0')}",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold),
                        ),
                      if (_canResend)
                        GestureDetector(
                          onTap: _resendOtp,
                          child: Text("Kirim Ulang", style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _verifyOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        elevation: 5,
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 3))
                          : const Text('Verifikasi',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Widget helper untuk membuat satu field OTP
  Widget _buildOtpField(int index) {
    return SizedBox(
      width: 50,
      height: 60,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.inputFieldColor,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              spreadRadius: 1,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          onChanged: (value) => _onOtpChanged(value, index),
          style: Theme.of(context).textTheme.headlineSmall,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: const InputDecoration(
            counterText: "", // Sembunyikan counter default
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }
}