import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/exceptions.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/network/network_info.dart';
import 'package:glupulse/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:glupulse/features/sleep_log/data/datasources/sleep_log_remote_data_source.dart';
import 'package:glupulse/features/sleep_log/data/models/sleep_log_model.dart';
import 'package:glupulse/features/sleep_log/domain/entities/sleep_log.dart';
import 'package:glupulse/features/sleep_log/domain/repositories/sleep_log_repository.dart';

class SleepLogRepositoryImpl implements SleepLogRepository {
  final SleepLogRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  SleepLogRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Unit>> addSleepLog(SleepLog sleepLog) async {
    if (await networkInfo.isConnected) {
      try {
        final token = await localDataSource.getLastToken();
        final sleepLogModel = SleepLogModel.fromEntity(sleepLog);
        await remoteDataSource.addSleepLog(sleepLogModel, token);
        return const Right(unit);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteSleepLog(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final token = await localDataSource.getLastToken();
        await remoteDataSource.deleteSleepLog(id, token);
        return const Right(unit);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, SleepLog>> getSleepLog(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final token = await localDataSource.getLastToken();
        final remoteSleepLog = await remoteDataSource.getSleepLog(id, token);
        return Right(remoteSleepLog);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List<SleepLog>>> getSleepLogs() async {
    if (await networkInfo.isConnected) {
      try {
        final token = await localDataSource.getLastToken();
        final remoteSleepLogs = await remoteDataSource.getSleepLogs(token);
        return Right(remoteSleepLogs);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateSleepLog(SleepLog sleepLog) async {
    if (await networkInfo.isConnected) {
      try {
        final token = await localDataSource.getLastToken();
        final sleepLogModel = SleepLogModel.fromEntity(sleepLog);
        await remoteDataSource.updateSleepLog(sleepLogModel, token);
        return const Right(unit);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
