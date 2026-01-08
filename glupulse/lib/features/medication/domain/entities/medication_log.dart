import 'package:equatable/equatable.dart';

class MedicationLog extends Equatable {
  final String? id;
  final String? userId;
  final int medicationId;
  final String? medicationName; // From GET response
  final DateTime timestamp;
  final double doseAmount;
  final String reason;
  final bool isPumpDelivery;
  final int deliveryDurationMinutes;
  final String? notes;

  const MedicationLog({
    this.id,
    this.userId,
    required this.medicationId,
    this.medicationName,
    required this.timestamp,
    required this.doseAmount,
    required this.reason,
    this.isPumpDelivery = false,
    this.deliveryDurationMinutes = 0,
    this.notes,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        medicationId,
        medicationName,
        timestamp,
        doseAmount,
        reason,
        isPumpDelivery,
        deliveryDurationMinutes,
        notes,
      ];
}
