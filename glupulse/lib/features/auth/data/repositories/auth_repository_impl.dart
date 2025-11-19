import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/exceptions.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/features/auth/data/models/login_response_model.dart';
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
      // Login Google langsung memberikan token, jadi kita simpan.
      await localDataSource.cacheToken(loginResponse.token);
      await localDataSource.cacheUser(loginResponse.user);
      return Right(loginResponse.user);
    } on ServerException catch (e) {
      // Mengembalikan sisi kiri (Left) dari Either jika terjadi kegagalan.
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, LoginResponseModel>> register(
      {required RegisterParams params}) async {
    try {
      final registerResponse = await remoteDataSource.register(params: params);
      // Kembalikan seluruh response model agar cubit bisa mengakses pendingId
      return Right(registerResponse);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> verifyOtp(
      String userId, String otpCode) async {
    try {
      final otpResponse = await remoteDataSource.verifyOtp(userId, otpCode);
      // Setelah verifikasi OTP berhasil, kita mendapatkan token. Simpan token dan user.
      await localDataSource.cacheToken(otpResponse.token);
      await localDataSource.cacheUser(otpResponse.user);
      return Right(otpResponse.user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> verifySignupOtp(
      String pendingId, String otpCode) async {
    try {
      final otpResponse =
          await remoteDataSource.verifySignupOtp(pendingId, otpCode);
      await localDataSource.cacheToken(otpResponse.token);
      await localDataSource.cacheUser(otpResponse.user);
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

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearUser();
      await localDataSource.clearToken();
      return const Right(null); // Return Right(null) for success
    } on CacheException {
      return Left(CacheFailure()); // Or a more specific logout failure
    }
  }

  @override
  Future<Either<Failure, UserEntity>> linkGoogleAccount(String idToken) async {
    try {
      final loginResponse = await remoteDataSource.linkGoogleAccount(idToken);
      // Setelah berhasil link, backend akan memberikan token baru, jadi kita simpan.
      await localDataSource.cacheToken(loginResponse.token);
      await localDataSource.cacheUser(loginResponse.user);
      return Right(loginResponse.user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}