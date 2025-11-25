import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/sleep_log/domain/entities/sleep_log.dart';
import 'package:glupulse/features/sleep_log/domain/repositories/sleep_log_repository.dart';

class GetSleepLog implements UseCase<SleepLog, GetSleepLogParams> {
  final SleepLogRepository repository;

  GetSleepLog(this.repository);

  @override
  Future<Either<Failure, SleepLog>> call(GetSleepLogParams params) async {
    return await repository.getSleepLog(params.id);
  }
}

class GetSleepLogParams extends Equatable {
  final String id;

  const GetSleepLogParams({required this.id});

  @override
  List<Object> get props => [id];
}