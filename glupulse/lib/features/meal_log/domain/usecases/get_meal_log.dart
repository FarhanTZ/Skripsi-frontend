import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/meal_log/domain/entities/meal_log.dart';
import 'package:glupulse/features/meal_log/domain/repositories/meal_log_repository.dart';
import 'package:equatable/equatable.dart';

class GetMealLog implements UseCase<MealLog, GetMealLogParams> {
  final MealLogRepository repository;

  GetMealLog(this.repository);

  @override
  Future<Either<Failure, MealLog>> call(GetMealLogParams params) async {
    return await repository.getMealLog(params.id);
  }
}

class GetMealLogParams extends Equatable {
  final String id;

  const GetMealLogParams({required this.id});

  @override
  List<Object> get props => [id];
}
