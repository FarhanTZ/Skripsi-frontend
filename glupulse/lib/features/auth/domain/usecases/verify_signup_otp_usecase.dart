import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/auth/domain/entities/user_entity.dart';
import 'package:glupulse/features/auth/domain/repositories/auth_repository.dart';

class VerifySignupOtpUseCase implements UseCase<UserEntity, VerifySignupOtpParams> {
  final AuthRepository repository;

  VerifySignupOtpUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(VerifySignupOtpParams params) async {
    return await repository.verifySignupOtp(params.pendingId, params.otpCode);
  }
}

class VerifySignupOtpParams extends Equatable {
  final String pendingId;
  final String otpCode;

  const VerifySignupOtpParams({required this.pendingId, required this.otpCode});

  @override
  List<Object?> get props => [pendingId, otpCode];
}