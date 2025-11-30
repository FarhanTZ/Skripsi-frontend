import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/features/meal_log/domain/entities/meal_log.dart';

abstract class MealLogRepository {
  Future<Either<Failure, List<MealLog>>> getMealLogs();
  Future<Either<Failure, MealLog>> getMealLog(String id);
  Future<Either<Failure, MealLog>> addMealLog(MealLog mealLog);
  Future<Either<Failure, MealLog>> updateMealLog(MealLog mealLog);
  Future<Either<Failure, Unit>> deleteMealLog(String id);
}
