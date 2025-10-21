import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/auth/domain/entities/user_entity.dart';
import 'package:glupulse/features/auth/domain/repositories/auth_repository.dart';

/// Use case untuk verifikasi OTP.
class VerifyOtpUseCase implements UseCase<UserEntity, VerifyOtpParams> {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(VerifyOtpParams params) async {
    return await repository.verifyOtp(params.userId, params.otpCode);
  }
}

class VerifyOtpParams extends Equatable {
  final String userId;
  final String otpCode;

  const VerifyOtpParams({required this.userId, required this.otpCode});

  @override
  List<Object?> get props => [userId, otpCode];
}