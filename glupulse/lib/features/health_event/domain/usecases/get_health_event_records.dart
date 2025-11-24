import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/health_event/domain/entities/health_event.dart';
import 'package:glupulse/features/health_event/domain/repositories/health_event_repository.dart';

class GetHealthEventRecords implements UseCase<List<HealthEvent>, NoParams> {
  final HealthEventRepository repository;

  GetHealthEventRecords(this.repository);

  @override
  Future<Either<Failure, List<HealthEvent>>> call(NoParams params) async {
    return await repository.getHealthEventRecords();
  }
}
