import 'package:equatable/equatable.dart';
import 'package:glupulse/features/orders/domain/entities/order.dart';

abstract class OrderHistoryState extends Equatable {
  const OrderHistoryState();

  @override
  List<Object> get props => [];
}

class OrderHistoryInitial extends OrderHistoryState {}

class OrderHistoryLoading extends OrderHistoryState {}

class OrderHistoryLoaded extends OrderHistoryState {
  final List<Order> orders;
  final bool hasReachedMax;

  const OrderHistoryLoaded({required this.orders, this.hasReachedMax = false});

  @override
  List<Object> get props => [orders, hasReachedMax];
}

class OrderHistoryEmpty extends OrderHistoryState {}

class OrderHistoryError extends OrderHistoryState {
  final String message;

  const OrderHistoryError(this.message);

  @override
  List<Object> get props => [message];
}
