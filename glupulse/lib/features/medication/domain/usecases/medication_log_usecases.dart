import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/medication/domain/entities/medication_log.dart';
import 'package:glupulse/features/medication/domain/repositories/medication_repository.dart';

class GetMedicationLogs implements UseCase<List<MedicationLog>, NoParams> {
  final MedicationRepository repository;

  GetMedicationLogs(this.repository);

  @override
  Future<Either<Failure, List<MedicationLog>>> call(NoParams params) async {
    return await repository.getMedicationLogs();
  }
}

class AddMedicationLog implements UseCase<Unit, MedicationLog> {
  final MedicationRepository repository;

  AddMedicationLog(this.repository);

  @override
  Future<Either<Failure, Unit>> call(MedicationLog params) async {
    return await repository.addMedicationLog(params);
  }
}

class UpdateMedicationLog implements UseCase<Unit, MedicationLog> {
  final MedicationRepository repository;

  UpdateMedicationLog(this.repository);

  @override
  Future<Either<Failure, Unit>> call(MedicationLog params) async {
    return await repository.updateMedicationLog(params);
  }
}

class DeleteMedicationLog implements UseCase<Unit, String> {
  final MedicationRepository repository;

  DeleteMedicationLog(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String params) async {
    return await repository.deleteMedicationLog(params);
  }
}
