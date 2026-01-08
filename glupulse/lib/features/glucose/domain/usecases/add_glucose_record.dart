import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/glucose/domain/entities/glucose.dart';
import 'package:glupulse/features/glucose/domain/repositories/glucose_repository.dart';

class AddGlucoseRecord implements UseCase<Unit, AddGlucoseParams> {
  final GlucoseRepository repository;

  AddGlucoseRecord(this.repository);

  @override
  Future<Either<Failure, Unit>> call(AddGlucoseParams params) async {
    return await repository.addGlucoseRecord(params.glucose);
  }
}

class AddGlucoseParams extends Equatable {
  final Glucose glucose;

  const AddGlucoseParams({required this.glucose});

  @override
  List<Object> get props => [glucose];
}
