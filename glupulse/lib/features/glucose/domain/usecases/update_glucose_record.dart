import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/glucose/domain/entities/glucose.dart';
import 'package:glupulse/features/glucose/domain/repositories/glucose_repository.dart';

class UpdateGlucoseRecord implements UseCase<Unit, UpdateGlucoseParams> {
  final GlucoseRepository repository;

  UpdateGlucoseRecord(this.repository);

  @override
  Future<Either<Failure, Unit>> call(UpdateGlucoseParams params) async {
    return await repository.updateGlucoseRecord(params.glucose);
  }
}

class UpdateGlucoseParams extends Equatable {
  final Glucose glucose;

  const UpdateGlucoseParams({required this.glucose});

  @override
  List<Object> get props => [glucose];
}
