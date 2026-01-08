import 'package:glupulse/features/orders/domain/entities/order_item.dart';

class OrderItemModel extends OrderItem {
  const OrderItemModel({
    required super.foodName,
    required super.quantity,
    required super.price,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    num? parseNum(dynamic value) {
      if (value == null) return null;
      if (value is num) return value;
      if (value is String) return num.tryParse(value);
      return null;
    }

    return OrderItemModel(
      foodName: json['food_name']?.toString() ?? '',
      quantity: parseNum(json['quantity'])?.toInt() ?? 0,
      price: parseNum(json['price']) ?? 0,
    );
  }
}
