import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/Food/domain/repositories/food_repository.dart';

class CheckoutUseCase implements UseCase<void, CheckoutParams> {
  final FoodRepository repository;

  CheckoutUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(CheckoutParams params) async {
    return await repository.checkout(params.addressId, params.paymentMethod);
  }
}

class CheckoutParams extends Equatable {
  final String addressId;
  final String paymentMethod;

  const CheckoutParams({required this.addressId, required this.paymentMethod});

  @override
  List<Object?> get props => [addressId, paymentMethod];
}
