import 'package:flutter/material.dart';
import 'package:glupulse/features/authentication/presentation/screens/home_page.dart';
import 'package:glupulse/features/authentication/presentation/screens/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    // TODO: Implement login logic here
    // For now, just navigate to the home page
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  void _goToRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Menambahkan gambar di sini
            Image.asset(
              'images/Ellipse.png', // Path diperbarui sesuai permintaan
              width: double.infinity, // Membuat gambar mengisi lebar penuh
              height: 200, // Meningkatkan tinggi gambar
              fit: BoxFit.cover, // Memastikan gambar mengisi area tanpa distorsi
            ),
            const SizedBox(height: 40), // Memberi jarak setelah gambar
            Text(
              'Selamat Datang Kembali!',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Belum punya akun?"),
                TextButton(onPressed: _goToRegister, child: const Text('Daftar di sini')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}