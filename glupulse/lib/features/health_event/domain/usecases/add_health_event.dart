import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/health_event/domain/entities/health_event.dart';
import 'package:glupulse/features/health_event/domain/repositories/health_event_repository.dart';

class AddHealthEvent implements UseCase<Unit, AddHealthEventParams> {
  final HealthEventRepository repository;

  AddHealthEvent(this.repository);

  @override
  Future<Either<Failure, Unit>> call(AddHealthEventParams params) async {
    return await repository.addHealthEventRecord(params.healthEvent);
  }
}

class AddHealthEventParams extends Equatable {
  final HealthEvent healthEvent;

  const AddHealthEventParams({required this.healthEvent});

  @override
  List<Object?> get props => [healthEvent];
}
