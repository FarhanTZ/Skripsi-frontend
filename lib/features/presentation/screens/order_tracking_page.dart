import 'package:flutter/material.dart';
import 'package:glupulse/app/theme/app_theme.dart';
import 'package:intl/intl.dart';

class OrderTrackingPage extends StatefulWidget {
  final List<Map<String, dynamic>> orderItems;
  final double finalTotal;
  final String orderId;

  const OrderTrackingPage({
    super.key,
    required this.orderItems,
    required this.finalTotal,
    required this.orderId,
  });

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  // 0: Placed, 1: Processing, 2: Shipped, 3: Delivered
  int _currentStep = 1; // Status pesanan saat ini (contoh: Processing)

  // State untuk accordion
  bool _isSummaryExpanded = false;

  final currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menggunakan Stack untuk menumpuk AppBar di atas peta
      body: Stack(
        children: [
          // Konten utama yang bisa di-scroll
          _buildContent(),
          // AppBar transparan di atas
          _buildTransparentAppBar(context),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // 1. Placeholder untuk Peta
          _buildMapPlaceholder(),
          // Konten lainnya di bawah peta
          Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderDetails(),
            const SizedBox(height: 24),
            _buildEstimatedArrival(),
            const SizedBox(height: 24),
            _buildTrackingStepper(),
                const SizedBox(height: 24),
            _buildOrderSummaryCard(),
          ],
        ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildMapPlaceholder() {
    // Placeholder untuk peta dengan ukuran yang diminta
    return Container(
      height: 350, // Ukuran tinggi peta
      width: double.infinity,
      color: Colors.grey.shade300,
      child: const Center(
        child: Icon(
          Icons.map_outlined,
          size: 80,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildTransparentAppBar(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Track Order', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderDetails() {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Order ID', style: TextStyle(color: Colors.grey)),
                Text(widget.orderId, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Order Date', style: TextStyle(color: Colors.grey)),
                Text(DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now()), style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEstimatedArrival() {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildSectionTitle('Estimated Arrival'),
            Text(
              // Menghitung 10 menit dari sekarang dan memformatnya menjadi jam:menit
              DateFormat('HH:mm').format(DateTime.now().add(const Duration(minutes: 10))),
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackingStepper() {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Order Status'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTrackingStepItem(Icons.receipt_long, 'Placed', 0),
                _buildTrackingStepItem(Icons.inventory_2_outlined, 'Processing', 1),
                _buildTrackingStepItem(Icons.local_shipping_outlined, 'Shipped', 2),
                _buildTrackingStepItem(Icons.check_circle_outline, 'Delivered', 3),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackingStepItem(IconData icon, String label, int stepIndex) {
    final bool isActive = _currentStep >= stepIndex;
    final color = isActive ? Theme.of(context).colorScheme.primary : Colors.grey.shade400;

    return Column(
      children: [
        Icon(icon, color: color, size: 30),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSummaryCard() {
    return Card(
      elevation: 2,
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ExpansionTile(
        onExpansionChanged: (bool expanded) {
          setState(() => _isSummaryExpanded = expanded);
        },
        title: _buildSectionTitle('Order Summary'),
        trailing: Icon(
          _isSummaryExpanded ? Icons.expand_less : Icons.expand_more,
          color: Theme.of(context).colorScheme.primary,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                ...widget.orderItems.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text('${item['name']} (x${item['quantity']})')),
                    Text(currencyFormatter.format(item['price'] * item['quantity'])),
                  ],
                ),
              );
                }).toList(),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(
                      currencyFormatter.format(widget.finalTotal),
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Theme.of(context).colorScheme.primary),
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