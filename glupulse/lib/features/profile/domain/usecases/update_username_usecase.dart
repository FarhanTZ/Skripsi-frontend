import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/auth/domain/entities/user_entity.dart';
import 'package:glupulse/features/profile/domain/repositories/profile_repository.dart';

class UpdateUsernameUseCase implements UseCase<UserEntity, UpdateUsernameParams> {
  final ProfileRepository repository;

  UpdateUsernameUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(UpdateUsernameParams params) async {
    return await repository.updateUsername(params);
  }
}

class UpdateUsernameParams extends Equatable {
  final String newUsername;

  const UpdateUsernameParams({required this.newUsername});

  @override
  List<Object?> get props => [newUsername];
}