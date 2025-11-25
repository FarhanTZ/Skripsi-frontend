import 'package:glupulse/features/sleep_log/domain/entities/sleep_log.dart';

class SleepLogModel extends SleepLog {
  const SleepLogModel({
    String? id,
    String? userId,
    required String sleepDate,
    required DateTime bedTime,
    required DateTime wakeTime,
    int? qualityRating,
    int? trackerScore,
    int? deepSleepMinutes,
    int? remSleepMinutes,
    int? lightSleepMinutes,
    int? awakeMinutes,
    int? averageHrv,
    int? restingHeartRate,
    List<String>? tags,
    String? source,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(
          id: id,
          userId: userId,
          sleepDate: sleepDate,
          bedTime: bedTime,
          wakeTime: wakeTime,
          qualityRating: qualityRating,
          trackerScore: trackerScore,
          deepSleepMinutes: deepSleepMinutes,
          remSleepMinutes: remSleepMinutes,
          lightSleepMinutes: lightSleepMinutes,
          awakeMinutes: awakeMinutes,
          averageHrv: averageHrv,
          restingHeartRate: restingHeartRate,
          tags: tags,
          source: source,
          notes: notes,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory SleepLogModel.fromJson(Map<String, dynamic> json) {
    return SleepLogModel(
      id: json['sleep_id'],
      userId: json['user_id'],
      sleepDate: json['sleep_date'],
      bedTime: DateTime.parse(json['bed_time']),
      wakeTime: DateTime.parse(json['wake_time']),
      qualityRating: json['quality_rating'],
      trackerScore: json['tracker_score'],
      deepSleepMinutes: json['deep_sleep_minutes'],
      remSleepMinutes: json['rem_sleep_minutes'],
      lightSleepMinutes: json['light_sleep_minutes'],
      awakeMinutes: json['awake_minutes'],
      averageHrv: json['average_hrv'],
      restingHeartRate: json['resting_heart_rate'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      source: json['source'],
      notes: json['notes'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sleep_id': id,
      'user_id': userId,
      'sleep_date': sleepDate,
      'bed_time': _toRfc3339(bedTime),
      'wake_time': _toRfc3339(wakeTime),
      'quality_rating': qualityRating,
      'tracker_score': trackerScore,
      'deep_sleep_minutes': deepSleepMinutes,
      'rem_sleep_minutes': remSleepMinutes,
      'light_sleep_minutes': lightSleepMinutes,
      'awake_minutes': awakeMinutes,
      'average_hrv': averageHrv,
      'resting_heart_rate': restingHeartRate,
      'tags': tags ?? [],
      'source': source,
      'notes': notes,
    };
  }

  String _toRfc3339(DateTime date) {
    // Helper to format DateTime to RFC3339 with offset (e.g., 2025-11-24T23:00:00+07:00)
    if (date.isUtc) {
      return date.toIso8601String();
    }
    
    String iso = date.toIso8601String();
    // Remove milliseconds if present
    if (iso.contains('.')) {
      iso = iso.substring(0, iso.indexOf('.'));
    }
    
    final offset = date.timeZoneOffset;
    final sign = offset.isNegative ? '-' : '+';
    final hours = offset.inHours.abs().toString().padLeft(2, '0');
    final minutes = (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');
    
    return '$iso$sign$hours:$minutes';
  }

  factory SleepLogModel.fromEntity(SleepLog entity) {
    return SleepLogModel(
      id: entity.id,
      userId: entity.userId,
      sleepDate: entity.sleepDate,
      bedTime: entity.bedTime,
      wakeTime: entity.wakeTime,
      qualityRating: entity.qualityRating,
      trackerScore: entity.trackerScore,
      deepSleepMinutes: entity.deepSleepMinutes,
      remSleepMinutes: entity.remSleepMinutes,
      lightSleepMinutes: entity.lightSleepMinutes,
      awakeMinutes: entity.awakeMinutes,
      averageHrv: entity.averageHrv,
      restingHeartRate: entity.restingHeartRate,
      tags: entity.tags,
      source: entity.source,
      notes: entity.notes,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
