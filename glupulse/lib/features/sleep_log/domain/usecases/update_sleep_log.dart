import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/sleep_log/domain/entities/sleep_log.dart';
import 'package:glupulse/features/sleep_log/domain/repositories/sleep_log_repository.dart';

class UpdateSleepLog implements UseCase<Unit, UpdateSleepLogParams> {
  final SleepLogRepository repository;

  UpdateSleepLog(this.repository);

  @override
  Future<Either<Failure, Unit>> call(UpdateSleepLogParams params) async {
    return await repository.updateSleepLog(params.sleepLog);
  }
}

class UpdateSleepLogParams extends Equatable {
  final SleepLog sleepLog;

  const UpdateSleepLogParams({required this.sleepLog});

  @override
  List<Object> get props => [sleepLog];
}