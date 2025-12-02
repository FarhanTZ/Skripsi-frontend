import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/exceptions.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/network/network_info.dart';
import 'package:glupulse/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:glupulse/features/meal_log/data/datasources/meal_log_remote_data_source.dart';
import 'package:glupulse/features/meal_log/data/models/meal_log_model.dart';
import 'package:glupulse/features/meal_log/domain/entities/meal_log.dart';
import 'package:glupulse/features/meal_log/domain/repositories/meal_log_repository.dart';

class MealLogRepositoryImpl implements MealLogRepository {
  final MealLogRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  MealLogRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, MealLog>> addMealLog(MealLog mealLog) async {
    if (await networkInfo.isConnected) {
      try {
        final token = await localDataSource.getLastToken();
        final mealLogModel = MealLogModel.fromEntity(mealLog);
        final createdLog =
            await remoteDataSource.addMealLog(mealLogModel, token);
        return Right(createdLog);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteMealLog(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final token = await localDataSource.getLastToken();
        await remoteDataSource.deleteMealLog(id, token);
        return const Right(unit);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, MealLog>> getMealLog(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final token = await localDataSource.getLastToken();
        final remoteMealLog = await remoteDataSource.getMealLog(id, token);
        return Right(remoteMealLog);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List<MealLog>>> getMealLogs() async {
    if (await networkInfo.isConnected) {
      try {
        final token = await localDataSource.getLastToken();
        final remoteMealLogs = await remoteDataSource.getMealLogs(token);
        return Right(remoteMealLogs);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, MealLog>> updateMealLog(MealLog mealLog) async {
    if (await networkInfo.isConnected) {
      try {
        final token = await localDataSource.getLastToken();
        final mealLogModel = MealLogModel.fromEntity(mealLog);
        final updatedLog =
            await remoteDataSource.updateMealLog(mealLogModel, token);
        return Right(updatedLog);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
