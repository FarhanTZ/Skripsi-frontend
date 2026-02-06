import 'package:glupulse/features/health_event/domain/entities/health_event.dart';

class HealthEventModel extends HealthEvent {
  const HealthEventModel({
    super.id,
    required super.eventDate,
    required super.eventType,
    required super.severity,
    super.glucoseValue,
    super.ketoneValueMmol,
    required super.symptoms,
    required super.treatments,
    required super.requiredMedicalAttention,
    super.notes,
  });

  factory HealthEventModel.fromJson(Map<String, dynamic> json) {
    return HealthEventModel(
      // --- INI PERBAIKANNYA ---
      // Mengambil 'event_id' dari JSON dan memasukkannya ke 'id'
      id: json['event_id'] as String?,
      eventDate: DateTime.parse(json['event_date'] as String),
      eventType: json['event_type'] as String,
      severity: json['severity'] as String,
      glucoseValue: json['glucose_value'] as int?,
      ketoneValueMmol: (json['ketone_value_mmol'] as num?)?.toDouble(),
      symptoms: List<String>.from(json['symptoms'] as List),
      treatments: List<String>.from(json['treatments'] as List),
      requiredMedicalAttention: json['required_medical_attention'] as bool,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'id' tidak perlu dikirim saat membuat atau memperbarui,
      // karena server yang menanganinya atau ID ada di URL.
      // 'id': id, 
      'event_date': eventDate.toIso8601String().split('T').first,
      'event_type': eventType,
      'severity': severity,
      'glucose_value': glucoseValue,
      'ketone_value_mmol': ketoneValueMmol,
      'symptoms': symptoms,
      'treatments': treatments,
      'required_medical_attention': requiredMedicalAttention,
      'notes': notes,
    };
  }

  // Convert HealthEvent entity to HealthEventModel
  factory HealthEventModel.fromEntity(HealthEvent entity) {
    return HealthEventModel(
      id: entity.id,
      eventDate: entity.eventDate,
      eventType: entity.eventType,
      severity: entity.severity,
      glucoseValue: entity.glucoseValue,
      ketoneValueMmol: entity.ketoneValueMmol,
      symptoms: entity.symptoms,
      treatments: entity.treatments,
      requiredMedicalAttention: entity.requiredMedicalAttention,
      notes: entity.notes,
    );
  }
}