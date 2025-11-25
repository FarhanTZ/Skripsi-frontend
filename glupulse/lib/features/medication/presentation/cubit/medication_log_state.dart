part of 'medication_log_cubit.dart';

abstract class MedicationLogState extends Equatable {
  const MedicationLogState();

  @override
  List<Object> get props => [];
}

class MedicationLogInitial extends MedicationLogState {}

class MedicationLogLoading extends MedicationLogState {}

class MedicationLogLoaded extends MedicationLogState {
  final List<MedicationLog> logs;

  const MedicationLogLoaded({required this.logs});

  @override
  List<Object> get props => [logs];
}

class MedicationLogSuccess extends MedicationLogState {}

class MedicationLogError extends MedicationLogState {
  final String message;

  const MedicationLogError({required this.message});

  @override
  List<Object> get props => [message];
}
