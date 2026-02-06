import 'package:glupulse/features/medication/domain/entities/medication.dart';

class MedicationModel extends Medication {
  const MedicationModel({
    super.id,
    super.userId,
    required super.displayName,
    required super.medicationType,
    required super.defaultDoseUnit,
    super.isActive,
  });

  factory MedicationModel.fromJson(Map<String, dynamic> json) {
    return MedicationModel(
      id: json['medication_id'],
      userId: json['user_id'],
      displayName: json['display_name'],
      medicationType: json['medication_type'],
      defaultDoseUnit: json['default_dose_unit'],
      isActive: json['is_active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medication_id': id,
      'user_id': userId,
      'display_name': displayName,
      'medication_type': medicationType,
      'default_dose_unit': defaultDoseUnit,
      'is_active': isActive,
    };
  }

  factory MedicationModel.fromEntity(Medication entity) {
    return MedicationModel(
      id: entity.id,
      userId: entity.userId,
      displayName: entity.displayName,
      medicationType: entity.medicationType,
      defaultDoseUnit: entity.defaultDoseUnit,
      isActive: entity.isActive,
    );
  }
}
