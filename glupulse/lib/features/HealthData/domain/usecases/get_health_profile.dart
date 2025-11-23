import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/HealthData/domain/entities/health_profile.dart';
import 'package:glupulse/features/HealthData/domain/repositories/health_profile_repository.dart';

class GetHealthProfile implements UseCase<HealthProfile, NoParams> {
  final HealthProfileRepository repository;

  GetHealthProfile(this.repository);

  @override
  Future<Either<Failure, HealthProfile>> call(NoParams params) async {
    return await repository.getHealthProfile();
  }
}