import 'package:equatable/equatable.dart';

class Medication extends Equatable {
  final int? id;
  final String? userId;
  final String displayName;
  final String medicationType;
  final String defaultDoseUnit;
  final bool? isActive;

  const Medication({
    this.id,
    this.userId,
    required this.displayName,
    required this.medicationType,
    required this.defaultDoseUnit,
    this.isActive,
  });

  @override
  List<Object?> get props => [id, userId, displayName, medicationType, defaultDoseUnit, isActive];
}
