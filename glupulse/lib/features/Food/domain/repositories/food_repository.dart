import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/features/Food/domain/entities/food.dart';

abstract class FoodRepository {
  Future<Either<Failure, List<Food>>> getFoods();
}