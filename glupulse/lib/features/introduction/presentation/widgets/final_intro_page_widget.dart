import 'package:flutter/material.dart';

class FinalIntroPage extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final VoidCallback onGetStarted;

  const FinalIntroPage({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.onGetStarted,
  });

  @override
  Widget build(BuildContext context) {
    // Menggunakan Column untuk membagi layout menjadi bagian atas (teks) dan bawah (gambar + tombol)
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
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.left,
              ),
              if (description.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  description,
                  textAlign: TextAlign.left,
                  style: const TextStyle(color: Color(0xFF808B9B)),
                ),
              ],
            ],
          ),
        ),

        // Bagian Bawah: Gambar dan Tombol (mengisi sisa ruang)
        Expanded(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Positioned.fill(
                bottom: 0,
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.bottomCenter,
                ),
              ),
              Positioned(
                bottom: 40, // Jarak dari bawah
                left: 24,
                right: 24,
                child: ElevatedButton(
                  onPressed: onGetStarted,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: const Text('Get Started',
                      style:
                          TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          )
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
