import 'package:equatable/equatable.dart';
import 'package:glupulse/features/orders/domain/entities/order.dart';

abstract class OrderTrackState extends Equatable {
  const OrderTrackState();

  @override
  List<Object> get props => [];
}

class OrderTrackInitial extends OrderTrackState {}

class OrderTrackLoading extends OrderTrackState {}

class OrderTrackLoaded extends OrderTrackState {
  final List<Order> orders;

  const OrderTrackLoaded(this.orders);

  @override
  List<Object> get props => [orders];
}

class OrderTrackEmpty extends OrderTrackState {}

class OrderTrackError extends OrderTrackState {
  final String message;

  const OrderTrackError(this.message);

  @override
  List<Object> get props => [message];
}
