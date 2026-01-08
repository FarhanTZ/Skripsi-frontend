import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/auth/data/models/login_response_model.dart';
import 'package:glupulse/features/auth/domain/repositories/auth_repository.dart';

class RequestPasswordResetUseCase implements UseCase<LoginResponseModel, RequestPasswordResetParams> {
  final AuthRepository repository;

  RequestPasswordResetUseCase(this.repository);

  @override
  Future<Either<Failure, LoginResponseModel>> call(RequestPasswordResetParams params) async {
    return await repository.requestPasswordReset(params.email);
  }
}

class RequestPasswordResetParams extends Equatable {
  final String email;

  const RequestPasswordResetParams({required this.email});

  @override
  List<Object?> get props => [email];
}
