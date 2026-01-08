import 'package:equatable/equatable.dart';
import 'package:glupulse/features/Food/domain/entities/cart_item.dart';

class Cart extends Equatable {
  final String cartId;
  final String userId;
  final double subtotal;
  final List<CartItem> items;

  const Cart({
    required this.cartId,
    required this.userId,
    required this.subtotal,
    required this.items,
  });

  @override
  List<Object?> get props => [cartId, userId, subtotal, items];
}