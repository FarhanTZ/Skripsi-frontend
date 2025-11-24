import 'package:glupulse/features/hba1c/domain/entities/hba1c.dart';

class Hba1cModel extends Hba1c {
  const Hba1cModel({
    String? id,
    required DateTime testDate,
    required double hba1cPercentage,
    int? estimatedAvgGlucose,
    bool? treatmentChanged,
    String? medicationChanges,
    String? dietChanges,
    String? activityChanges,
    String? notes,
    String? documentUrl,
  }) : super(
          id: id,
          testDate: testDate,
          hba1cPercentage: hba1cPercentage,
          estimatedAvgGlucose: estimatedAvgGlucose,
          treatmentChanged: treatmentChanged,
          medicationChanges: medicationChanges,
          dietChanges: dietChanges,
          activityChanges: activityChanges,
          notes: notes,
          documentUrl: documentUrl,
        );

  factory Hba1cModel.fromJson(Map<String, dynamic> json) {
    return Hba1cModel(
      // --- INI PERBAIKANNYA ---
      // Mengambil 'hba1c_id' dari JSON dan memasukkannya ke 'id'
      id: json['hba1c_id'], 
      testDate: DateTime.parse(json['test_date']),
      hba1cPercentage: (json['hba1c_percentage'] as num).toDouble(),
      estimatedAvgGlucose: json['estimated_avg_glucose'],
      treatmentChanged: json['treatment_changed'],
      medicationChanges: json['medication_changes'],
      dietChanges: json['diet_changes'],
      activityChanges: json['activity_changes'],
      notes: json['notes'],
      documentUrl: json['document_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // Saat mengirim ke server, kita tidak perlu mengirim 'hba1c_id'
      // karena biasanya server yang membuatnya.
      // 'id' juga tidak perlu jika hanya untuk create.
      // Untuk update, ID biasanya ada di URL.
      'test_date': testDate.toIso8601String().split('T').first, // Format YYYY-MM-DD
      'hba1c_percentage': hba1cPercentage,
      'estimated_avg_glucose': estimatedAvgGlucose,
      'treatment_changed': treatmentChanged,
      'medication_changes': medicationChanges,
      'diet_changes': dietChanges,
      'activity_changes': activityChanges,
      'notes': notes,
      'document_url': documentUrl,
    };
  }

  factory Hba1cModel.fromEntity(Hba1c entity) {
    return Hba1cModel(
      id: entity.id,
      testDate: entity.testDate,
      hba1cPercentage: entity.hba1cPercentage,
      estimatedAvgGlucose: entity.estimatedAvgGlucose,
      treatmentChanged: entity.treatmentChanged,
      medicationChanges: entity.medicationChanges,
      dietChanges: entity.dietChanges,
      activityChanges: entity.activityChanges,
      notes: entity.notes,
      documentUrl: entity.documentUrl,
    );
  }
}
