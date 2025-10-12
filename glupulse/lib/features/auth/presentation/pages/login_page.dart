import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:glupulse/app/theme/app_theme.dart';

import 'package:http/http.dart' as http;
import 'package:glupulse/home_page.dart';
import 'package:glupulse/features/auth/presentation/pages/register_page.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username dan Password tidak boleh kosong!')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final url = Uri.parse('https://noncereal-uncongenially-gloria.ngrok-free.dev/login');

    // Buat client yang tidak mengikuti redirect secara otomatis
    final client = http.Client();

    try {
      final request = http.Request('POST', url)
        ..headers['Content-Type'] = 'application/json'
        ..headers['Accept'] = 'application/json' // Penting: Minta respons JSON
        ..headers['X-Platform'] = 'mobile' // Header tambahan sesuai permintaan
        ..body = jsonEncode({
          'Username': username,
          'Password': password,
        });

      final streamedResponse = await client.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      // Cek jika status adalah 200 (OK)
      if (response.statusCode == 200) {
        // Jika login berhasil
        // TODO: Simpan token jika ada
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      } else {
        // Jika login gagal (termasuk 302, 401, 422, dll)
        String errorMessage = 'Login Gagal: Username atau password salah.';
        if (response.body.isNotEmpty) {
          try {
            final decodedBody = jsonDecode(response.body);
            if (decodedBody is Map<String, dynamic> && decodedBody.containsKey('message')) {
              errorMessage = 'Login Gagal: ${decodedBody['message']}';
            }
          } catch (e) {
            // Abaikan jika body bukan JSON, gunakan pesan default
          }
        }

        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    } catch (e) {
      // Error jaringan atau lainnya
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }
    } finally {
      client.close(); // Selalu tutup client
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _goToRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
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
                    style: Theme
                        .of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.inputFieldColor,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        hintText: 'Username',
                        hintStyle: TextStyle(color: AppTheme.inputLabelColor),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.inputFieldColor,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(color: AppTheme.inputLabelColor),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                      ),
                      obscureText: true,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0), // Menambahkan padding horizontal
                    child: ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 60), // Lebar penuh, tinggi 35
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        elevation: 5, // Menambahkan sedikit shadow
                      ),
                      child: _isLoading
                          ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                          : const Text('Sign In', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0), // Menambahkan padding yang sama
                    child: const Row(
                      children: [
                        Expanded(child: Divider(thickness: 1, color: Colors.grey)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'OR',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Expanded(child: Divider(thickness: 1, color: Colors.grey)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Tombol Login dengan Google
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        // TODO: Implement Google Sign-In logic
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Image.asset(
                          'assets/images/google_logo.png', // Pastikan Anda punya file ini
                          height: 30,
                          width: 30,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Memberi jarak dari tombol Google
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(color: AppTheme.inputLabelColor),
                      ),
                      TextButton(
                        onPressed: _goToRegister,
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
      ),
    );
  }
}