import 'package:glupulse/features/activity/domain/entities/activity_log.dart';

class ActivityLogModel extends ActivityLog {
  const ActivityLogModel({
    String? activityId,
    String? userId,
    required DateTime activityTimestamp,
    required String activityCode,
    required String intensity,
    required int durationMinutes,
    int? perceivedExertion,
    int? stepsCount,
    int? preActivityCarbs,
    int? waterIntakeMl,
    String? issueDescription,
    required String source,
    String? syncId,
    String? notes,
  }) : super(
          activityId: activityId,
          userId: userId,
          activityTimestamp: activityTimestamp,
          activityCode: activityCode,
          intensity: intensity,
          durationMinutes: durationMinutes,
          perceivedExertion: perceivedExertion,
          stepsCount: stepsCount,
          preActivityCarbs: preActivityCarbs,
          waterIntakeMl: waterIntakeMl,
          issueDescription: issueDescription,
          source: source,
          syncId: syncId,
          notes: notes,
        );

  factory ActivityLogModel.fromJson(Map<String, dynamic> json) {
    return ActivityLogModel(
      activityId: json['activity_id'],
      userId: json['user_id'],
      activityTimestamp: DateTime.parse(json['activity_timestamp']).toLocal(),
      activityCode: json['activity_code'],
      intensity: json['intensity'],
      durationMinutes: json['duration_minutes'],
      perceivedExertion: json['perceived_exertion'],
      stepsCount: json['steps_count'],
      preActivityCarbs: json['pre_activity_carbs'],
      waterIntakeMl: json['water_intake_ml'],
      issueDescription: json['issue_description'],
      source: json['source'] ?? 'manual',
      syncId: json['sync_id'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activity_id': activityId,
      'user_id': userId,
      'activity_timestamp': activityTimestamp.toUtc().toIso8601String(),
      'activity_code': activityCode,
      'intensity': intensity,
      'duration_minutes': durationMinutes,
      'perceived_exertion': perceivedExertion ?? 5,
      'steps_count': stepsCount ?? 0,
      'pre_activity_carbs': preActivityCarbs ?? 0,
      'water_intake_ml': waterIntakeMl ?? 0,
      'issue_description': issueDescription ?? "None",
      'source': source,
      'sync_id': syncId ?? "",
      'notes': notes ?? "",
    };
  }

  factory ActivityLogModel.fromEntity(ActivityLog entity) {
    return ActivityLogModel(
      activityId: entity.activityId,
      userId: entity.userId,
      activityTimestamp: entity.activityTimestamp,
      activityCode: entity.activityCode,
      intensity: entity.intensity,
      durationMinutes: entity.durationMinutes,
      perceivedExertion: entity.perceivedExertion,
      stepsCount: entity.stepsCount,
      preActivityCarbs: entity.preActivityCarbs,
      waterIntakeMl: entity.waterIntakeMl,
      issueDescription: entity.issueDescription,
      source: entity.source,
      syncId: entity.syncId,
      notes: entity.notes,
    );
  }
}
