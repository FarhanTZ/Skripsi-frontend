import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/auth/domain/entities/user_entity.dart';
import 'package:glupulse/features/auth/domain/repositories/auth_repository.dart';

/// Use case untuk melakukan login dengan Google.
class LoginWithGoogleUseCase implements UseCase<UserEntity, LoginWithGoogleParams> {
  final AuthRepository repository;

  LoginWithGoogleUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(LoginWithGoogleParams params) async {
    return await repository.loginWithGoogle(params.idToken);
  }
}

class LoginWithGoogleParams extends Equatable {
  final String idToken;

  const LoginWithGoogleParams({required this.idToken});

  @override
  List<Object?> get props => [idToken];
}