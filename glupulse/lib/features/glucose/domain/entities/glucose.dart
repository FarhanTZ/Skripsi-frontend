import 'package:equatable/equatable.dart';

class Glucose extends Equatable {
  final String? readingId;
  final String? userId;
  final int glucoseValue;
  final DateTime readingTimestamp;
  final String readingType;
  final String? trendArrow;
  final int? rateOfChange;
  final String source;
  final String? deviceId;
  final String? deviceName;
  final bool? isFlagged;
  final String? flagReason;
  final bool? isOutlier;
  final String? notes;
  final List<String>? symptoms;

  const Glucose({
    this.readingId,
    this.userId,
    required this.glucoseValue,
    required this.readingTimestamp,
    required this.readingType,
    this.trendArrow,
    this.rateOfChange,
    required this.source,
    this.deviceId,
    this.deviceName,
    this.isFlagged,
    this.flagReason,
    this.isOutlier,
    this.notes,
    this.symptoms,
  });

  @override
  List<Object?> get props => [
        readingId,
        userId,
        glucoseValue,
        readingTimestamp,
        readingType,
        trendArrow,
        rateOfChange,
        source,
        deviceId,
        deviceName,
        isFlagged,
        flagReason,
        isOutlier,
        notes,
        symptoms,
      ];
}
