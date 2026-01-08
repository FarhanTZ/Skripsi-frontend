import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/glucose/domain/entities/glucose.dart';
import 'package:glupulse/features/glucose/domain/repositories/glucose_repository.dart';

class GetGlucoseRecord implements UseCase<Glucose, GetGlucoseRecordParams> {
  final GlucoseRepository repository;

  GetGlucoseRecord(this.repository);

  @override
  Future<Either<Failure, Glucose>> call(GetGlucoseRecordParams params) async {
    return await repository.getGlucoseRecord(params.id);
  }
}

class GetGlucoseRecordParams extends Equatable {
  final String id;

  const GetGlucoseRecordParams({required this.id});

  @override
  List<Object> get props => [id];
}
