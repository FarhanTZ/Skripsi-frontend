import 'package:flutter/material.dart';
import 'package:glupulse/app/theme/app_theme.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FoodDetailPage extends StatefulWidget {
  final String foodName;

  const FoodDetailPage({super.key, required this.foodName});

  @override
  State<FoodDetailPage> createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends State<FoodDetailPage> {
  int _quantity = 1;

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Detail Makanan', // Judul AppBar
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
            child: Column(
              children: [
                // Stack untuk menumpuk header biru dan kartu gambar
                Stack(
                  alignment: Alignment.topCenter,
                  clipBehavior: Clip.none, // Izinkan kartu keluar dari batas Stack
                  children: [
                    // Header Biru sebagai latar belakang
                    Container(
                      height: 250, // Tinggi untuk gambar dan sedikit ruang
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(40),
                        ),
                      ),
                    ),
                    // Kartu gambar yang tumpang tindih, sekarang di dalam Stack konten
                    Positioned(
                      top: 150, // Posisi dari atas: (tinggi header) - (offset yang diinginkan)
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: Container(
                          height: 180,
                          width: MediaQuery.of(context).size.width - 48, // Lebar kartu disesuaikan
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            // Placeholder untuk gambar makanan
                            color: Colors.grey.shade300,
                          ),
                          child: const Center(child: Icon(Icons.image, size: 60, color: Colors.grey)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 100), // Ruang untuk card yang tumpang tindih
                // Konten detail makanan di bawah
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Menampilkan nama makanan sebagai judul utama konten
                      Text(
                        widget.foodName,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Widget untuk menampilkan rating dan bintang
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            '4.8', // Contoh rating
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '(120 Reviews)', // Contoh jumlah review
                            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                      const Divider(color: Colors.grey, thickness: 1, height: 32), // Garis di bawah rating
                      const SizedBox(height: 24),
                      Text(
                        'Nutrition Facts',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Placeholder untuk detail nutrisi
                      const Text(
                        'Calories: 150 kcal\nProtein: 5g\nCarbs: 30g\nFat: 1g',
                        style: TextStyle(fontSize: 16, height: 1.5),
                      ),
                      const Divider(color: Colors.grey, thickness: 1, height: 32), // Garis di bawah nutrisi
                      const SizedBox(height: 24),
                      Text(
                        'Deskripsi',
                         style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Ini adalah detail untuk ${widget.foodName}. Makanan ini merupakan pilihan yang baik untuk diet sehat Anda, kaya akan nutrisi penting untuk membantu menjaga kadar gula darah dan kesehatan tubuh secara keseluruhan.',
                        style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
                      ),
                      const SizedBox(height: 24), // Spasi sebelum quantity selector
                      // Widget untuk menambah/mengurangi jumlah pesanan
                      Row(
                        children: [
                          _buildQuantityButton(icon: Icons.remove, onPressed: _decrementQuantity),
                          const Spacer(),
                          Text(
                            '$_quantity',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          _buildQuantityButton(icon: Icons.add, onPressed: _incrementQuantity),
                        ],
                      ),
                      const SizedBox(height: 24), // Spasi sebelum tombol checkout
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // TODO: Implementasi logika checkout di sini
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('$_quantity ${widget.foodName} ditambahkan ke keranjang!')),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.primary, // Warna biru dari tema
                                foregroundColor: Colors.white, // Warna teks putih
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              ),
                              child: const Text('Checkout', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: () {
                              // TODO: Implementasi logika tambah ke keranjang
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Item ditambahkan ke keranjang!')),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                              child: SvgPicture.asset(
                                'assets/images/shopping_cart.svg', // Menggunakan SVG
                                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                                width: 24,
                                height: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ), // Penutup SingleChildScrollView
    );
  }

  // Helper widget untuk tombol kuantitas
  Widget _buildQuantityButton({required IconData icon, required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.inputFieldColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
        ),
        onPressed: onPressed,
      ),
    );
  }
}