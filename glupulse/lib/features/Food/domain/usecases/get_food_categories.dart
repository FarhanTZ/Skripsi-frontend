import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/Food/domain/entities/food_category.dart';
import 'package:glupulse/features/Food/domain/repositories/food_repository.dart';

class GetFoodCategories implements UseCase<List<FoodCategory>, NoParams> {
  final FoodRepository repository;

  GetFoodCategories(this.repository);

  @override
  Future<Either<Failure, List<FoodCategory>>> call(NoParams params) async {
    return await repository.getFoodCategories();
  }
}
