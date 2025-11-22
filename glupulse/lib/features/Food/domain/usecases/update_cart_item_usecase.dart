import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/Food/domain/repositories/food_repository.dart';

class UpdateCartItemUseCase implements UseCase<void, UpdateCartItemParams> {
  final FoodRepository repository;

  UpdateCartItemUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateCartItemParams params) async {
    return await repository.updateCartItem(params.foodId, params.quantity);
  }
}

class UpdateCartItemParams extends Equatable {
  final String foodId;
  final int quantity;

  const UpdateCartItemParams({required this.foodId, required this.quantity});

  @override
  List<Object?> get props => [foodId, quantity];
}