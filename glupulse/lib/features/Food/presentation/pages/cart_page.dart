import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glupulse/features/Food/domain/entities/cart_item.dart';
import 'package:glupulse/features/Food/presentation/cubit/cart_cubit.dart';
import 'package:glupulse/features/Food/presentation/pages/payment_order_page.dart';
import 'package:glupulse/injection_container.dart';
import 'package:intl/intl.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem> _cartItems = [];
  final currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  // Getter untuk mengecek apakah semua item terpilih
  bool get _isAllSelected {
    if (_cartItems.isEmpty) {
      return false; // Atau true, tergantung perilaku yang diinginkan untuk keranjang kosong
    }
    return _cartItems.every((item) => item.isSelected);
  }

  // Menghitung total harga dari item yang dipilih
  double get _totalPrice {
    double total = 0;
    for (var item in _cartItems) {
      if (item.isSelected) {
        total += item.price * item.quantity;
      }
    }
    return total;
  }

  @override
  void initState() {
    super.initState();
    // Panggil cubit untuk fetch data saat halaman dibuka
    context.read<CartCubit>().fetchCart();
  }
  // Metode untuk memilih/membatalkan pilihan semua item
  void _toggleSelectAll(bool? value) {
    setState(() {
      final bool newSelectAllState = value ?? false;
      for (var item in _cartItems) {
        // Ini perlu diubah karena CartItem immutable.
        // Kita akan handle ini di state management yang lebih baik nanti,
        // untuk sekarang kita akan buat list baru.
        // Atau, kita bisa membuat CartItem menjadi class biasa (bukan const)
        // dan menghapus Equatable jika state lokal seperti ini diperlukan.
        // Untuk sementara, kita akan mengabaikan immutability untuk contoh ini.
        // (item as dynamic).isSelected = newSelectAllState; // Ini cara kotor
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      appBar: AppBar(
        toolbarHeight: 80,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        title: const Text(
          'Keranjang Belanja',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocConsumer<CartCubit, CartState>(
        listener: (context, state) {
          if (state is CartLoaded) {
            setState(() {
              _cartItems = state.cart.items;
            });
          } else if (state is CartError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CartLoaded && _cartItems.isNotEmpty) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
                    itemCount: _cartItems.length,
                    itemBuilder: (context, index) {
                      final item = _cartItems[index];
                      return _buildCartItem(item);
                    },
                  ),
                ),
              ],
            );
          }
          if (state is CartLoaded && _cartItems.isEmpty) {
            return const Center(child: Text('Keranjang Anda kosong.'));
          }
          if (state is CartError) {
            return Center(child: Text('Gagal memuat keranjang: ${state.message}'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      bottomNavigationBar: _buildCheckoutBar(),
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
              value: item.isSelected,
              onChanged: (bool? value) {
                // TODO: Implement logic to update item selection state
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              activeColor: Theme.of(context).colorScheme.primary,
            ),
            const Text(
              'Select Item',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ],
        ),
        const SizedBox(height: 4),
        _buildCartItemCard(item),
      ],
    );
  }

  void _incrementQuantity(CartItem item) {
    setState(() {
      // TODO: Panggil API untuk update kuantitas
      // item.quantity++;
    });
  }

  void _decrementQuantity(CartItem item) {
    setState(() {
      if (item.quantity > 1) {
        // TODO: Panggil API untuk update kuantitas
        // item.quantity--;
      } else {
        // TODO: Panggil API untuk hapus item
        _cartItems.removeWhere((i) => i.cartItemId == item.cartItemId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${item.foodName} dihapus dari keranjang.')),
        );
      }
    });
  }

  // Helper widget untuk tombol kuantitas
  Widget _buildQuantityButton({required IconData icon, required VoidCallback onPressed}) {
    return InkWell(
      onTap: onPressed,
      customBorder: const CircleBorder(), // Membuat efek ripple menjadi lingkaran
      child: Container(
        padding: const EdgeInsets.all(6), // Sedikit menambah padding
        decoration: BoxDecoration(
          color: Colors.grey.shade200, // Warna latar belakang abu-abu
          shape: BoxShape.circle, // Bentuk lingkaran
        ),
        child: Icon(icon, size: 18, color: Colors.black54), // Warna ikon abu-abu tua
      ),
    );
  }

  // Widget untuk membuat kartu item di keranjang
  Widget _buildCartItemCard(CartItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Gambar Item
            SizedBox(
              width: 80,
              height: 80,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: item.photoUrl != null && item.photoUrl!.isNotEmpty
                    ? Image.network(
                        item.photoUrl!,
                        fit: BoxFit.cover,
                        headers: const {'ngrok-skip-browser-warning': 'true'},
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image,
                                color: Colors.grey, size: 40),
                      )
                    : Container(
                        color: Colors.grey.shade200,
                        child: Icon(Icons.fastfood,
                            color: Colors.grey.shade400, size: 40),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            // Detail Item (Nama, Deskripsi, Harga)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [                  
                  Text(
                    item.foodName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currencyFormatter.format(item.price),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            // Kontrol Kuantitas
            Row(
              children: [
                _buildQuantityButton(
                  icon: Icons.remove,
                  onPressed: () => _decrementQuantity(item),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('${item.quantity}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                _buildQuantityButton(
                  icon: Icons.add,
                  onPressed: () => _incrementQuantity(item),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // Widget untuk membuat bar checkout di bagian bawah
  Widget _buildCheckoutBar() {
    return Container(
      padding: EdgeInsets.only(
        top: 16,
        left: 24,
        right: 24,
        bottom: 16 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSelectAllSection(), // Pindahkan "Pilih Semua" ke sini
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Total Price',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currencyFormatter.format(_totalPrice),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              final selectedItems =
                  _cartItems.where((item) => item.isSelected).toList();

              if (selectedItems.isNotEmpty) {
                // Konversi dari CartItem ke Map<String, dynamic> yang diharapkan PaymentOrderPage
                final orderItems = selectedItems.map((item) {
                  return {
                    'name': item.foodName,
                    'quantity': item.quantity,
                    'price': item.price,
                  };
                }).toList();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PaymentOrderPage(
                    orderItems: orderItems,
                    totalPrice: _totalPrice,
                  ),
                ));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pilih item terlebih dahulu untuk checkout.')));
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: const Text('Checkout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // Widget untuk bagian "Pilih Semua"
  Widget _buildSelectAllSection() {
    return InkWell(
      onTap: () => _toggleSelectAll(!_isAllSelected),
      child: Row(
        children: [
          Checkbox(
            value: _isAllSelected,
            onChanged: _toggleSelectAll,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            activeColor: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 4),
          const Text(
            'Pilih Semua',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}