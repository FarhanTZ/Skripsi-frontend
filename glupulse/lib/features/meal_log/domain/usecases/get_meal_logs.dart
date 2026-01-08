import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/meal_log/domain/entities/meal_log.dart';
import 'package:glupulse/features/meal_log/domain/repositories/meal_log_repository.dart';

class GetMealLogs implements UseCase<List<MealLog>, NoParams> {
  final MealLogRepository repository;

  GetMealLogs(this.repository);

  @override
  Future<Either<Failure, List<MealLog>>> call(NoParams params) async {
    return await repository.getMealLogs();
  }
}
