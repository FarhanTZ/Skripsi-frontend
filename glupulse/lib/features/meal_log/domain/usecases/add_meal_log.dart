import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/meal_log/domain/entities/meal_log.dart';
import 'package:glupulse/features/meal_log/domain/repositories/meal_log_repository.dart';
import 'package:equatable/equatable.dart';

class AddMealLog implements UseCase<MealLog, AddMealLogParams> {
  final MealLogRepository repository;

  AddMealLog(this.repository);

  @override
  Future<Either<Failure, MealLog>> call(AddMealLogParams params) async {
    return await repository.addMealLog(params.mealLog);
  }
}

class AddMealLogParams extends Equatable {
  final MealLog mealLog;

  const AddMealLogParams({required this.mealLog});

  @override
  List<Object> get props => [mealLog];
}
