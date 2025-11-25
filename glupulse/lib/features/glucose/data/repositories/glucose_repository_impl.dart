import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/exceptions.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:glupulse/features/glucose/data/datasources/glucose_remote_data_source.dart';
import 'package:glupulse/features/glucose/data/models/glucose_model.dart';
import 'package:glupulse/features/glucose/domain/entities/glucose.dart';
import 'package:glupulse/features/glucose/domain/repositories/glucose_repository.dart';

class GlucoseRepositoryImpl implements GlucoseRepository {
  final GlucoseRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  GlucoseRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, Unit>> addGlucoseRecord(Glucose glucose) async {
    try {
      final token = await localDataSource.getLastToken();
      final glucoseModel = GlucoseModel.fromEntity(glucose);
      await remoteDataSource.addGlucoseRecord(glucoseModel, token);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteGlucoseRecord(String id) async {
    try {
      final token = await localDataSource.getLastToken();
      await remoteDataSource.deleteGlucoseRecord(id, token);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Glucose>> getGlucoseRecord(String id) async {
    try {
      final token = await localDataSource.getLastToken();
      final remoteGlucose = await remoteDataSource.getGlucoseRecord(id, token);
      return Right(remoteGlucose);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Glucose>>> getGlucoseRecords() async {
    try {
      final token = await localDataSource.getLastToken();
      final remoteGlucoseRecords = await remoteDataSource.getGlucoseRecords(token);
      return Right(remoteGlucoseRecords);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateGlucoseRecord(Glucose glucose) async {
    try {
      final token = await localDataSource.getLastToken();
      final glucoseModel = GlucoseModel.fromEntity(glucose);
      await remoteDataSource.updateGlucoseRecord(glucoseModel, token);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
