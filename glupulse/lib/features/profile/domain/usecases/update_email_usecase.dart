import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/profile/domain/repositories/profile_repository.dart';

class UpdateEmailUseCase implements UseCase<void, UpdateEmailParams> {
  final ProfileRepository repository;

  UpdateEmailUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateEmailParams params) async {
    return await repository.updateEmail(params.newEmail, params.password);
  }
}

class UpdateEmailParams extends Equatable {
  final String newEmail;
  final String password;

  const UpdateEmailParams({
    required this.newEmail,
    required this.password,
  });

  @override
  List<Object?> get props => [newEmail, password];
}
