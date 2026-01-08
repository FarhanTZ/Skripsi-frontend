part of 'cart_cubit.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoadingAction extends CartState {}

class CartActionSuccess extends CartState {}

class CartLoaded extends CartState {
  final Cart cart;

  const CartLoaded({required this.cart});

  @override
  List<Object> get props => [cart];
}

class CartError extends CartState {
  final String message;

  const CartError({required this.message});

  @override
  List<Object> get props => [message];
}