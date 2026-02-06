import 'package:glupulse/features/sleep_log/domain/entities/sleep_log.dart';

class SleepLogModel extends SleepLog {
  const SleepLogModel({
    super.id,
    super.userId,
    required super.sleepDate,
    required super.bedTime,
    required super.wakeTime,
    super.qualityRating,
    super.trackerScore,
    super.deepSleepMinutes,
    super.remSleepMinutes,
    super.lightSleepMinutes,
    super.awakeMinutes,
    super.averageHrv,
    super.restingHeartRate,
    super.tags,
    super.source,
    super.notes,
    super.createdAt,
    super.updatedAt,
  });

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
    final Map<String, dynamic> data = {
      'sleep_date': sleepDate,
      'bed_time': _toRfc3339(bedTime),
      'wake_time': _toRfc3339(wakeTime),
      'quality_rating': qualityRating ?? 0,
      'tracker_score': trackerScore ?? 0,
      'deep_sleep_minutes': deepSleepMinutes ?? 0,
      'rem_sleep_minutes': remSleepMinutes ?? 0,
      'light_sleep_minutes': lightSleepMinutes ?? 0,
      'awake_minutes': awakeMinutes ?? 0,
      'average_hrv': averageHrv ?? 0,
      'resting_heart_rate': restingHeartRate ?? 0,
      'tags': (tags == null || tags!.isEmpty) ? [""] : tags,
      'source': source ?? 'manual',
      'notes': notes ?? '',
    };

    if (id != null) {
      data['sleep_id'] = id;
    }
    if (userId != null) {
      data['user_id'] = userId;
    }

    return data;
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
