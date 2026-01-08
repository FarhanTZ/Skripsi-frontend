import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/features/sleep_log/domain/entities/sleep_log.dart';

abstract class SleepLogRepository {
  Future<Either<Failure, List<SleepLog>>> getSleepLogs();
  Future<Either<Failure, SleepLog>> getSleepLog(String id);
  Future<Either<Failure, Unit>> addSleepLog(SleepLog sleepLog);
  Future<Either<Failure, Unit>> updateSleepLog(SleepLog sleepLog);
  Future<Either<Failure, Unit>> deleteSleepLog(String id);
}
