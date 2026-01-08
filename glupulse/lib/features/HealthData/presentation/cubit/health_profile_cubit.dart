import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/HealthData/domain/entities/health_profile.dart';
import 'package:glupulse/features/HealthData/domain/usecases/get_health_profile.dart';
import 'package:glupulse/features/HealthData/domain/usecases/update_health_profile.dart';
import 'package:glupulse/features/HealthData/presentation/cubit/health_profile_state.dart';

class HealthProfileCubit extends Cubit<HealthProfileState> {
  final GetHealthProfile getHealthProfile;
  final UpdateHealthProfile updateHealthProfile;

  HealthProfileCubit({
    required this.getHealthProfile,
    required this.updateHealthProfile,
  }) : super(HealthProfileInitial());

  Future<void> fetchHealthProfile() async {
    emit(HealthProfileLoading());
    final result = await getHealthProfile(NoParams());
    result.fold(
      (failure) {
        if (failure is ServerFailure) {
          emit(HealthProfileError(message: failure.message));
        } else {
          emit(const HealthProfileError(message: 'An unexpected error occurred'));
        }
      },
      (healthProfile) => emit(HealthProfileLoaded(healthProfile: healthProfile)),
    );
  }

  Future<void> saveHealthProfile(HealthProfile healthProfile) async {
    emit(HealthProfileSaving());
    final result = await updateHealthProfile(
      UpdateHealthProfileParams(healthProfile: healthProfile),
    );
    result.fold(
      (failure) {
        if (failure is ServerFailure) {
          emit(HealthProfileSaveError(message: failure.message));
        } else {
          emit(const HealthProfileSaveError(message: 'An unexpected error occurred'));
        }
      },
      (_) => emit(HealthProfileSaved()),
    );
  }
}