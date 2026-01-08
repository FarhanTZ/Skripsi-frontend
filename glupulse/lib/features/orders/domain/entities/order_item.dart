import 'package:equatable/equatable.dart';

class OrderItem extends Equatable {
  final String foodName;
  final int quantity;
  final num price;

  const OrderItem({
    required this.foodName,
    required this.quantity,
    required this.price,
  });

  @override
  List<Object?> get props => [foodName, quantity, price];
}
