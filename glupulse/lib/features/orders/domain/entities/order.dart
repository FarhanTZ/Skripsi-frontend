import 'package:equatable/equatable.dart';
import 'package:glupulse/features/orders/domain/entities/order_address.dart';
import 'package:glupulse/features/orders/domain/entities/order_item.dart';

class Order extends Equatable {
  final String orderId;
  final String? storeName;
  final String? storePhone;
  final double? sellerLat;
  final double? sellerLong;
  final num totalPrice;
  final String status;
  final String paymentStatus;
  final OrderAddress? deliveryAddress;
  final String createdAt;
  final List<OrderItem> items;

  const Order({
    required this.orderId,
    this.storeName,
    this.storePhone,
    this.sellerLat,
    this.sellerLong,
    required this.totalPrice,
    required this.status,
    required this.paymentStatus,
    this.deliveryAddress,
    required this.createdAt,
    required this.items,
  });

  @override
  List<Object?> get props => [
        orderId,
        storeName,
        storePhone,
        sellerLat,
        sellerLong,
        totalPrice,
        status,
        paymentStatus,
        deliveryAddress,
        createdAt,
        items,
      ];
}
