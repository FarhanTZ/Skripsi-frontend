import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/Food/domain/entities/food.dart';
import 'package:glupulse/features/Food/domain/repositories/food_repository.dart';


class GetFoods implements UseCase<List<Food>, NoParams> {
  final FoodRepository repository;

  GetFoods(this.repository);

  @override
  Future<Either<Failure, List<Food>>> call(NoParams params) async => await repository.getFoods();
}