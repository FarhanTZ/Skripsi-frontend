import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:glupulse/features/activity/domain/entities/activity_log.dart';
import 'package:glupulse/features/activity/domain/entities/activity_type.dart';

abstract class ActivityState extends Equatable {
  const ActivityState();

  @override
  List<Object> get props => [];
}

class ActivityInitial extends ActivityState {}

class ActivityLoading extends ActivityState {}

class ActivityTypesLoaded extends ActivityState {
  final List<ActivityType> activityTypes;

  const ActivityTypesLoaded({required this.activityTypes});

  @override
  List<Object> get props => [activityTypes];
}

class ActivityLogsLoaded extends ActivityState {
  final List<ActivityLog> activityLogs;
  final String? filterCode;

  const ActivityLogsLoaded({required this.activityLogs, this.filterCode});

  @override
  List<Object> get props => [activityLogs, if (filterCode != null) filterCode!];
}

class ActivityOperationSuccess extends ActivityState {
  final String message;

  const ActivityOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class ActivityError extends ActivityState {
  final String message;

  const ActivityError(this.message);

  @override
  List<Object> get props => [message];
}
