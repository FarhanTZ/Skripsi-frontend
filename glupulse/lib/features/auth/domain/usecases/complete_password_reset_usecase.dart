import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/auth/domain/repositories/auth_repository.dart';

class CompletePasswordResetUseCase implements UseCase<void, CompletePasswordResetParams> {
  final AuthRepository repository;

  CompletePasswordResetUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(CompletePasswordResetParams params) async {
    return await repository.completePasswordReset(
      userId: params.userId,
      otpCode: params.otpCode,
      newPassword: params.newPassword,
      confirmPassword: params.confirmPassword,
    );
  }
}

class CompletePasswordResetParams extends Equatable {
  final String userId;
  final String otpCode;
  final String newPassword;
  final String confirmPassword;

  const CompletePasswordResetParams({required this.userId, required this.otpCode, required this.newPassword, required this.confirmPassword});

  @override
  List<Object?> get props => [userId, otpCode, newPassword, confirmPassword];
}
