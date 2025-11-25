import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/sleep_log/domain/entities/sleep_log.dart';
import 'package:glupulse/features/sleep_log/domain/repositories/sleep_log_repository.dart';

class GetSleepLogs implements UseCase<List<SleepLog>, NoParams> {
  final SleepLogRepository repository;

  GetSleepLogs(this.repository);

  @override
  Future<Either<Failure, List<SleepLog>>> call(NoParams params) async {
    return await repository.getSleepLogs();
  }
}