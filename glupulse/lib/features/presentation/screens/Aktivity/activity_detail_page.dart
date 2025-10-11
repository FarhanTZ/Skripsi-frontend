import 'package:flutter/material.dart';
import 'package:glupulse/app/theme/app_theme.dart';

class ActivityDetailPage extends StatelessWidget {
  final String activityName;

  const ActivityDetailPage({super.key, required this.activityName});

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Menggunakan Scaffold sebagai kerangka dasar
      extendBodyBehindAppBar: true, // Memungkinkan body untuk berada di belakang AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Membuat AppBar transparan
        elevation: 0, // Menghilangkan bayangan AppBar
        centerTitle: false, // Membuat judul tidak di tengah
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // Tombol kembali
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Detail Aktivitas', // Judul AppBar
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView( // Konten utama yang dapat digulir
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 250,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(40),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 150,
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: Container(
                          height: 180,
                          width: MediaQuery.of(context).size.width - 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey.shade300,
                          ),
                          child: const Center(child: Icon(Icons.directions_run, size: 60, color: Colors.grey)), // Icon placeholder
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 100),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activityName,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            '4.9', // Contoh rating untuk aktivitas
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '(85 Reviews)', // Contoh jumlah review
                            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                      const Divider(color: Colors.grey, thickness: 1, height: 32),
                      const SizedBox(height: 24),
                      Text(
                        'Detail Aktivitas',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Durasi: 30 menit\nIntensitas: Sedang\nKalori Terbakar: 200-300 kcal', // Placeholder detail aktivitas
                        style: TextStyle(fontSize: 16, height: 1.5),
                      ),
                      const Divider(color: Colors.grey, thickness: 1, height: 32),
                      const SizedBox(height: 24),
                      Text(
                        'Manfaat',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Aktivitas $activityName sangat baik untuk meningkatkan kesehatan jantung, membakar kalori, dan mengurangi stres. Lakukan secara rutin untuk hasil yang optimal.',
                        style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Cara Melakukan',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '1. Mulai dengan pemanasan 5 menit.\n2. Lakukan aktivitas inti selama 20-30 menit.\n3. Akhiri dengan pendinginan 5 menit.',
                        style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ), // Penutup SingleChildScrollView
    ); // Penutup Scaffold
  }
}