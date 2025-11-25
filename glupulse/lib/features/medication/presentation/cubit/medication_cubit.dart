import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/medication/domain/entities/medication.dart';
import 'package:glupulse/features/medication/domain/usecases/medication_usecases.dart';

part 'medication_state.dart';

class MedicationCubit extends Cubit<MedicationState> {
  final GetMedications getMedications;
  final AddMedication addMedication;
  final UpdateMedication updateMedication;
  final DeleteMedication deleteMedication;

  MedicationCubit({
    required this.getMedications,
    required this.addMedication,
    required this.updateMedication,
    required this.deleteMedication,
  }) : super(MedicationInitial());

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return (failure as ServerFailure).message;
      default:
        return 'Unexpected error';
    }
  }

  Future<void> fetchMedications() async {
    emit(MedicationLoading());
    final result = await getMedications(NoParams());
    emit(result.fold(
      (failure) => MedicationError(message: _mapFailureToMessage(failure)),
      (medications) => MedicationLoaded(medications: medications),
    ));
  }

  Future<void> createMedication(Medication medication) async {
    emit(MedicationLoading());
    final result = await addMedication(medication);
    emit(result.fold(
      (failure) => MedicationError(message: _mapFailureToMessage(failure)),
      (_) => MedicationSuccess(), // Emitting success triggers listener
    ));
  }

  Future<void> editMedication(Medication medication) async {
    emit(MedicationLoading());
    final result = await updateMedication(medication);
    emit(result.fold(
      (failure) => MedicationError(message: _mapFailureToMessage(failure)),
      (_) => MedicationSuccess(),
    ));
  }

  Future<void> removeMedication(int id) async {
    emit(MedicationLoading());
    final result = await deleteMedication(id);
    emit(result.fold(
      (failure) => MedicationError(message: _mapFailureToMessage(failure)),
      (_) => MedicationSuccess(),
    ));
  }
}
