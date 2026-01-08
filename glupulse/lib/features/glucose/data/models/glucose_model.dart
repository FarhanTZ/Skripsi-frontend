import 'package:glupulse/features/glucose/domain/entities/glucose.dart';

class GlucoseModel extends Glucose {
  const GlucoseModel({
    String? readingId,
    String? userId,
    required int glucoseValue,
    required DateTime readingTimestamp,
    required String readingType,
    String? trendArrow,
    int? rateOfChange,
    required String source,
    String? deviceId,
    String? deviceName,
    bool? isFlagged,
    String? flagReason,
    bool? isOutlier,
    String? notes,
    List<String>? symptoms,
  }) : super(
          readingId: readingId,
          userId: userId,
          glucoseValue: glucoseValue,
          readingTimestamp: readingTimestamp,
          readingType: readingType,
          trendArrow: trendArrow,
          rateOfChange: rateOfChange,
          source: source,
          deviceId: deviceId,
          deviceName: deviceName,
          isFlagged: isFlagged,
          flagReason: flagReason,
          isOutlier: isOutlier,
          notes: notes,
          symptoms: symptoms,
        );

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
