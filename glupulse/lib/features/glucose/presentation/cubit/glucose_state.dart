part of 'glucose_cubit.dart';

abstract class GlucoseState extends Equatable {
  const GlucoseState();

  @override
  List<Object> get props => [];
}

class GlucoseInitial extends GlucoseState {}

class GlucoseLoading extends GlucoseState {}

class GlucoseLoaded extends GlucoseState {
  final List<Glucose> glucoseRecords;

  const GlucoseLoaded({required this.glucoseRecords});

  @override
  List<Object> get props => [glucoseRecords];
}

class GlucoseDetailLoaded extends GlucoseState {
  final Glucose glucoseRecord;

  const GlucoseDetailLoaded({required this.glucoseRecord});

  @override
  List<Object> get props => [glucoseRecord];
}

class GlucoseAdded extends GlucoseState {}

class GlucoseUpdated extends GlucoseState {}

class GlucoseDeleted extends GlucoseState {}

class GlucoseError extends GlucoseState {
  final String message;

  const GlucoseError({required this.message});

  @override
  List<Object> get props => [message];
}
