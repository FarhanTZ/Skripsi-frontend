import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/meal_log/domain/repositories/meal_log_repository.dart';
import 'package:equatable/equatable.dart';

class DeleteMealLog implements UseCase<Unit, DeleteMealLogParams> {
  final MealLogRepository repository;

  DeleteMealLog(this.repository);

  @override
  Future<Either<Failure, Unit>> call(DeleteMealLogParams params) async {
    return await repository.deleteMealLog(params.id);
  }
}

class DeleteMealLogParams extends Equatable {
  final String id;

  const DeleteMealLogParams({required this.id});

  @override
  List<Object> get props => [id];
}
