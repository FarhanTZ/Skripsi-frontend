import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/features/medication/domain/entities/medication.dart';
import 'package:glupulse/features/medication/domain/entities/medication_log.dart';

abstract class MedicationRepository {
  // Definitions
  Future<Either<Failure, List<Medication>>> getMedications();
  Future<Either<Failure, Unit>> addMedication(Medication medication);
  Future<Either<Failure, Unit>> updateMedication(Medication medication);
  Future<Either<Failure, Unit>> deleteMedication(int id);

  // Logs
  Future<Either<Failure, List<MedicationLog>>> getMedicationLogs();
  Future<Either<Failure, Unit>> addMedicationLog(MedicationLog log);
  Future<Either<Failure, Unit>> updateMedicationLog(MedicationLog log);
  Future<Either<Failure, Unit>> deleteMedicationLog(String id);
}
