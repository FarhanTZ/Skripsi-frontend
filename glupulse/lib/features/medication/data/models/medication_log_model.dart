import 'package:glupulse/features/medication/domain/entities/medication_log.dart';

class MedicationLogModel extends MedicationLog {
  const MedicationLogModel({
    super.id,
    super.userId,
    required super.medicationId,
    super.medicationName,
    required super.timestamp,
    required super.doseAmount,
    required super.reason,
    super.isPumpDelivery,
    super.deliveryDurationMinutes,
    super.notes,
  });

  factory MedicationLogModel.fromJson(Map<String, dynamic> json) {
    return MedicationLogModel(
      id: json['medicationlog_id'],
      userId: json['user_id'],
      medicationId: json['medication_id'],
      medicationName: json['medication_name'],
      timestamp: DateTime.parse(json['timestamp']),
      doseAmount: (json['dose_amount'] as num).toDouble(),
      reason: json['reason'],
      isPumpDelivery: json['is_pump_delivery'] ?? false,
      deliveryDurationMinutes: json['delivery_duration_minutes'] ?? 0,
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medicationlog_id': id,
      'user_id': userId,
      'medication_id': medicationId,
      'medication_name': medicationName,
      'timestamp': _toRfc3339(timestamp),
      'dose_amount': doseAmount,
      'reason': reason,
      'is_pump_delivery': isPumpDelivery,
      'delivery_duration_minutes': deliveryDurationMinutes,
      'notes': notes,
    };
  }

  String _toRfc3339(DateTime date) {
    if (date.isUtc) {
      return date.toIso8601String();
    }
    String iso = date.toIso8601String();
    if (iso.contains('.')) {
      iso = iso.substring(0, iso.indexOf('.'));
    }
    final offset = date.timeZoneOffset;
    final sign = offset.isNegative ? '-' : '+';
    final hours = offset.inHours.abs().toString().padLeft(2, '0');
    final minutes = (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');
    return '$iso$sign$hours:$minutes';
  }

  factory MedicationLogModel.fromEntity(MedicationLog entity) {
    return MedicationLogModel(
      id: entity.id,
      userId: entity.userId,
      medicationId: entity.medicationId,
      medicationName: entity.medicationName,
      timestamp: entity.timestamp,
      doseAmount: entity.doseAmount,
      reason: entity.reason,
      isPumpDelivery: entity.isPumpDelivery,
      deliveryDurationMinutes: entity.deliveryDurationMinutes,
      notes: entity.notes,
    );
  }
}
