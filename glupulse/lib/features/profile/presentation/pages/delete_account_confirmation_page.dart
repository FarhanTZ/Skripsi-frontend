import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glupulse/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:glupulse/app/theme/app_theme.dart';
import 'package:glupulse/features/auth/presentation/cubit/auth_state.dart';
import 'package:glupulse/features/auth/presentation/pages/login_page.dart';

class DeleteAccountConfirmationPage extends StatefulWidget {
  final bool isGoogleLinked;

  const DeleteAccountConfirmationPage({
    super.key,
    required this.isGoogleLinked,
  });

  @override
  State<DeleteAccountConfirmationPage> createState() =>
      _DeleteAccountConfirmationPageState();
}

class _DeleteAccountConfirmationPageState
    extends State<DeleteAccountConfirmationPage> {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _deleteAccount() {
    // Validasi form hanya jika akun tidak tertaut Google
    if (widget.isGoogleLinked || _formKey.currentState!.validate()) {
      context.read<AuthCubit>().deleteAccount(_passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(
                  content: Text('Akun Anda telah berhasil dihapus.'),
                  backgroundColor: Colors.green));
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                  content: Text(state.message), backgroundColor: Colors.red));
          }
        },
        child: Stack(
          children: [
            Column(
              children: [
                // --- BAGIAN ATAS (TIDAK BISA SCROLL) ---
                SafeArea(
                  bottom: false, // Hanya terapkan SafeArea di atas
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 40), // Spasi untuk tombol kembali
                        Center(
                          child: Image.asset(
                            'assets/images/delete_account.png',
                            height: 320,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Hapus Akun Anda?',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                // --- BAGIAN BAWAH (BISA SCROLL) ---
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          const Text(
                            'Ini adalah tindakan permanen. Semua data Anda akan dihapus selamanya dan tidak dapat dipulihkan.',
                            style: TextStyle(fontSize: 16, color: Colors.black54),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          if (widget.isGoogleLinked)
                            Text(
                              'Apakah Anda yakin ingin melanjutkan?',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).colorScheme.primary),
                              textAlign: TextAlign.center,
                            )
                          else ...[
                            const Text(
                              'Untuk melanjutkan, silakan masukkan kata sandi Anda saat ini.',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            _buildPasswordField(),
                          ],
                          const SizedBox(height: 24), // Padding bawah untuk konten scroll
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Tombol kembali kustom di luar SafeArea agar bisa menempel di atas
            Positioned(
              top: 40, // Sesuaikan posisi dari atas (memperhitungkan status bar)
              left: 16,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black54),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
      // Pindahkan tombol ke bottomNavigationBar
      bottomNavigationBar: _buildBottomActionButtons(),
    );
  }

  // Widget baru untuk menampung tombol di bagian bawah
  Widget _buildBottomActionButtons() {
    return Container(
      padding: EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
        bottom: 16 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFF2F5F9), // Samakan dengan warna background utama
        border: Border(top: BorderSide(color: Colors.transparent)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              final isLoading = state is AuthLoading;
              return ElevatedButton(
                onPressed: isLoading ? null : _deleteAccount,
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFA4D5E), // Warna merah dari analytic_tab
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0))),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Hapus',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(width: 8),
                          Icon(Icons.delete_outline, size: 22, color: Colors.white),
                        ],
                      ),
              );
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Colors.redAccent.withOpacity(0.15),
              foregroundColor: Colors.redAccent,
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Batal',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(width: 8),
                Icon(Icons.close, size: 22, color: Colors.redAccent),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget modern untuk field password
  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
      child: TextFormField(
        controller: _passwordController,
        obscureText: _obscureText,
        decoration: InputDecoration(
          hintText: 'Password',
          hintStyle: const TextStyle(color: AppTheme.inputLabelColor),
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
            onPressed: () => setState(() => _obscureText = !_obscureText),
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Password tidak boleh kosong';
          }
          return null;
        },
      ),
    );
  }
}