import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/exceptions.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:glupulse/features/auth/domain/entities/user_entity.dart';
import 'package:glupulse/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:glupulse/features/profile/domain/repositories/profile_repository.dart';
import 'package:glupulse/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:glupulse/features/profile/domain/usecases/update_username_usecase.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, UserEntity>> getUserProfile() async {
    try {
      final user = await remoteDataSource.getUserProfile();
      // Cache user data yang didapat dari profil
      await localDataSource.cacheUser(user);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUserProfile(
      UpdateProfileParams params) async {
    try {
      final updatedUser = await remoteDataSource.updateUserProfile(params);
      // Setelah update berhasil, simpan juga user baru ke local cache
      await localDataSource.cacheUser(updatedUser);
      return Right(updatedUser);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUsername(UpdateUsernameParams params) async {
    try {
      final updatedUser = await remoteDataSource.updateUsername(params.newUsername);
      // Setelah update berhasil, simpan juga user baru ke local cache
      await localDataSource.cacheUser(updatedUser);
      return Right(updatedUser);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}