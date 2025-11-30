part of 'meal_log_cubit.dart';

abstract class MealLogState extends Equatable {
  const MealLogState();

  @override
  List<Object> get props => [];
}

class MealLogInitial extends MealLogState {}

class MealLogLoading extends MealLogState {}

class MealLogLoaded extends MealLogState {
  final List<MealLog> mealLogs;

  const MealLogLoaded({required this.mealLogs});

  @override
  List<Object> get props => [mealLogs];
}

class MealLogDetailLoaded extends MealLogState {
  final MealLog mealLog;

  const MealLogDetailLoaded({required this.mealLog});

  @override
  List<Object> get props => [mealLog];
}

class MealLogAdded extends MealLogState {
  final MealLog mealLog;

  const MealLogAdded({required this.mealLog});

  @override
  List<Object> get props => [mealLog];
}

class MealLogUpdated extends MealLogState {}

class MealLogDeleted extends MealLogState {}

class MealLogError extends MealLogState {
  final String message;

  const MealLogError({required this.message});

  @override
  List<Object> get props => [message];
}
