import 'package:glupulse/features/orders/data/models/order_address_model.dart';
import 'package:glupulse/features/orders/data/models/order_item_model.dart';
import 'package:glupulse/features/orders/domain/entities/order.dart';

class OrderModel extends Order {
  const OrderModel({
    required super.orderId,
    super.storeName,
    super.storePhone,
    super.sellerLat,
    super.sellerLong,
    required super.totalPrice,
    required super.status,
    required super.paymentStatus,
    super.deliveryAddress,
    required super.createdAt,
    required super.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    num? parseNum(dynamic value) {
      if (value == null) return null;
      if (value is num) return value;
      if (value is String) return num.tryParse(value);
      return null;
    }

    return OrderModel(
      orderId: json['order_id']?.toString() ?? '',
      storeName: json['store_name']?.toString(),
      storePhone: json['store_phone']?.toString(),
      sellerLat: parseNum(json['seller_lat'])?.toDouble(),
      sellerLong: parseNum(json['seller_long'])?.toDouble(),
      totalPrice: parseNum(json['total_price']) ?? 0,
      status: json['status']?.toString() ?? 'unknown',
      paymentStatus: json['payment_status']?.toString() ?? 'unknown',
      deliveryAddress: json['delivery_address'] != null
          ? OrderAddressModel.fromJson(json['delivery_address'] as Map<String, dynamic>)
          : null,
      createdAt: json['created_at']?.toString() ?? '',
      items: json['items'] != null
          ? (json['items'] as List).map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>)).toList()
          : [],
    );
  }
}
