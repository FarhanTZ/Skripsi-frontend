import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/meal_log/domain/entities/meal_log.dart';
import 'package:glupulse/features/meal_log/domain/repositories/meal_log_repository.dart';
import 'package:equatable/equatable.dart';

class UpdateMealLog implements UseCase<MealLog, UpdateMealLogParams> {
  final MealLogRepository repository;

  UpdateMealLog(this.repository);

  @override
  Future<Either<Failure, MealLog>> call(UpdateMealLogParams params) async {
    return await repository.updateMealLog(params.mealLog);
  }
}

class UpdateMealLogParams extends Equatable {
  final MealLog mealLog;

  const UpdateMealLogParams({required this.mealLog});

  @override
  List<Object> get props => [mealLog];
}
