import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glupulse/features/orders/domain/entities/order.dart';
import 'package:glupulse/features/orders/presentation/cubit/order_history_cubit.dart';
import 'package:glupulse/features/orders/presentation/cubit/order_history_state.dart';
import 'package:glupulse/features/orders/presentation/pages/order_tracking_page.dart';
import 'package:glupulse/injection_container.dart';
import 'package:intl/intl.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<OrderHistoryCubit>()..fetchOrderHistory(),
      child: Scaffold(
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
        body: BlocBuilder<OrderHistoryCubit, OrderHistoryState>(
          builder: (context, state) {
            if (state is OrderHistoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is OrderHistoryError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<OrderHistoryCubit>().fetchOrderHistory(),
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              );
            } else if (state is OrderHistoryEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.history, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text('Belum ada riwayat pesanan.'),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => context.read<OrderHistoryCubit>().fetchOrderHistory(),
                      child: const Text('Refresh'),
                    ),
                  ],
                ),
              );
            } else if (state is OrderHistoryLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<OrderHistoryCubit>().fetchOrderHistory();
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: state.orders.length,
                  itemBuilder: (context, index) {
                    final order = state.orders[index];
                    return _OrderHistoryCard(order: order);
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _OrderHistoryCard extends StatelessWidget {
  final Order order;

  const _OrderHistoryCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    
    // Status Logic
    // API: 'completed', 'unpaid', 'pending payment'
    final statusLower = order.status.toLowerCase();
    final isCompleted = statusLower == 'completed';
    final isPending = statusLower.contains('pending') || statusLower == 'unpaid';
    
    Color statusColor;
    Color statusTextColor;

    if (isCompleted) {
      statusColor = Colors.green.withValues(alpha: 0.1);
      statusTextColor = Colors.green;
    } else if (isPending) {
      statusColor = Colors.orange.withValues(alpha: 0.1);
      statusTextColor = Colors.orange;
    } else {
      statusColor = Colors.blue.withValues(alpha: 0.1);
      statusTextColor = Colors.blue;
    }

    String formattedDate = '';
    try {
      formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(DateTime.parse(order.createdAt));
    } catch (_) {
      formattedDate = order.createdAt;
    }

    return Card(
      elevation: 2,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          // Navigasi ke Tracking Page
          // Kita kirim data yang ada saat ini sebagai fallback
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => OrderTrackingPage(
              // Karena Order di domain sudah punya List<OrderItem>, kita perlu mapping manual jika OrderTrackingPage butuh List<Map>
              // Tapi idealnya OrderTrackingPage diperbarui juga untuk terima entity Order.
              // Untuk saat ini kita passing orderId saja, karena OrderTrackingPage akan fetch ulang.
              orderId: order.orderId,
              finalTotal: order.totalPrice.toDouble(),
              order: order,
              // orderItems: [], // Biarkan kosong/null, biar fetch sendiri
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
                  Expanded(
                    child: Text(
                      order.storeName ?? 'Order #${order.orderId.substring(0, 8)}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      order.status, // Tampilkan status asli dari API
                      style: TextStyle(
                        color: statusTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                formattedDate,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 16),
              // Menampilkan daftar item pesanan (Max 3 items preview)
              ...order.items.take(3).map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    '• ${item.foodName} (x${item.quantity})',
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                );
              }),
              if (order.items.length > 3)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    '+ ${order.items.length - 3} more items',
                    style: const TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
                  ),
                ),

              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    currencyFormatter.format(order.totalPrice),
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
  }
}
