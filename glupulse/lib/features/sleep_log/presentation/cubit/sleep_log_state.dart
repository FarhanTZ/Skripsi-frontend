part of 'sleep_log_cubit.dart';

abstract class SleepLogState extends Equatable {
  const SleepLogState();

  @override
  List<Object> get props => [];
}

class SleepLogInitial extends SleepLogState {}

class SleepLogLoading extends SleepLogState {}

class SleepLogLoaded extends SleepLogState {
  final List<SleepLog> sleepLogs;

  const SleepLogLoaded({required this.sleepLogs});

  @override
  List<Object> get props => [sleepLogs];
}

class SleepLogDetailLoaded extends SleepLogState {
  final SleepLog sleepLog;

  const SleepLogDetailLoaded({required this.sleepLog});

  @override
  List<Object> get props => [sleepLog];
}

class SleepLogAdded extends SleepLogState {}

class SleepLogUpdated extends SleepLogState {}

class SleepLogDeleted extends SleepLogState {}

class SleepLogError extends SleepLogState {
  final String message;

  const SleepLogError({required this.message});

  @override
  List<Object> get props => [message];
}
