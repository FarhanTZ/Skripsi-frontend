import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/health_event/domain/entities/health_event.dart';
import 'package:glupulse/features/health_event/domain/repositories/health_event_repository.dart';

class UpdateHealthEvent implements UseCase<Unit, UpdateHealthEventParams> {
  final HealthEventRepository repository;

  UpdateHealthEvent(this.repository);

  @override
  Future<Either<Failure, Unit>> call(UpdateHealthEventParams params) async {
    return await repository.updateHealthEventRecord(params.healthEvent);
  }
}

class UpdateHealthEventParams extends Equatable {
  final HealthEvent healthEvent;

  const UpdateHealthEventParams({required this.healthEvent});

  @override
  List<Object?> get props => [healthEvent];
}
