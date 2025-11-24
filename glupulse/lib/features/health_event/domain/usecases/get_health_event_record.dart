import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/health_event/domain/entities/health_event.dart';
import 'package:glupulse/features/health_event/domain/repositories/health_event_repository.dart';

class GetHealthEventRecord implements UseCase<HealthEvent, GetHealthEventRecordParams> {
  final HealthEventRepository repository;

  GetHealthEventRecord(this.repository);

  @override
  Future<Either<Failure, HealthEvent>> call(GetHealthEventRecordParams params) async {
    return await repository.getHealthEventRecord(params.id);
  }
}

class GetHealthEventRecordParams extends Equatable {
  final String id;

  const GetHealthEventRecordParams({required this.id});

  @override
  List<Object?> get props => [id];
}
