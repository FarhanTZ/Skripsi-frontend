import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/glucose/domain/repositories/glucose_repository.dart';

class DeleteGlucoseRecord implements UseCase<Unit, DeleteGlucoseParams> {
  final GlucoseRepository repository;

  DeleteGlucoseRecord(this.repository);

  @override
  Future<Either<Failure, Unit>> call(DeleteGlucoseParams params) async {
    return await repository.deleteGlucoseRecord(params.id);
  }
}

class DeleteGlucoseParams extends Equatable {
  final String id;

  const DeleteGlucoseParams({required this.id});

  @override
  List<Object> get props => [id];
}
