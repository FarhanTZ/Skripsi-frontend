

import 'package:glupulse/features/Food/domain/entities/cart_item.dart';

class CartItemModel extends CartItem {
  const CartItemModel({
    required super.cartItemId,
    required super.foodId,
    required super.quantity,
    required super.foodName,
    required super.price,
    super.photoUrl,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      cartItemId: json['cart_item_id'],
      foodId: json['food_id'],
      quantity: json['quantity'],
      foodName: json['food_name'],
      price: (json['price'] as num).toDouble(),
      photoUrl: json['photo_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'food_id': foodId,
      'quantity': quantity,
    };
  }
}