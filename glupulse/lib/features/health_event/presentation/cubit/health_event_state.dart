part of 'health_event_cubit.dart';

abstract class HealthEventState extends Equatable {
  const HealthEventState();

  @override
  List<Object> get props => [];
}

class HealthEventInitial extends HealthEventState {}

class HealthEventLoading extends HealthEventState {}

class HealthEventLoaded extends HealthEventState {
  final List<HealthEvent> healthEventRecords;

  const HealthEventLoaded({required this.healthEventRecords});

  @override
  List<Object> get props => [healthEventRecords];
}

class HealthEventDetailLoaded extends HealthEventState {
  final HealthEvent healthEventRecord;

  const HealthEventDetailLoaded({required this.healthEventRecord});

  @override
  List<Object> get props => [healthEventRecord];
}

class HealthEventAdded extends HealthEventState {}

class HealthEventUpdated extends HealthEventState {}

class HealthEventDeleted extends HealthEventState {}

class HealthEventError extends HealthEventState {
  final String message;

  const HealthEventError({required this.message});

  @override
  List<Object> get props => [message];
}
