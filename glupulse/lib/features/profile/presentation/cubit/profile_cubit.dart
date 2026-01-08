import 'package:bloc/bloc.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/auth/domain/entities/user_entity.dart';
import 'package:glupulse/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:glupulse/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:glupulse/features/profile/domain/usecases/update_username_usecase.dart';
import 'package:glupulse/features/profile/presentation/cubit/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final UpdateUsernameUseCase updateUsernameUseCase;

  ProfileCubit({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
    required this.updateUsernameUseCase,
  }) : super(ProfileInitial());

  Future<void> fetchProfile() async {
    emit(ProfileLoading());
    final result = await getProfileUseCase(NoParams());
    result.fold(
      (failure) => emit(ProfileError(_mapFailureToMessage(failure))),
      (user) => emit(ProfileLoaded(user)),
    );
  }

  Future<void> updateProfile(UpdateProfileParams params) async {
    emit(ProfileLoading());

    UserEntity? latestUser;
    Failure? firstFailure;

    // 1. Update username jika ada perubahan
    if (params.username != null && params.username!.isNotEmpty) {
      // Pastikan password juga dikirim
      if (params.password == null || params.password!.isEmpty) {
        emit(const ProfileError('Password diperlukan untuk mengubah username.'));
        return;
      }
      final usernameResult = await updateUsernameUseCase(UpdateUsernameParams(newUsername: params.username!));
      usernameResult.fold(
        (failure) {
          firstFailure = failure;
        },
        (user) {
          latestUser = user;
        },
      );
    }
  
    // Jika update username gagal, langsung hentikan dan tampilkan error
    if (firstFailure != null) {
      emit(ProfileError(_mapFailureToMessage(firstFailure!)));
      return;
    }

    // 2. Update sisa data profil
    final profileResult = await updateProfileUseCase(params);
    profileResult.fold(
      (failure) => emit(ProfileError(_mapFailureToMessage(failure))),
      (user) => emit(ProfileUpdateSuccess(latestUser ?? user)), // Gunakan user terbaru
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    }
    return 'Terjadi kesalahan yang tidak terduga.';
  }
}