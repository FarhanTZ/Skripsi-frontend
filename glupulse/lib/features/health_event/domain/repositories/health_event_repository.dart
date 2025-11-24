import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/features/health_event/domain/entities/health_event.dart';

abstract class HealthEventRepository {
  Future<Either<Failure, List<HealthEvent>>> getHealthEventRecords();
  Future<Either<Failure, HealthEvent>> getHealthEventRecord(String id);
  Future<Either<Failure, Unit>> addHealthEventRecord(HealthEvent healthEvent);
  Future<Either<Failure, Unit>> updateHealthEventRecord(HealthEvent healthEvent);
  Future<Either<Failure, Unit>> deleteHealthEventRecord(String id);
}
