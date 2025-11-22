import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final String cartItemId;
  final String foodId;
  final int quantity;
  final String foodName;
  final double price;
  final String? photoUrl;
  final bool isSelected; // Ditambahkan untuk UI state

  const CartItem({
    required this.cartItemId,
    required this.foodId,
    required this.quantity,
    required this.foodName,
    required this.price,
    this.photoUrl,
    this.isSelected = true, // Default terpilih saat dimuat
  });

  @override
  List<Object?> get props => [
        cartItemId,
        foodId,
        quantity,
        foodName,
        price,
        photoUrl,
        isSelected,
      ];
}