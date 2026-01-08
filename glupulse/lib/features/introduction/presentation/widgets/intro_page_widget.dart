import 'package:flutter/material.dart';
import 'package:glupulse/app/theme/app_theme.dart';

/// Widget untuk membangun satu halaman perkenalan.
class IntroPage extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;

  const IntroPage({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    // Menggunakan Column untuk membagi layout menjadi bagian atas (teks) dan bawah (gambar)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bagian Atas: Teks Judul dan Deskripsi
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              // Teks judul
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.left,
              ),
              // Deskripsi (jika ada)
              if (description.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(description,
                    textAlign: TextAlign.left,
                    style: const TextStyle(color: AppTheme.inputLabelColor)),
              ],
            ],
          ),
        ),
        // Bagian Bawah: Gambar (mengisi sisa ruang yang tersedia)
        Expanded(
          child: Image.asset(
            imageUrl,
            width: double.infinity,
            fit: BoxFit.fitWidth,
            alignment: Alignment.bottomCenter, // Memastikan gambar menempel di bawah
          ),
        ),
      ],
    );
  }
}