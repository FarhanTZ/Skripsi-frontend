part of 'hba1c_cubit.dart';

abstract class Hba1cState extends Equatable {
  const Hba1cState();

  @override
  List<Object> get props => [];
}

class Hba1cInitial extends Hba1cState {}

class Hba1cLoading extends Hba1cState {}

class Hba1cLoaded extends Hba1cState {
  final List<Hba1c> hba1cRecords;

  const Hba1cLoaded({required this.hba1cRecords});

  @override
  List<Object> get props => [hba1cRecords];
}

class Hba1cDetailLoaded extends Hba1cState {
  final Hba1c hba1cRecord;

  const Hba1cDetailLoaded({required this.hba1cRecord});

  @override
  List<Object> get props => [hba1cRecord];
}

class Hba1cAdded extends Hba1cState {}

class Hba1cUpdated extends Hba1cState {}

class Hba1cDeleted extends Hba1cState {}

class Hba1cError extends Hba1cState {
  final String message;

  const Hba1cError({required this.message});

  @override
  List<Object> get props => [message];
}
