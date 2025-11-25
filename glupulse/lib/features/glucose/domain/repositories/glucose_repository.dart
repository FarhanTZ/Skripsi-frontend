import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/features/glucose/domain/entities/glucose.dart';

abstract class GlucoseRepository {
  Future<Either<Failure, List<Glucose>>> getGlucoseRecords();
  Future<Either<Failure, Glucose>> getGlucoseRecord(String id);
  Future<Either<Failure, Unit>> addGlucoseRecord(Glucose glucose);
  Future<Either<Failure, Unit>> updateGlucoseRecord(Glucose glucose);
  Future<Either<Failure, Unit>> deleteGlucoseRecord(String id);
}
