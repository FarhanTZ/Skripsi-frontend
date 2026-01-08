import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/activity/domain/entities/activity_type.dart';
import 'package:glupulse/features/activity/domain/repositories/activity_repository.dart';

class GetActivityTypes implements UseCase<List<ActivityType>, NoParams> {
  final ActivityRepository repository;

  GetActivityTypes(this.repository);

  @override
  Future<Either<Failure, List<ActivityType>>> call(NoParams params) async {
    return await repository.getActivityTypes();
  }
}
