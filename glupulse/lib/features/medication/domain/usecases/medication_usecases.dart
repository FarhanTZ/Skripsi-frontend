import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/medication/domain/entities/medication.dart';
import 'package:glupulse/features/medication/domain/repositories/medication_repository.dart';

class GetMedications implements UseCase<List<Medication>, NoParams> {
  final MedicationRepository repository;

  GetMedications(this.repository);

  @override
  Future<Either<Failure, List<Medication>>> call(NoParams params) async {
    return await repository.getMedications();
  }
}

class AddMedication implements UseCase<Unit, Medication> {
  final MedicationRepository repository;

  AddMedication(this.repository);

  @override
  Future<Either<Failure, Unit>> call(Medication params) async {
    return await repository.addMedication(params);
  }
}

class UpdateMedication implements UseCase<Unit, Medication> {
  final MedicationRepository repository;

  UpdateMedication(this.repository);

  @override
  Future<Either<Failure, Unit>> call(Medication params) async {
    return await repository.updateMedication(params);
  }
}

class DeleteMedication implements UseCase<Unit, int> {
  final MedicationRepository repository;

  DeleteMedication(this.repository);

  @override
  Future<Either<Failure, Unit>> call(int params) async {
    return await repository.deleteMedication(params);
  }
}
