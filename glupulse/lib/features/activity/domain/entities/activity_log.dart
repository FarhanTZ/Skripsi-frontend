import 'package:equatable/equatable.dart';

class ActivityLog extends Equatable {
  final String? activityId;
  final String? userId;
  final DateTime activityTimestamp;
  final String activityCode;
  final String intensity;
  final int durationMinutes;
  final int? perceivedExertion;
  final int? stepsCount;
  final int? preActivityCarbs;
  final int? waterIntakeMl;
  final String? issueDescription;
  final String source;
  final String? syncId;
  final String? notes;

  const ActivityLog({
    this.activityId,
    this.userId,
    required this.activityTimestamp,
    required this.activityCode,
    required this.intensity,
    required this.durationMinutes,
    this.perceivedExertion,
    this.stepsCount,
    this.preActivityCarbs,
    this.waterIntakeMl,
    this.issueDescription,
    required this.source,
    this.syncId,
    this.notes,
  });

  @override
  List<Object?> get props => [
        activityId,
        userId,
        activityTimestamp,
        activityCode,
        intensity,
        durationMinutes,
        perceivedExertion,
        stepsCount,
        preActivityCarbs,
        waterIntakeMl,
        issueDescription,
        source,
        syncId,
        notes,
      ];
}
