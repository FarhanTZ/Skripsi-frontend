import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/Food/domain/repositories/food_repository.dart';

class AddToCartUseCase implements UseCase<void, AddToCartParams> {
  final FoodRepository repository;

  AddToCartUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(AddToCartParams params) async {
    return await repository.addToCart(params.foodId, params.quantity);
  }
}

class AddToCartParams extends Equatable {
  final String foodId;
  final int quantity;

  const AddToCartParams({required this.foodId, required this.quantity});

  @override
  List<Object?> get props => [foodId, quantity];
}