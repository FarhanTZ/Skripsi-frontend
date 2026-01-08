import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/exceptions.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/network/network_info.dart';
import 'package:glupulse/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:glupulse/features/health_event/data/datasources/health_event_remote_data_source.dart';
import 'package:glupulse/features/health_event/data/models/health_event_model.dart';
import 'package:glupulse/features/health_event/domain/entities/health_event.dart';
import 'package:glupulse/features/health_event/domain/repositories/health_event_repository.dart';

class HealthEventRepositoryImpl implements HealthEventRepository {
  final HealthEventRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  HealthEventRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Unit>> addHealthEventRecord(
      HealthEvent healthEvent) async {
    if (await networkInfo.isConnected) {
      try {
        final token = await localDataSource.getLastToken();
        final healthEventModel = HealthEventModel.fromEntity(healthEvent);
        await remoteDataSource.addHealthEventRecord(healthEventModel, token);
        return const Right(unit);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteHealthEventRecord(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final token = await localDataSource.getLastToken();
        await remoteDataSource.deleteHealthEventRecord(id, token);
        return const Right(unit);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, HealthEvent>> getHealthEventRecord(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final token = await localDataSource.getLastToken();
        final remoteHealthEvent =
            await remoteDataSource.getHealthEventRecord(id, token);
        return Right(remoteHealthEvent);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List<HealthEvent>>> getHealthEventRecords() async {
    if (await networkInfo.isConnected) {
      try {
        final token = await localDataSource.getLastToken();
        final remoteHealthEventRecords =
            await remoteDataSource.getHealthEventRecords(token);
        return Right(remoteHealthEventRecords);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateHealthEventRecord(
      HealthEvent healthEvent) async {
    if (await networkInfo.isConnected) {
      try {
        final token = await localDataSource.getLastToken();
        final healthEventModel = HealthEventModel.fromEntity(healthEvent);
        await remoteDataSource.updateHealthEventRecord(healthEventModel, token);
        return const Right(unit);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
