import 'package:equatable/equatable.dart';

class ActivityType extends Equatable {
  final int activityTypeId;
  final String activityCode;
  final String displayName;
  final String intensityLevel;

  const ActivityType({
    required this.activityTypeId,
    required this.activityCode,
    required this.displayName,
    required this.intensityLevel,
  });

  @override
  List<Object?> get props => [activityTypeId, activityCode, displayName, intensityLevel];
}
