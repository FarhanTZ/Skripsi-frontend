import 'package:glupulse/features/medication/domain/entities/medication.dart';

class MedicationModel extends Medication {
  const MedicationModel({
    int? id,
    String? userId,
    required String displayName,
    required String medicationType,
    required String defaultDoseUnit,
    bool? isActive,
  }) : super(
          id: id,
          userId: userId,
          displayName: displayName,
          medicationType: medicationType,
          defaultDoseUnit: defaultDoseUnit,
          isActive: isActive,
        );

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
