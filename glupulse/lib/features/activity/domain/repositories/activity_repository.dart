import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/features/activity/domain/entities/activity_log.dart';
import 'package:glupulse/features/activity/domain/entities/activity_type.dart';

abstract class ActivityRepository {
  Future<Either<Failure, List<ActivityType>>> getActivityTypes();
  Future<Either<Failure, List<ActivityLog>>> getActivityLogs();
  Future<Either<Failure, Unit>> addActivityLog(ActivityLog activityLog);
  Future<Either<Failure, Unit>> updateActivityLog(ActivityLog activityLog);
  Future<Either<Failure, Unit>> deleteActivityLog(String id);
}
