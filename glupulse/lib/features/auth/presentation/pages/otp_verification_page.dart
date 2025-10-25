import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:glupulse/app/theme/app_theme.dart';
import 'package:glupulse/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:glupulse/features/Dashboard/presentation/pages/Dashboard_page.dart';
import 'package:glupulse/features/auth/presentation/cubit/auth_state.dart';

class OtpVerificationPage extends StatefulWidget {
  final String userId;

  const OtpVerificationPage({super.key, required this.userId});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(6, (_) => TextEditingController());
    _focusNodes = List.generate(6, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
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
    // Panggil metode verifyOtp dari AuthCubit
    context.read<AuthCubit>().verifyOtp(widget.userId, otp);
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
        print('OtpVerificationPage Listener: Menerima state -> ${state.runtimeType}'); // DEBUG
        if (state is AuthAuthenticated) {
          // Jika OTP benar, navigasi ke HomePage
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomePage()),
            (route) => false,
          );
        } else if (state is AuthError) {
          // Tampilkan error jika OTP salah atau ada masalah lain
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        print('OtpVerificationPage Builder: Membangun untuk state -> ${state.runtimeType}'); // DEBUG
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
                    'Kami telah mengirimkan kode verifikasi ke email Anda.',
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
              color: Colors.grey.withOpacity(0.2),
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