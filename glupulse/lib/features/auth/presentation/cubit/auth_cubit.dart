import 'package:bloc/bloc.dart';
import 'package:glupulse/features/auth/presentation/cubit/auth_state.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:glupulse/features/auth/domain/repositories/auth_repository.dart';
import 'package:glupulse/features/auth/domain/entities/user_entity.dart';
import 'package:glupulse/features/auth/domain/usecases/login_with_google_usecase.dart';
import 'package:glupulse/features/auth/domain/usecases/request_password_reset_usecase.dart';
import 'package:glupulse/features/auth/domain/usecases/complete_password_reset_usecase.dart';
import 'package:glupulse/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:glupulse/features/auth/domain/usecases/register_usecase.dart';
import 'package:glupulse/features/profile/domain/usecases/update_password_usecase.dart';
import 'package:glupulse/features/profile/domain/repositories/profile_repository.dart';
import 'package:glupulse/features/profile/domain/usecases/update_username_usecase.dart';
import 'package:glupulse/features/auth/domain/usecases/verify_signup_otp_usecase.dart';
import 'package:glupulse/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:glupulse/features/auth/domain/usecases/login_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:glupulse/injection_container.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// A generic success state that can carry a message.
class AuthSuccess extends AuthState {
  final String message;
  const AuthSuccess(this.message);
}

