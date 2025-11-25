import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/activity/domain/entities/activity_log.dart';
import 'package:glupulse/features/activity/domain/repositories/activity_repository.dart';

class UpdateActivityLog implements UseCase<Unit, UpdateActivityLogParams> {
  final ActivityRepository repository;

  UpdateActivityLog(this.repository);

  @override
  Future<Either<Failure, Unit>> call(UpdateActivityLogParams params) async {
    return await repository.updateActivityLog(params.activityLog);
  }
}

class UpdateActivityLogParams extends Equatable {
  final ActivityLog activityLog;

  const UpdateActivityLogParams({required this.activityLog});

  @override
  List<Object> get props => [activityLog];
}
