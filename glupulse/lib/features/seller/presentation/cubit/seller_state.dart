import 'package:equatable/equatable.dart';
import 'package:glupulse/features/seller/domain/entities/seller.dart';

abstract class SellerState extends Equatable {
  const SellerState();

  @override
  List<Object> get props => [];
}

class SellerInitial extends SellerState {}

class SellerLoading extends SellerState {}

class SellerLoaded extends SellerState {
  final Seller seller;

  const SellerLoaded({required this.seller});

  @override
  List<Object> get props => [seller];
}

class SellerError extends SellerState {
  final String message;

  const SellerError({required this.message});

  @override
  List<Object> get props => [message];
}
