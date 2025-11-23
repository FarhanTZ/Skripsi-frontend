import 'package:equatable/equatable.dart';
import 'package:glupulse/features/HealthData/domain/entities/health_profile.dart';

abstract class HealthProfileState extends Equatable {
  const HealthProfileState();

  @override
  List<Object> get props => [];
}

class HealthProfileInitial extends HealthProfileState {}

class HealthProfileLoading extends HealthProfileState {}

class HealthProfileLoaded extends HealthProfileState {
  final HealthProfile healthProfile;

  const HealthProfileLoaded({required this.healthProfile});

  @override
  List<Object> get props => [healthProfile];
}

class HealthProfileError extends HealthProfileState {
  final String message;

  const HealthProfileError({required this.message});

  @override
  List<Object> get props => [message];
}

class HealthProfileSaving extends HealthProfileState {}

class HealthProfileSaved extends HealthProfileState {}

class HealthProfileSaveError extends HealthProfileState {
  final String message;

  const HealthProfileSaveError({required this.message});

  @override
  List<Object> get props => [message];
}
