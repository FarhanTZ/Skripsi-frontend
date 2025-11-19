import 'package:flutter/material.dart';
import 'package:glupulse/app/theme/app_theme.dart';
import 'package:glupulse/core/widgets/custom_text_field.dart';
import 'package:glupulse/core/widgets/password_text_field.dart';

class LoginBody extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final bool isPasswordVisible;
  final bool isLoading;
  final VoidCallback onToggleVisibility;
  final VoidCallback onLogin;
  final VoidCallback onLoginWithGoogle;
  final VoidCallback onGoToRegister;

  const LoginBody({
    super.key,
    required this.usernameController,
    required this.passwordController,
    required this.isPasswordVisible,
    required this.isLoading,
    required this.onToggleVisibility,
    required this.onLogin,
    required this.onLoginWithGoogle,
    required this.onGoToRegister,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Menambahkan gambar di sini
          Image.asset(
            'assets/images/Ellipse.png', // Path diperbarui sesuai permintaan
            width: double.infinity, // Membuat gambar mengisi lebar penuh
            height: 220, // Anda bisa sesuaikan tingginya
            fit: BoxFit.cover, // Memastikan gambar mengisi area tanpa distorsi
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 75), // Memberi jarak setelah gambar
                Text(
                  'Welcome to Glupulse!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                CustomTextField(
                    controller: usernameController, hintText: 'Username'),
                const SizedBox(height: 32),
                PasswordTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    isVisible: isPasswordVisible,
                    onToggleVisibility: onToggleVisibility,
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0), // Menambahkan padding horizontal
                  child: ElevatedButton(
                    onPressed: isLoading ? null : onLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 60), // Lebar penuh, tinggi 35
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      elevation: 5, // Menambahkan sedikit shadow
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 3))
                        : const Text('Sign In',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 40.0), // Menambahkan padding yang sama
                  child: Row(
                    children: [
                      Expanded(
                          child: Divider(thickness: 1, color: Colors.grey)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'OR',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      Expanded(
                          child: Divider(thickness: 1, color: Colors.grey)),
                    ],
                  ),
                ),
                const SizedBox(height: 20), // Memberi jarak dari tombol Google
                // Tombol Sign In dengan Google
                Center(
                  child: GestureDetector(
                    onTap: isLoading ? null : onLoginWithGoogle,
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                          ),
                        ],
                        color: Colors.white,
                      ),
                      child: Image.asset(
                        'assets/images/google_logo.png', // Pastikan Anda punya file ini
                        height: 30,
                        width: 30,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(color: AppTheme.inputLabelColor),
                    ),
                    TextButton(
                      onPressed: onGoToRegister,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}