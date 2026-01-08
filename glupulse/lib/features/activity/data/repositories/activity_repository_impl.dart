import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/exceptions.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/network/network_info.dart';
import 'package:glupulse/features/activity/data/datasources/activity_remote_data_source.dart';
import 'package:glupulse/features/activity/data/models/activity_log_model.dart';
import 'package:glupulse/features/activity/domain/entities/activity_log.dart';
import 'package:glupulse/features/activity/domain/entities/activity_type.dart';
import 'package:glupulse/features/activity/domain/repositories/activity_repository.dart';
import 'package:glupulse/features/auth/data/datasources/auth_local_data_source.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  final ActivityRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ActivityRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ActivityType>>> getActivityTypes() async {
    if (await networkInfo.isConnected) {
      try {
        final token = await localDataSource.getLastToken();
        final result = await remoteDataSource.getActivityTypes(token);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List<ActivityLog>>> getActivityLogs() async {
    if (await networkInfo.isConnected) {
      try {
        final token = await localDataSource.getLastToken();
        final result = await remoteDataSource.getActivityLogs(token);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addActivityLog(ActivityLog activityLog) async {
    if (await networkInfo.isConnected) {
      try {
        final token = await localDataSource.getLastToken();
        final model = ActivityLogModel.fromEntity(activityLog);
        await remoteDataSource.addActivityLog(model, token);
        return const Right(unit);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateActivityLog(
      ActivityLog activityLog) async {
    if (await networkInfo.isConnected) {
      try {
        final token = await localDataSource.getLastToken();
        final model = ActivityLogModel.fromEntity(activityLog);
        await remoteDataSource.updateActivityLog(model, token);
        return const Right(unit);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteActivityLog(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final token = await localDataSource.getLastToken();
        await remoteDataSource.deleteActivityLog(id, token);
        return const Right(unit);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
