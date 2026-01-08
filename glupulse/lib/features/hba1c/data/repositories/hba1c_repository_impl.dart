import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/exceptions.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/network/network_info.dart';
import 'package:glupulse/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:glupulse/features/hba1c/data/datasources/hba1c_remote_data_source.dart';
import 'package:glupulse/features/hba1c/data/models/hba1c_model.dart';
import 'package:glupulse/features/hba1c/domain/entities/hba1c.dart';
import 'package:glupulse/features/hba1c/domain/repositories/hba1c_repository.dart';

class Hba1cRepositoryImpl implements Hba1cRepository {
  final Hba1cRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  Hba1cRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Unit>> addHba1cRecord(Hba1c hba1c) async {
    if (await networkInfo.isConnected) {
      try {
        final token = await localDataSource.getLastToken();
        final hba1cModel = Hba1cModel.fromEntity(hba1c);
        await remoteDataSource.addHba1cRecord(hba1cModel, token);
        return const Right(unit);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteHba1cRecord(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final token = await localDataSource.getLastToken();
        await remoteDataSource.deleteHba1cRecord(id, token);
        return const Right(unit);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Hba1c>> getHba1cRecord(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final token = await localDataSource.getLastToken();
        final remoteHba1c = await remoteDataSource.getHba1cRecord(id, token);
        return Right(remoteHba1c);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List<Hba1c>>> getHba1cRecords() async {
    if (await networkInfo.isConnected) {
      try {
        final token = await localDataSource.getLastToken();
        final remoteHba1cRecords =
            await remoteDataSource.getHba1cRecords(token);
        return Right(remoteHba1cRecords);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateHba1cRecord(Hba1c hba1c) async {
    if (await networkInfo.isConnected) {
      try {
        final token = await localDataSource.getLastToken();
        final hba1cModel = Hba1cModel.fromEntity(hba1c);
        await remoteDataSource.updateHba1cRecord(hba1cModel, token);
        return const Right(unit);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