// --- AuthCubit ---
/// Cubit yang mengelola state otentikasi.
class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final VerifySignupOtpUseCase verifySignupOtpUseCase; // Tambahkan use case baru
  final RegisterUseCase registerUseCase;
  final LoginWithGoogleUseCase loginWithGoogleUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final RequestPasswordResetUseCase requestPasswordResetUseCase;
  final CompletePasswordResetUseCase completePasswordResetUseCase;
  final UpdateUsernameUseCase updateUsernameUseCase;
  final UpdatePasswordUseCase updatePasswordUseCase;
  final AuthRepository authRepository; // Tambahkan AuthRepository
  final ProfileRepository profileRepository; // Tambahkan ProfileRepository
  final GoogleSignIn googleSignIn;

  AuthCubit({
    required this.loginUseCase,
    required this.verifyOtpUseCase,
    required this.verifySignupOtpUseCase,
    required this.registerUseCase,
    required this.loginWithGoogleUseCase,
    required this.getCurrentUserUseCase,
    required this.requestPasswordResetUseCase,
    required this.completePasswordResetUseCase,
    required this.updateUsernameUseCase,
    required this.updatePasswordUseCase,
    required this.authRepository, // Injeksi AuthRepository
    required this.profileRepository, // Injeksi ProfileRepository
    required this.googleSignIn,
  }) : super(AuthInitial());

  /// Metode untuk memeriksa status otentikasi saat aplikasi dimulai.
  Future<void> checkAuthenticationStatus() async {
    print('AuthCubit: Memeriksa status otentikasi...'); // DEBUG
    emit(AuthLoading());

    // Menjalankan pengecekan status dan timer secara bersamaan.
    // Ini memastikan splash screen tampil minimal selama durasi timer.
    final results = await Future.wait([
      getCurrentUserUseCase(NoParams()),
      Future.delayed(const Duration(seconds: 3)), // Timer 3 detik
    ]);

    // Ambil hasil dari pengecekan user (hasil pertama dari Future.wait)
    final authResult = results[0] as Either<Failure, UserEntity>;

    authResult.fold(
      (failure) {
        // Jika tidak ada user di cache, anggap tidak terotentikasi
        print('AuthCubit: Gagal mendapatkan user dari local storage: $failure. Emitting AuthUnauthenticated.'); // DEBUG
        print('AuthCubit: Tidak ada sesi ditemukan. Emitting AuthUnauthenticated.'); // DEBUG
        emit(AuthUnauthenticated());
      },
      (user) {
        // Setelah mendapatkan user, cek kelengkapan profilnya
        if (user.isProfileComplete) {
          print('AuthCubit: Sesi ditemukan dan profil lengkap untuk user: ${user.username}. Emitting AuthAuthenticated.'); // DEBUG
          emit(AuthAuthenticated(user));
        } else {
          print('AuthCubit: Sesi ditemukan tapi profil tidak lengkap untuk user: ${user.username}. Emitting AuthProfileIncomplete.'); // DEBUG
          emit(AuthProfileIncomplete(user));
        }
      },
    );
  }

  /// Metode untuk melakukan proses login.
  Future<void> login(String username, String password) async {
    print('AuthCubit: Memulai proses login untuk username: $username'); // DEBUG
    emit(AuthLoading()); // Emit state loading
    print('AuthCubit: Emitting AuthLoading...'); // DEBUG

    final result = await loginUseCase(LoginParams(username: username, password: password));

    result.fold(
      (failure) {
        final message = _mapFailureToMessage(failure);
        print('AuthCubit: Login gagal. Emitting AuthError: $message'); // DEBUG
        emit(AuthError(message)); // Jika gagal, emit AuthError
      },
      (user) {
        // Sesuai permintaan, selalu arahkan ke halaman OTP setelah login berhasil.
        print('AuthCubit: Login berhasil. Emitting AuthOtpRequired untuk user ID: ${user.id}'); // DEBUG
        print('AuthCubit: User dari login: username="${user.username}", email="${user.email}"'); // DEBUG
        emit(AuthOtpRequired(userId: user.id));
      },
    );
  }

  /// Metode untuk melakukan proses login dengan Google.
  Future<void> loginWithGoogle() async {
    print('AuthCubit: Memulai proses login dengan Google'); // DEBUG
    emit(AuthLoading());
    print('AuthCubit: Emitting AuthLoading...'); // DEBUG

    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        // Pengguna membatalkan proses login
        print('AuthCubit: Login Google dibatalkan oleh pengguna.'); // DEBUG
        emit(AuthInitial()); // Kembali ke state awal
        return;
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        print('AuthCubit: Gagal mendapatkan idToken dari Google.'); // DEBUG
        emit(const AuthError('Gagal mendapatkan token dari Google.'));
        return;
      }

      // Kirim idToken ke backend
      final result = await loginWithGoogleUseCase(LoginWithGoogleParams(idToken: idToken));
      result.fold(
        (failure) => emit(AuthError(_mapFailureToMessage(failure))), (user) => _fetchProfileAndEmitState(user),
      );
    } catch (e) {
      print('AuthCubit: Terjadi error saat login Google: $e'); // DEBUG
      emit(AuthError(_mapFailureToMessage(ServerFailure('Gagal login dengan Google. Silakan coba lagi.'))));
    }
  }

  /// Metode untuk menautkan akun yang sudah ada dengan Google.
  Future<void> linkGoogleAccount() async {
    print('AuthCubit: Memulai proses penautan akun Google'); // DEBUG
    emit(AuthLoading()); // Tampilkan loading indicator di UI

    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        // Pengguna membatalkan proses
        print('AuthCubit: Penautan Google dibatalkan oleh pengguna.'); // DEBUG
        checkAuthenticationStatus(); // Kembali ke state sebelumnya dengan memuat ulang user
        return;
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        print('AuthCubit: Gagal mendapatkan idToken dari Google untuk penautan.'); // DEBUG
        emit(const AuthError('Gagal mendapatkan token dari Google.'));
        return;
      }

      // Panggil repository untuk menautkan akun
      final result = await authRepository.linkGoogleAccount(idToken);
      result.fold(
        (failure) => emit(AuthError(_mapFailureToMessage(failure))), (user) => _fetchProfileAndEmitState(user),
      );
    } catch (e) {
      print('AuthCubit: Terjadi error saat menautkan akun Google: $e'); // DEBUG
      emit(AuthError(_mapFailureToMessage(ServerFailure('Gagal menautkan akun Google. Silakan coba lagi.'))));
    }
  }

  /// Metode untuk melakukan proses registrasi.
  Future<void> register(RegisterParams params) async {
    print('AuthCubit: Memulai proses registrasi untuk username: ${params.username}'); // DEBUG
    emit(AuthLoading());
    print('AuthCubit: Emitting AuthLoading...'); // DEBUG

    final result = await registerUseCase(params);

    result.fold(
      (failure) {
        emit(AuthError(_mapFailureToMessage(failure)));
      },
      (responseModel) {
        // Setelah registrasi, kita mendapatkan pending_id dari response model.
        final pendingId = responseModel.pendingId;
        if (pendingId != null) {
          print('AuthCubit: Registrasi berhasil. Emitting AuthOtpRequired untuk pending ID: $pendingId'); // DEBUG
          emit(AuthOtpRequired(pendingId: pendingId));
        } else {
          emit(const AuthError('Gagal mendapatkan ID registrasi dari server.'));
        }
      },
    );
  }

  /// Metode untuk verifikasi OTP.
  Future<void> verifyOtp({String? userId, String? pendingId, required String otpCode}) async {
    print('AuthCubit: Memulai verifikasi OTP...'); // DEBUG
    emit(AuthLoading());
    print('AuthCubit: Emitting AuthLoading...'); // DEBUG

    late final Future<Either<Failure, UserEntity>> result;

    if (pendingId != null) {
      print('AuthCubit: Verifikasi OTP untuk pendaftaran dengan pending ID: $pendingId'); // DEBUG
      result = verifySignupOtpUseCase(VerifySignupOtpParams(pendingId: pendingId, otpCode: otpCode));
    } else if (userId != null) {
      print('AuthCubit: Verifikasi OTP untuk login dengan user ID: $userId'); // DEBUG
      result = verifyOtpUseCase(VerifyOtpParams(userId: userId, otpCode: otpCode));
    } else {
      emit(const AuthError("ID untuk verifikasi OTP tidak ditemukan."));
      return;
    }

    (await result).fold(
      (failure) {
        final message = _mapFailureToMessage(failure);
        print('AuthCubit: Verifikasi OTP gagal. Emitting AuthError: $message'); // DEBUG
        emit(AuthError(message)); // Jika gagal, emit AuthError
      },
      (user) => _fetchProfileAndEmitState(user),
    );
  }

  /// Helper untuk mengambil profil terbaru dan memancarkan state yang sesuai.
  Future<void> _fetchProfileAndEmitState(UserEntity initialUser) async {
    print('AuthCubit: Mengambil profil lengkap untuk user: ${initialUser.id}');
    // Ambil profil lengkap dari repository
    final profileResult = await profileRepository.getUserProfile();

    profileResult.fold(
      (failure) {
        // Jika gagal mengambil profil, gunakan data awal dan anggap profil tidak lengkap
        print('AuthCubit: Gagal mengambil profil lengkap, menggunakan data awal. Error: $failure');
        emit(AuthProfileIncomplete(initialUser));
      },
      (fullUser) {
        print('AuthCubit: Profil lengkap didapatkan. isProfileComplete: ${fullUser.isProfileComplete}');
        // Gunakan data user yang sudah lengkap untuk menentukan state
        if (fullUser.isProfileComplete) {
          emit(AuthAuthenticated(fullUser));
        } else {
          emit(AuthProfileIncomplete(fullUser));
        }
      },
    );
  }

  /// Metode untuk mengirim ulang kode OTP.
  Future<void> resendOtp({String? userId, String? pendingId}) async {
    print('AuthCubit: Meminta pengiriman ulang OTP...'); // DEBUG
    // Tidak mengubah state menjadi loading agar UI tidak terblokir total,
    // hanya menampilkan snackbar.

    final result = await authRepository.resendOtp(userId: userId, pendingId: pendingId);

    result.fold(
      (failure) {
        final message = _mapFailureToMessage(failure);
        print('AuthCubit: Gagal mengirim ulang OTP. Emitting AuthError: $message'); // DEBUG
        // Emit error agar bisa ditangkap listener di UI untuk menampilkan snackbar
        emit(AuthError(message));
      },
      (_) {
        print('AuthCubit: Permintaan kirim ulang OTP berhasil.'); // DEBUG
        // Emit state baru untuk menandakan sukses dan menampilkan pesan di UI
        emit(const AuthOtpResent('Kode OTP baru telah dikirimkan.'));
      },
    );
  }

  /// Metode untuk meminta reset password.
  Future<void> requestPasswordReset(String email) async {
    emit(AuthLoading());
    final result = await requestPasswordResetUseCase(RequestPasswordResetParams(email: email));

    result.fold(
      (failure) {
        emit(AuthError(_mapFailureToMessage(failure)));
      },
      (response) {
        // Setelah request reset, backend mengembalikan user_id.
        // Kita emit state AuthOtpRequired dengan user_id tersebut.
        final userId = response.user.id;
        emit(AuthOtpRequired(userId: userId));
      },
    );
  }

  /// Metode untuk menyelesaikan reset password.
  Future<void> completePasswordReset({
    required String userId,
    required String otpCode,
    required String newPassword,
    required String confirmPassword,
  }) async {
    emit(AuthLoading());
    final result = await completePasswordResetUseCase(CompletePasswordResetParams(
      userId: userId,
      otpCode: otpCode,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    ));

    result.fold(
      (failure) {
        emit(AuthError(_mapFailureToMessage(failure)));
      },
      (_) {
        emit(PasswordResetCompleted());
      },
    );
  }

  /// Metode untuk memperbarui username.
  Future<void> updateUsername(String newUsername) async {
    emit(AuthLoading());
    final result = await updateUsernameUseCase(UpdateUsernameParams(newUsername: newUsername));

    result.fold(
      (failure) {
        emit(AuthError(_mapFailureToMessage(failure)));
      },
      (updatedUser) {
        // Setelah berhasil, panggil _fetchProfileAndEmitState untuk memastikan
        // kita mendapatkan data user yang paling baru dari server.
        // Kita gunakan 'updatedUser' sebagai data awal jika fetch gagal.
        _fetchProfileAndEmitState(updatedUser);
      },
    );
  }

  /// Metode untuk memperbarui password.
  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    emit(AuthLoading());
    final result = await updatePasswordUseCase(UpdatePasswordParams(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    ));

    result.fold(
      (failure) {
        emit(AuthError(_mapFailureToMessage(failure)));
      },
      (_) {
        emit(const AuthSuccess('Password berhasil diperbarui!'));
      },
    );
  }

  /// Metode untuk memperbarui data user di state saat ini.
  /// Ini berguna setelah update profil, agar UI di seluruh aplikasi konsisten.
  void updateUser(UserEntity user) {
    print('AuthCubit: Memperbarui user di state. isProfileComplete: ${user.isProfileComplete}'); // DEBUG
    print('AuthCubit: User yang diperbarui: username="${user.username}", email="${user.email}"'); // DEBUG
    if (user.isProfileComplete) {
      emit(AuthAuthenticated(user));
    } else {
      // Jika setelah update profil masih belum lengkap (seharusnya tidak terjadi, tapi sebagai fallback)
      emit(AuthProfileIncomplete(user));
    }
  }

  /// Metode untuk logout atau membersihkan sesi.
  Future<void> logout() async {
    print('AuthCubit: Melakukan logout...'); // DEBUG
    await authRepository.logout(); // Hapus token dan user dari cache
    // Repository sudah seharusnya menghapus semua token, tapi kita pastikan di sini
    await sl<AuthLocalDataSource>().clearRefreshToken();
    await googleSignIn.signOut(); // Logout juga dari Google jika login via Google
    print('AuthCubit: Sesi dibersihkan. Emitting AuthUnauthenticated.'); // DEBUG
    emit(AuthUnauthenticated());
  }


  /// Helper untuk mengubah objek Failure menjadi pesan yang mudah dibaca.
  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    }
    return 'Terjadi kesalahan yang tidak terduga.';
  }
}