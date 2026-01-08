import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/activity/domain/entities/activity_log.dart';
import 'package:glupulse/features/activity/domain/repositories/activity_repository.dart';

class AddActivityLog implements UseCase<Unit, AddActivityLogParams> {
  final ActivityRepository repository;

  AddActivityLog(this.repository);

  @override
  Future<Either<Failure, Unit>> call(AddActivityLogParams params) async {
    return await repository.addActivityLog(params.activityLog);
  }
}

class AddActivityLogParams extends Equatable {
  final ActivityLog activityLog;

  const AddActivityLogParams({required this.activityLog});

  @override
  List<Object> get props => [activityLog];
}
