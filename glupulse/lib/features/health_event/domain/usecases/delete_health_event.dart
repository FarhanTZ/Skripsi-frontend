import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/health_event/domain/repositories/health_event_repository.dart';

class DeleteHealthEvent implements UseCase<Unit, DeleteHealthEventParams> {
  final HealthEventRepository repository;

  DeleteHealthEvent(this.repository);

  @override
  Future<Either<Failure, Unit>> call(DeleteHealthEventParams params) async {
    return await repository.deleteHealthEventRecord(params.id);
  }
}

class DeleteHealthEventParams extends Equatable {
  final String id;

  const DeleteHealthEventParams({required this.id});

  @override
  List<Object?> get props => [id];
}
