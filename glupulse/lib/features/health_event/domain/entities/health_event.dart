import 'package:equatable/equatable.dart';

class HealthEvent extends Equatable {
  final String? id;
  final DateTime eventDate;
  final String eventType; // Constraint: ['hypoglycemia', 'hyperglycemia', 'illness', 'other']
  final String severity; // Constraint: ['mild', 'moderate', 'severe', 'critical']
  final int? glucoseValue; // Mandatory For ['Hypoglicemia', 'Hyperglycemia']
  final double? ketoneValueMmol; // Mandatory For ['Hyperglycemia']
  final List<String> symptoms; // Mandatory
  final List<String> treatments; // Mandatory
  final bool requiredMedicalAttention;
  final String? notes;

  const HealthEvent({
    this.id,
    required this.eventDate,
    required this.eventType,
    required this.severity,
    this.glucoseValue,
    this.ketoneValueMmol,
    required this.symptoms,
    required this.treatments,
    required this.requiredMedicalAttention,
    this.notes,
  });

  @override
  List<Object?> get props => [
        id,
        eventDate,
        eventType,
        severity,
        glucoseValue,
        ketoneValueMmol,
        symptoms,
        treatments,
        requiredMedicalAttention,
        notes,
      ];
}
