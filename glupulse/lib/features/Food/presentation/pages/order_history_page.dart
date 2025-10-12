import 'package:flutter/material.dart';
import 'package:glupulse/features/Food/presentation/pages/order_tracking_page.dart';
import 'package:intl/intl.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  // Data dummy untuk riwayat pesanan
  final List<Map<String, dynamic>> _orderHistory = const [
    {
      'id': 'GLU-1678972800',
      'date': '2024-05-22 14:00:00',
      'total': 50000.0,
      'status': 'In Delivery',
      'items': [
        {'name': 'Oatmeal Sehat', 'quantity': 2, 'price': 25000},
      ],
    },
    {
      'id': 'GLU-1678886400',
      'date': '2024-05-20 10:30:00',
      'total': 110000.0,
      'status': 'Completed',
      'items': [
        {'name': 'Salmon Panggang', 'quantity': 1, 'price': 75000},
        {'name': 'Salad Sayur Segar', 'quantity': 1, 'price': 35000},
      ],
    },
    {
      'id': 'GLU-1679059200',
      'date': '2024-05-18 09:15:00',
      'total': 30000.0,
      'status': 'Completed',
      'items': [
        {'name': 'Jus Alpukat', 'quantity': 2, 'price': 15000},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

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
          'Order History',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _orderHistory.length,
        itemBuilder: (context, index) {
          final order = _orderHistory[index];
          final isCompleted = order['status'] == 'Completed';

          return Card(
            elevation: 2,
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: InkWell(
              onTap: isCompleted ? null : () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => OrderTrackingPage(
                    orderItems: (order['items'] as List).cast<Map<String, dynamic>>(),
                    finalTotal: order['total'] as double,
                    orderId: order['id'] as String,
                  ),
                ));
              },
              borderRadius: BorderRadius.circular(15),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          order['id'] as String,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isCompleted ? Colors.green.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            order['status'] as String,
                            style: TextStyle(
                              color: isCompleted ? Colors.green : Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DateFormat('dd MMM yyyy, HH:mm').format(DateTime.parse(order['date'] as String)),
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    // Menampilkan daftar item pesanan
                    ...(order['items'] as List<Map<String, dynamic>>).map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          '• ${item['name']} (x${item['quantity']})',
                          style: const TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                      );
                    }).toList(),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: const TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          currencyFormatter.format(order['total']),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}