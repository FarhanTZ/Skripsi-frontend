import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glupulse/app/theme/app_theme.dart';
import 'package:glupulse/features/Food/presentation/cubit/cart_cubit.dart';
import 'package:glupulse/features/Food/domain/entities/food.dart';
import 'package:glupulse/features/seller/presentation/cubit/seller_cubit.dart';
import 'package:glupulse/features/seller/presentation/cubit/seller_state.dart';
import 'package:glupulse/features/seller/presentation/pages/seller_profile_page.dart';
import 'package:glupulse/injection_container.dart';

class FoodDetailPage extends StatefulWidget {
  final Food food;

  const FoodDetailPage({super.key, required this.food});

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<CartCubit>()),
        BlocProvider(
          create: (_) => sl<SellerCubit>(),
        ),
      ],
      child: BlocListener<CartCubit, CartState>(
      listener: (context, state) {
        if (state is CartActionSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                  content: Text('Item berhasil ditambahkan ke keranjang!')),
            );
        } else if (state is CartError) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text('Gagal: ${state.message}')),
            );
        }
      },
      child: Scaffold(
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
                          clipBehavior: Clip.antiAlias,
                          child: SizedBox(
                            height: 180,
                            width: MediaQuery.of(context).size.width - 48, // Lebar kartu disesuaikan
                            child: Image.network(
                            (widget.food.photoUrl != null && widget.food.photoUrl!.isNotEmpty)
                                ? widget.food.photoUrl!
                                : 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
                            headers: const {'ngrok-skip-browser-warning': 'true'},
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const Center(
                              child: Icon(Icons.broken_image, size: 60, color: Colors.grey),
                            ),
                          ),
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
                          widget.food.foodName,
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
                        const SizedBox(height: 16),
                        _buildSellerInfo(),
                        const Divider(color: Colors.grey, thickness: 1, height: 32),
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
                        Text(
                          'Calories: ${widget.food.calories ?? 'N/A'} kcal\nProtein: ${widget.food.proteinGrams ?? 'N/A'} g\nCarbs: ${widget.food.carbsGrams ?? 'N/A'} g\nFat: ${widget.food.fatGrams ?? 'N/A'} g',
                          style: const TextStyle(fontSize: 16, height: 1.5),
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
                          widget.food.description,
                          style: const TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
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
                                    SnackBar(content: Text('$_quantity ${widget.food.foodName} ditambahkan ke keranjang!')),
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
                            BlocBuilder<CartCubit, CartState>(
                              builder: (context, state) {
                                if (state is CartLoadingAction) {
                                  return Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.primary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      ),
                                    ),
                                  );
                                }
                                return GestureDetector(
                                  onTap: () {
                                    context.read<CartCubit>().addItemToCart(
                                          widget.food.foodId,
                                          _quantity,
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
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ), // Penutup SingleChildScrollView
      ),
      ),
    );
  }

  Widget _buildSellerInfo() {
    return InkWell(
      onTap: () {
        if (widget.food.sellerId != 'recommendation') {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SellerProfilePage(
              sellerId: widget.food.sellerId,
              initialStoreName: widget.food.storeName,
            ),
          ));
        }
      },
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              widget.food.sellerId == 'recommendation' ? Icons.recommend : Icons.store,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.food.sellerId == 'recommendation' ? 'Recommended' : 'Seller ID',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  (widget.food.storeName != null && widget.food.storeName!.isNotEmpty) 
                      ? widget.food.storeName! 
                      : widget.food.sellerId,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (widget.food.sellerId != 'recommendation')
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
      ),
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