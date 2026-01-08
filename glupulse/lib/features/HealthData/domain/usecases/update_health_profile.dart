import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/HealthData/domain/entities/health_profile.dart';
import 'package:glupulse/features/HealthData/domain/repositories/health_profile_repository.dart';

class UpdateHealthProfile implements UseCase<HealthProfile, UpdateHealthProfileParams> {
  final HealthProfileRepository repository;

  UpdateHealthProfile(this.repository);

  @override
  Future<Either<Failure, HealthProfile>> call(
      UpdateHealthProfileParams params) async {
    return await repository.updateHealthProfile(params.healthProfile);
  }
}

class UpdateHealthProfileParams extends Equatable {
  final HealthProfile healthProfile;

  const UpdateHealthProfileParams({required this.healthProfile});

  @override
  List<Object?> get props => [healthProfile];
}
