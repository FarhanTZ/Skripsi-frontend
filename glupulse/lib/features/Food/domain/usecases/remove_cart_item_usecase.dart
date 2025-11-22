import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/Food/domain/repositories/food_repository.dart';

class RemoveCartItemUseCase implements UseCase<void, RemoveCartItemParams> {
  final FoodRepository repository;

  RemoveCartItemUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(RemoveCartItemParams params) async {
    return await repository.removeCartItem(params.foodId);
  }
}

class RemoveCartItemParams extends Equatable {
  final String foodId;
  const RemoveCartItemParams({required this.foodId});
  @override
  List<Object?> get props => [foodId];
}