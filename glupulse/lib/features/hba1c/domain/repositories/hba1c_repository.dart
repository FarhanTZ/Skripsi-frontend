import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/features/hba1c/domain/entities/hba1c.dart';

abstract class Hba1cRepository {
  Future<Either<Failure, List<Hba1c>>> getHba1cRecords();
  Future<Either<Failure, Hba1c>> getHba1cRecord(String id);
  Future<Either<Failure, Unit>> addHba1cRecord(Hba1c hba1c);
  Future<Either<Failure, Unit>> updateHba1cRecord(Hba1c hba1c);
  Future<Either<Failure, Unit>> deleteHba1cRecord(String id);
}
