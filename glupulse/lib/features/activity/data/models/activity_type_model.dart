import 'package:glupulse/features/activity/domain/entities/activity_type.dart';

class ActivityTypeModel extends ActivityType {
  const ActivityTypeModel({
    required int activityTypeId,
    required String activityCode,
    required String displayName,
    required String intensityLevel,
  }) : super(
          activityTypeId: activityTypeId,
          activityCode: activityCode,
          displayName: displayName,
          intensityLevel: intensityLevel,
        );

  factory ActivityTypeModel.fromJson(Map<String, dynamic> json) {
    return ActivityTypeModel(
      activityTypeId: json['activity_type_id'],
      activityCode: json['activity_code'],
      displayName: json['display_name'],
      intensityLevel: json['intensity_level'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activity_type_id': activityTypeId,
      'activity_code': activityCode,
      'display_name': displayName,
      'intensity_level': intensityLevel,
    };
  }
}
