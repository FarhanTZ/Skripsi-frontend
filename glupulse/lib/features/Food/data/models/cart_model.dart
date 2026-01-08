

import 'package:glupulse/features/Food/data/models/cart_item_model.dart';
import 'package:glupulse/features/Food/domain/entities/cart.dart';

class CartModel extends Cart {
  const CartModel({
    required String cartId,
    required String userId,
    required double subtotal,
    required List<CartItemModel> items,
  }) : super(
          cartId: cartId,
          userId: userId,
          subtotal: subtotal,
          items: items,
        );

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      cartId: json['cart_id'],
      userId: json['user_id'],
      subtotal: (json['subtotal'] as num).toDouble(),
      items: (json['items'] as List)
          .map((itemJson) => CartItemModel.fromJson(itemJson))
          .toList(),
    );
  }

  // toJson tidak diperlukan untuk get, tapi bisa ditambahkan jika ada fitur update
}