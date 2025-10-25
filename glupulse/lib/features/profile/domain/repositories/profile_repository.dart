import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/features/auth/domain/entities/user_entity.dart';
import 'package:glupulse/features/profile/domain/usecases/update_username_usecase.dart';
import 'package:glupulse/features/profile/domain/usecases/update_profile_usecase.dart';

/// Kontrak untuk ProfileRepository di layer Domain.
abstract class ProfileRepository {
  Future<Either<Failure, UserEntity>> getUserProfile();
  Future<Either<Failure, UserEntity>> updateUserProfile(
      UpdateProfileParams params);
  Future<Either<Failure, UserEntity>> updateUsername(UpdateUsernameParams params);
}