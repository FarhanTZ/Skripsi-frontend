import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/hba1c/domain/entities/hba1c.dart';
import 'package:glupulse/features/hba1c/domain/repositories/hba1c_repository.dart';

class GetHba1cRecords implements UseCase<List<Hba1c>, NoParams> {
  final Hba1cRepository repository;

  GetHba1cRecords(this.repository);

  @override
  Future<Either<Failure, List<Hba1c>>> call(NoParams params) async {
    return await repository.getHba1cRecords();
  }
}
