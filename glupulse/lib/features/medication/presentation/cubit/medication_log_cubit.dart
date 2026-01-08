import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/medication/domain/entities/medication_log.dart';
import 'package:glupulse/features/medication/domain/usecases/medication_log_usecases.dart';

part 'medication_log_state.dart';

class MedicationLogCubit extends Cubit<MedicationLogState> {
  final GetMedicationLogs getMedicationLogs;
  final AddMedicationLog addMedicationLog;
  final UpdateMedicationLog updateMedicationLog;
  final DeleteMedicationLog deleteMedicationLog;

  MedicationLogCubit({
    required this.getMedicationLogs,
    required this.addMedicationLog,
    required this.updateMedicationLog,
    required this.deleteMedicationLog,
  }) : super(MedicationLogInitial());

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return (failure as ServerFailure).message;
      default:
        return 'Unexpected error';
    }
  }

  Future<void> fetchMedicationLogs() async {
    emit(MedicationLogLoading());
    final result = await getMedicationLogs(NoParams());
    emit(result.fold(
      (failure) => MedicationLogError(message: _mapFailureToMessage(failure)),
      (logs) => MedicationLogLoaded(logs: logs),
    ));
  }

  Future<void> createMedicationLog(MedicationLog log) async {
    emit(MedicationLogLoading());
    final result = await addMedicationLog(log);
    emit(result.fold(
      (failure) => MedicationLogError(message: _mapFailureToMessage(failure)),
      (_) => MedicationLogSuccess(),
    ));
  }

  Future<void> editMedicationLog(MedicationLog log) async {
    emit(MedicationLogLoading());
    final result = await updateMedicationLog(log);
    emit(result.fold(
      (failure) => MedicationLogError(message: _mapFailureToMessage(failure)),
      (_) => MedicationLogSuccess(),
    ));
  }

  Future<void> removeMedicationLog(String id) async {
    emit(MedicationLogLoading());
    final result = await deleteMedicationLog(id);
    emit(result.fold(
      (failure) => MedicationLogError(message: _mapFailureToMessage(failure)),
      (_) => MedicationLogSuccess(),
    ));
  }
}
