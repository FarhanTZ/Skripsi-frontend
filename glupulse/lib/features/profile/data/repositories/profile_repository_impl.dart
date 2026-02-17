import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/exceptions.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/network/network_info.dart';
import 'package:glupulse/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:glupulse/features/auth/domain/entities/user_entity.dart';
import 'package:glupulse/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:glupulse/features/profile/domain/repositories/profile_repository.dart';
import 'package:glupulse/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:glupulse/features/profile/domain/usecases/update_username_usecase.dart';
import 'package:glupulse/features/profile/domain/usecases/update_password_usecase.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserEntity>> getUserProfile() async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.getUserProfile();
        // Cache user data yang didapat dari profil
        await localDataSource.cacheUser(user);
        return Right(user);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUserProfile(
      UpdateProfileParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final updatedUser = await remoteDataSource.updateUserProfile(params);
        // Setelah update berhasil, simpan juga user baru ke local cache
        await localDataSource.cacheUser(updatedUser);
        return Right(updatedUser);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUsername(
      UpdateUsernameParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final updatedUser =
            await remoteDataSource.updateUsername(params.newUsername);
        // Setelah update berhasil, simpan juga user baru ke local cache
        await localDataSource.cacheUser(updatedUser);
        return Right(updatedUser);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateEmail(String newEmail, String password) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updateEmail(newEmail, password);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updatePassword(
      UpdatePasswordParams params) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updatePassword(
          params.currentPassword,
          params.newPassword,
          params.confirmPassword,
        );
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount(String password) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteAccount(password);
        // Jika berhasil, AuthCubit akan menangani proses logout dan pembersihan data lokal.
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}