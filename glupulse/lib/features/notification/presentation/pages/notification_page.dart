import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  // Data dummy untuk notifikasi
  final List<Map<String, dynamic>> _notifications = const [
    {
      'type': 'order',
      'title': 'Order In Delivery',
      'subtitle': 'Your order GLU-1678972800 is on its way to you.',
      'time': '5m ago',
    },
    {
      'type': 'chat',
      'title': 'New Message from Dr. Strange',
      'subtitle': 'Hello, please check your latest health report...',
      'time': '1h ago',
    },
    {
      'type': 'health',
      'title': 'Health Data Updated',
      'subtitle': 'Your blood sugar and pressure data has been saved.',
      'time': '3h ago',
    },
    {
      'type': 'order',
      'title': 'Order Completed',
      'subtitle': 'Your order GLU-1678886400 has been delivered.',
      'time': '1d ago',
    },
    {
      'type': 'promo',
      'title': 'Special Promo For You!',
      'subtitle': 'Get 20% off for your next healthy meal purchase.',
      'time': '2d ago',
    },
  ];

  // Helper untuk mendapatkan ikon dan warna berdasarkan tipe notifikasi
  Map<String, dynamic> _getNotificationStyle(String type) {
    switch (type) {
      case 'order':
        return {'icon': Icons.receipt_long_outlined, 'color': Colors.blue};
      case 'chat':
        return {'icon': Icons.chat_bubble_outline, 'color': Colors.green};
      case 'health':
        return {'icon': Icons.favorite_border, 'color': Colors.redAccent};
      case 'promo':
        return {'icon': Icons.local_offer_outlined, 'color': Colors.orange};
      default:
        return {'icon': Icons.notifications_none, 'color': Colors.grey};
    }
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
          'Notifications',
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
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          final style = _getNotificationStyle(notification['type'] as String);

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: (style['color'] as Color).withValues(alpha: 0.1),
                child: Icon(style['icon'] as IconData, color: style['color'] as Color),
              ),
              title: Text(
                notification['title'] as String,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                notification['subtitle'] as String,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Text(
                notification['time'] as String,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              onTap: () {
                // TODO: Implement navigation based on notification type
              },
            ),
          );
        },
      ),
    );
  }
}