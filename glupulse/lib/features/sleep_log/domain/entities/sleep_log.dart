import 'package:equatable/equatable.dart';

class SleepLog extends Equatable {
  final String? id;
  final String? userId;
  final String sleepDate; // Keeping as String or DateTime? API says "2025-11-24". Let's use DateTime or String. Hba1c used DateTime for testDate. I'll use DateTime.
  final DateTime bedTime;
  final DateTime wakeTime;
  final int? qualityRating;
  final int? trackerScore;
  final int? deepSleepMinutes;
  final int? remSleepMinutes;
  final int? lightSleepMinutes;
  final int? awakeMinutes;
  final int? averageHrv;
  final int? restingHeartRate;
  final List<String>? tags;
  final String? source;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SleepLog({
    this.id,
    this.userId,
    required this.sleepDate,
    required this.bedTime,
    required this.wakeTime,
    this.qualityRating,
    this.trackerScore,
    this.deepSleepMinutes,
    this.remSleepMinutes,
    this.lightSleepMinutes,
    this.awakeMinutes,
    this.averageHrv,
    this.restingHeartRate,
    this.tags,
    this.source,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        sleepDate,
        bedTime,
        wakeTime,
        qualityRating,
        trackerScore,
        deepSleepMinutes,
        remSleepMinutes,
        lightSleepMinutes,
        awakeMinutes,
        averageHrv,
        restingHeartRate,
        tags,
        source,
        notes,
        createdAt,
        updatedAt,
      ];
}
