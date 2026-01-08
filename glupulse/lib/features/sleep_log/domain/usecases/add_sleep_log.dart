import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/sleep_log/domain/entities/sleep_log.dart';
import 'package:glupulse/features/sleep_log/domain/repositories/sleep_log_repository.dart';

class AddSleepLog implements UseCase<Unit, AddSleepLogParams> {
  final SleepLogRepository repository;

  AddSleepLog(this.repository);

  @override
  Future<Either<Failure, Unit>> call(AddSleepLogParams params) async {
    return await repository.addSleepLog(params.sleepLog);
  }
}

class AddSleepLogParams extends Equatable {
  final SleepLog sleepLog;

  const AddSleepLogParams({required this.sleepLog});

  @override
  List<Object> get props => [sleepLog];
}