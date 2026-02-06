import 'package:glupulse/features/glucose/domain/entities/glucose.dart';

class GlucoseModel extends Glucose {
  const GlucoseModel({
    super.readingId,
    super.userId,
    required super.glucoseValue,
    required super.readingTimestamp,
    required super.readingType,
    super.trendArrow,
    super.rateOfChange,
    required super.source,
    super.deviceId,
    super.deviceName,
    super.isFlagged,
    super.flagReason,
    super.isOutlier,
    super.notes,
    super.symptoms,
  });

  factory GlucoseModel.fromJson(Map<String, dynamic> json) {
    return GlucoseModel(
      readingId: json['reading_id'],
      userId: json['user_id'],
      glucoseValue: json['glucose_value'],
      readingTimestamp: DateTime.parse(json['reading_timestamp']).toLocal(),
      readingType: json['reading_type'],
      trendArrow: json['trend_arrow'],
      rateOfChange: json['rate_of_change'],
      source: json['source'] ?? 'manual',
      deviceId: json['device_id'],
      deviceName: json['device_name'],
      isFlagged: json['is_flagged'],
      flagReason: json['flag_reason'],
      isOutlier: json['is_outlier'],
      notes: json['notes'],
      symptoms: json['symptoms'] != null ? List<String>.from(json['symptoms']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reading_id': readingId,
      'user_id': userId,
      'glucose_value': glucoseValue,
      'reading_timestamp': readingTimestamp.toUtc().toIso8601String(),
      'reading_type': readingType,
      'trend_arrow': trendArrow,
      'rate_of_change': rateOfChange,
      'source': source,
      'device_id': deviceId,
      'device_name': deviceName,
      'is_flagged': isFlagged,
      'flag_reason': flagReason,
      'is_outlier': isOutlier,
      'notes': notes,
      'symptoms': symptoms,
    };
  }

  factory GlucoseModel.fromEntity(Glucose entity) {
    return GlucoseModel(
      readingId: entity.readingId,
      userId: entity.userId,
      glucoseValue: entity.glucoseValue,
      readingTimestamp: entity.readingTimestamp,
      readingType: entity.readingType,
      trendArrow: entity.trendArrow,
      rateOfChange: entity.rateOfChange,
      source: entity.source,
      deviceId: entity.deviceId,
      deviceName: entity.deviceName,
      isFlagged: entity.isFlagged,
      flagReason: entity.flagReason,
      isOutlier: entity.isOutlier,
      notes: entity.notes,
      symptoms: entity.symptoms,
    );
  }
}
