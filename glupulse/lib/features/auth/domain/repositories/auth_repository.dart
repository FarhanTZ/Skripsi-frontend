import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/features/auth/data/models/login_response_model.dart';
import 'package:glupulse/features/auth/domain/entities/user_entity.dart';
import 'package:glupulse/features/auth/domain/usecases/register_usecase.dart';

/// Kontrak untuk AuthRepository di layer Domain.
/// Metode ini mengembalikan `Either` untuk menangani `Failure` atau `UserEntity`.
/// Kita hanya mengembalikan UserEntity karena token adalah detail implementasi
/// yang tidak perlu diketahui oleh use case atau UI.
abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login(String username, String password);
  Future<Either<Failure, UserEntity>> loginWithGoogle(String idToken);
  Future<Either<Failure, LoginResponseModel>> register({required RegisterParams params});
  Future<Either<Failure, UserEntity>> verifyOtp(String userId, String otpCode);
  Future<Either<Failure, UserEntity>> verifySignupOtp(String pendingId, String otpCode);
  Future<Either<Failure, UserEntity>> getCurrentUser();
  Future<Either<Failure, void>> logout(); // Tambahkan metode logout
  Future<Either<Failure, UserEntity>> linkGoogleAccount(String idToken);
}