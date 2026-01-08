import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/features/HealthData/domain/entities/health_profile.dart';

abstract class HealthProfileRepository {
  Future<Either<Failure, HealthProfile>> getHealthProfile();
  Future<Either<Failure, HealthProfile>> updateHealthProfile(
      HealthProfile healthProfile);
}
