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

  CartItem copyWith({
    String? cartItemId,
    String? foodId,
    int? quantity,
    String? foodName,
    double? price,
    String? photoUrl,
    bool? isSelected,
  }) {
    return CartItem(
      cartItemId: cartItemId ?? this.cartItemId,
      foodId: foodId ?? this.foodId,
      quantity: quantity ?? this.quantity,
      foodName: foodName ?? this.foodName,
      price: price ?? this.price,
      photoUrl: photoUrl ?? this.photoUrl,
      isSelected: isSelected ?? this.isSelected,
    );
  }

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