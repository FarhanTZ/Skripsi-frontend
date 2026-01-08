import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glupulse/features/orders/presentation/pages/order_history_page.dart';
import 'package:glupulse/features/orders/domain/entities/order.dart';
import 'package:glupulse/features/orders/presentation/cubit/order_track_cubit.dart';
import 'package:glupulse/features/orders/presentation/cubit/order_track_state.dart';
import 'package:glupulse/injection_container.dart';
import 'package:intl/intl.dart';

class OrderTrackingPage extends StatelessWidget {
  final Order? order;
  final List<Map<String, dynamic>>? orderItems;
  final double? finalTotal;
  final String orderId;

  const OrderTrackingPage({
    super.key,
    this.order,
    this.orderItems,
    this.finalTotal,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<OrderTrackCubit>()..fetchActiveOrders(),
      child: Scaffold(
        body: Stack(
          children: [
            _OrderTrackingContent(
              orderId: orderId,
              fallbackItems: orderItems,
              fallbackTotal: finalTotal,
              order: order,
            ),
            _buildTransparentAppBar(context),
          ],
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
            color: Colors.white.withValues(alpha: 0.8),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                 Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const OrderHistoryPage()));
              }
            },
          ),
        ),
      ),
    );
  }
}

class _OrderTrackingContent extends StatefulWidget {
  final String orderId;
  final List<Map<String, dynamic>>? fallbackItems;
  final double? fallbackTotal;
  final Order? order;

  const _OrderTrackingContent({
    required this.orderId,
    this.fallbackItems,
    this.fallbackTotal,
    this.order,
  });

  @override
  State<_OrderTrackingContent> createState() => _OrderTrackingContentState();
}

class _OrderTrackingContentState extends State<_OrderTrackingContent> {
  // ignore: unused_field
  bool _isSummaryExpanded = false;
  final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderTrackCubit, OrderTrackState>(
      builder: (context, state) {
        if (state is OrderTrackLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is OrderTrackError) {
           if (widget.order != null) {
             return _buildContent(widget.order!);
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(state.message),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<OrderTrackCubit>().fetchActiveOrders(),
                  child: const Text('Retry'),
                )
              ],
            ),
          );
        } else if (state is OrderTrackLoaded) {
          final order = state.orders.firstWhere(
            (o) => o.orderId == widget.orderId,
            orElse: () => _createFallbackOrder(),
          );

          return _buildContent(order);
        } else if (state is OrderTrackEmpty) {
             final fallbackOrder = _createFallbackOrder();
             return _buildContent(fallbackOrder);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildContent(Order order) {
     return SingleChildScrollView(
            child: Column(
              children: [
                _buildMapPlaceholder(order),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildOrderDetails(order),
                      const SizedBox(height: 24),
                      _buildEstimatedArrival(),
                      const SizedBox(height: 24),
                      _buildTrackingStepper(order.status),
                      const SizedBox(height: 24),
                      _buildOrderSummaryCard(order),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  // Helper untuk membuat objek Order sementara dari data fallback (jika API gagal/kosong)
  Order _createFallbackOrder() {
    if (widget.order != null) return widget.order!;
    
    return Order(
      orderId: widget.orderId,
      storeName: 'Unknown Store',
      totalPrice: widget.fallbackTotal ?? 0,
      status: 'Processing', // Default
      paymentStatus: 'Paid',
      createdAt: DateTime.now().toIso8601String(),
      items: const [], 
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

  Widget _buildMapPlaceholder(Order order) {
    return Container(
      height: 350,
      width: double.infinity,
      color: Colors.grey.shade300,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Simulasi Peta
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.map, size: 80, color: Colors.grey.shade400),
              if (order.sellerLat != null && order.sellerLong != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Store Location:\n${order.sellerLat}, ${order.sellerLong}",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderDetails(Order order) {
    String formattedDate = '';
    try {
      formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(DateTime.parse(order.createdAt));
    } catch (_) {
      formattedDate = order.createdAt;
    }

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
                const Text('Store', style: TextStyle(color: Colors.grey)),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    order.storeName ?? 'N/A',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Order ID', style: TextStyle(color: Colors.grey)),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    order.orderId,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Order Date', style: TextStyle(color: Colors.grey)),
                Text(formattedDate, style: const TextStyle(fontWeight: FontWeight.bold)),
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
              DateFormat('HH:mm').format(DateTime.now().add(const Duration(minutes: 30))),
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

  Widget _buildTrackingStepper(String status) {
    int currentStep = 0;
    final s = status.toLowerCase();
    
    if (s.contains('pending') || s.contains('placed')) {
      currentStep = 0;
    } else if (s.contains('processing') || s.contains('preparing')) {
      currentStep = 1;
    } else if (s.contains('ship') || s.contains('way')) {
      currentStep = 2;
    } else if (s.contains('complete') || s.contains('deliver')) {
      currentStep = 3;
    }

    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Order Status ($status)'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTrackingStepItem(Icons.receipt_long, 'Placed', 0, currentStep),
                _buildTrackingStepItem(Icons.inventory_2_outlined, 'Processing', 1, currentStep),
                _buildTrackingStepItem(Icons.local_shipping_outlined, 'Shipped', 2, currentStep),
                _buildTrackingStepItem(Icons.check_circle_outline, 'Delivered', 3, currentStep),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackingStepItem(IconData icon, String label, int stepIndex, int currentStep) {
    final bool isActive = currentStep >= stepIndex;
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

  Widget _buildOrderSummaryCard(Order order) {
    // Jika items kosong (misal dari fallback yang belum di-mapping sempurna),
    // kita coba gunakan widget.fallbackItems jika tersedia
    final bool useFallbackItems = order.items.isEmpty && widget.fallbackItems != null;

    return Card(
      elevation: 2,
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ExpansionTile(
        initiallyExpanded: true,
        onExpansionChanged: (bool expanded) {
          setState(() => _isSummaryExpanded = expanded);
        },
        title: _buildSectionTitle('Order Summary'),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                if (useFallbackItems)
                  ...widget.fallbackItems!.map((item) {
                     return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text('${item['name']} (x${item['quantity']})')),
                            Text(currencyFormatter.format(item['price'] * item['quantity']))
                          ],
                        ),
                      );
                  })
                else
                  ...order.items.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text('${item.foodName} (x${item.quantity})')),
                          Text(currencyFormatter.format(item.price)), // Harga satuan atau total, tergantung API
                        ],
                      ),
                    );
                  }),
                
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(
                      currencyFormatter.format(order.totalPrice),
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