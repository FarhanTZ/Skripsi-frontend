import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/exceptions.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:glupulse/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:glupulse/features/auth/domain/entities/user_entity.dart';
import 'package:glupulse/features/auth/domain/usecases/register_usecase.dart';
import 'package:glupulse/features/auth/domain/repositories/auth_repository.dart';

/// Implementasi dari AuthRepository.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl(
      {required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<Failure, UserEntity>> login(
      String username, String password) async {
    try {
      final loginResponse = await remoteDataSource.login(username, password);
      // Di sini Anda bisa menyimpan token, misalnya menggunakan SharedPreferences.
      // await localDataSource.cacheToken(loginResponse.token);

      // Mengembalikan sisi kanan (Right) dari Either jika sukses.
      // Perhatikan kita hanya mengembalikan `user` (sebuah Entity), bukan seluruh response model.
      return Right(loginResponse.user);
    } on ServerException catch (e) {
      // Mengembalikan sisi kiri (Left) dari Either jika terjadi kegagalan.
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithGoogle(String idToken) async {
    try {
      final loginResponse = await remoteDataSource.loginWithGoogle(idToken);
      // Sama seperti login biasa, kita bisa cache token di sini jika perlu.
      // Dan kita hanya mengembalikan UserEntity.
      // Karena login google langsung memberikan token, kita anggap ini sudah terotentikasi penuh.
      return Right(loginResponse.user);
    } on ServerException catch (e) {
      // Mengembalikan sisi kiri (Left) dari Either jika terjadi kegagalan.
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register(
      {required RegisterParams params}) async {
    try {
      final registerResponse = await remoteDataSource.register(params: params);
      // Sama seperti login, setelah registrasi kita hanya butuh UserEntity
      // untuk melanjutkan ke tahap verifikasi OTP.
      return Right(registerResponse.user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> verifyOtp(
      String userId, String otpCode) async {
    try {
      final otpResponse = await remoteDataSource.verifyOtp(userId, otpCode);
      // Sama seperti login, kita hanya butuh UserEntity-nya.
      // Anda bisa menyimpan token baru jika backend mengirimkannya.
      return Right(otpResponse.user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final user = await localDataSource.getLastUser();
      return Right(user);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}