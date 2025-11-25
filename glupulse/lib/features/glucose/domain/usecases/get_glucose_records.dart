import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/glucose/domain/entities/glucose.dart';
import 'package:glupulse/features/glucose/domain/repositories/glucose_repository.dart';

class GetGlucoseRecords implements UseCase<List<Glucose>, NoParams> {
  final GlucoseRepository repository;

  GetGlucoseRecords(this.repository);

  @override
  Future<Either<Failure, List<Glucose>>> call(NoParams params) async {
    return await repository.getGlucoseRecords();
  }
}
