import 'package:equatable/equatable.dart';

class Hba1c extends Equatable {
  final String? id;
  final DateTime testDate;
  final double hba1cPercentage;
  final int? estimatedAvgGlucose;
  final bool? treatmentChanged;
  final String? medicationChanges;
  final String? dietChanges;
  final String? activityChanges;
  final int? hba1cMmolMol;
  final num? changeFromPrevious;
  final String? trend;
  final String? notes;
  final String? documentUrl;

  const Hba1c({
    this.id,
    required this.testDate,
    required this.hba1cPercentage,
    this.estimatedAvgGlucose,
    this.treatmentChanged,
    this.medicationChanges,
    this.dietChanges,
    this.activityChanges,
    this.hba1cMmolMol,
    this.changeFromPrevious,
    this.trend,
    this.notes,
    this.documentUrl,
  });

  @override
  List<Object?> get props => [
        id,
        testDate,
        hba1cPercentage,
        estimatedAvgGlucose,
        treatmentChanged,
        medicationChanges,
        dietChanges,
        activityChanges,
        hba1cMmolMol,
        changeFromPrevious,
        trend,
        notes,
        documentUrl,
      ];
}
