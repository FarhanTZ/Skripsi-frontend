import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/activity/domain/entities/activity_log.dart';
import 'package:glupulse/features/activity/domain/repositories/activity_repository.dart';

class GetActivityLogs implements UseCase<List<ActivityLog>, NoParams> {
  final ActivityRepository repository;

  GetActivityLogs(this.repository);

  @override
  Future<Either<Failure, List<ActivityLog>>> call(NoParams params) async {
    return await repository.getActivityLogs();
  }
}
