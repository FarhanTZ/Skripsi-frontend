import 'package:flutter/material.dart';
import 'package:glupulse/app/theme/app_theme.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Data dummy untuk item di keranjang
  final List<Map<String, dynamic>> _cartItems = [
    {
      'id': 1,
      'name': 'Oatmeal Sehat',
      'description': 'Sarapan pagi bergizi',
      'price': 25000,
      'quantity': 1,
      'isSelected': false,
      'rating': 4.8,
      'reviewCount': 120,
    },
    {
      'id': 2,
      'name': 'Jus Alpukat',
      'description': 'Minuman segar tanpa gula',
      'price': 15000,
      'quantity': 2,
      'isSelected': true,
      'rating': 4.5,
      'reviewCount': 95,
    },
    {
      'id': 3,
      'name': 'Salmon Panggang',
      'description': 'Kaya Omega-3 dan protein',
      'price': 75000,
      'quantity': 1,
      'isSelected': false,
      'rating': 4.9,
      'reviewCount': 210,
    },
    {
      'id': 4,
      'name': 'Salad Sayur Segar',
      'description': 'Penuh vitamin dan mineral',
      'price': 35000,
      'quantity': 1,
      'isSelected': true,
      'rating': 4.7,
      'reviewCount': 150,
    },
  ];

  // Getter untuk mengecek apakah semua item terpilih
  bool get _isAllSelected {
    if (_cartItems.isEmpty) {
      return false; // Atau true, tergantung perilaku yang diinginkan untuk keranjang kosong
    }
    return _cartItems.every((item) => item['isSelected']);
  }

  // Menghitung total harga dari item yang dipilih
  double get _totalPrice {
    double total = 0;
    for (var item in _cartItems) {
      if (item['isSelected']) {
        total += item['price'] * item['quantity'];
      }
    }
    return total;
  }

  // Metode untuk memilih/membatalkan pilihan semua item
  void _toggleSelectAll(bool? value) {
    setState(() {
      final bool newSelectAllState = value ?? false;
      for (var item in _cartItems) {
        item['isSelected'] = newSelectAllState;
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
              itemCount: _cartItems.length,
              itemBuilder: (context, index) {
                final item = _cartItems[index];
                // Bungkus Checkbox dan Card dalam satu Column
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Checkbox "polos" di atas card
                    Row(
                      children: [
                        Checkbox(
                          value: item['isSelected'],
                          onChanged: (bool? value) => setState(() => item['isSelected'] = value ?? false),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4), // Membuat checkbox menjadi kotak lengkung
                          ),
                          activeColor: Theme.of(context).colorScheme.primary,
                        ),
                        const Text(
                          'Select Item',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold, // Membuat teks menjadi tebal
                            color: Colors.black, // Mengubah warna teks menjadi hitam
                          ),
                        ),
                      ],
                    ),
                    // Sedikit mengurangi jarak antara checkbox dan card
                    const SizedBox(height: 4), 
                    _buildCartItemCard(item),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildCheckoutBar(),
    );
  }

  void _incrementQuantity(Map<String, dynamic> item) {
    setState(() {
      item['quantity']++;
    });
  }

  void _decrementQuantity(Map<String, dynamic> item) {
    setState(() {
      if (item['quantity'] > 1) {
        item['quantity']--;
      } else {
        // Jika kuantitas 1 dan dikurangi, hapus item dari keranjang
        _cartItems.removeWhere((i) => i['id'] == item['id']);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${item['name']} dihapus dari keranjang.')),
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
  Widget _buildCartItemCard(Map<String, dynamic> item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Gambar Item (Placeholder)
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.fastfood, color: Colors.grey.shade400, size: 40),
            ),
            const SizedBox(width: 12),
            // Detail Item (Nama, Deskripsi, Harga)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${item['rating']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(${item['reviewCount']} Reviews)',
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                      ),
                    ],
                  ),                  
                  const SizedBox(height: 8),
                  Text(
                    'Rp ${item['price']}',
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
                  child: Text('${item['quantity']}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                    'Rp ${_totalPrice.toStringAsFixed(0)}',
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
              // TODO: Implementasi logika checkout
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