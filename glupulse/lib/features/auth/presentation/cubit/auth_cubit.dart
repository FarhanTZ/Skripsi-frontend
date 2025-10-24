import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/auth/domain/entities/user_entity.dart';
import 'package:glupulse/features/auth/domain/usecases/login_with_google_usecase.dart';
import 'package:glupulse/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:glupulse/features/auth/domain/usecases/register_usecase.dart';
import 'package:glupulse/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:glupulse/features/auth/domain/usecases/login_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:google_sign_in/google_sign_in.dart';

// --- AuthState ---
/// Abstract base class untuk semua state otentikasi.
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

/// State awal sebelum ada interaksi.
class AuthInitial extends AuthState {}

/// State saat proses otentikasi sedang berlangsung (misal: login).
class AuthLoading extends AuthState {}

/// State saat pengguna berhasil terotentikasi.
class AuthAuthenticated extends AuthState {
  final UserEntity user;
  const AuthAuthenticated(this.user);

  @override
  List<Object> get props => [user];
}

/// State saat pengguna perlu verifikasi OTP.
class AuthOtpRequired extends AuthState {
  final UserEntity user;
  const AuthOtpRequired(this.user);

  @override
  List<Object> get props => [user];
}

/// State saat pengguna tidak terotentikasi (misal: setelah logout, atau belum login).
class AuthUnauthenticated extends AuthState {}

/// State saat terjadi error selama proses otentikasi.
class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}

// --- AuthCubit ---
/// Cubit yang mengelola state otentikasi.
class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final RegisterUseCase registerUseCase;
  final LoginWithGoogleUseCase loginWithGoogleUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final GoogleSignIn googleSignIn;

  AuthCubit({
    required this.loginUseCase,
    required this.verifyOtpUseCase,
    required this.registerUseCase,
    required this.loginWithGoogleUseCase,
    required this.getCurrentUserUseCase,
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
        print('AuthCubit: Tidak ada sesi ditemukan. Emitting AuthUnauthenticated.'); // DEBUG
        emit(AuthUnauthenticated());
      },
      (user) {
        print(
            'AuthCubit: Sesi ditemukan untuk user: ${user.username}. Emitting AuthAuthenticated.'); // DEBUG
        emit(AuthAuthenticated(user)); // Emit state setelah timer selesai
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
        emit(AuthOtpRequired(user));
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
        (failure) => emit(AuthError(_mapFailureToMessage(failure))),
        (user) => emit(AuthAuthenticated(user)), // Langsung authenticated
      );
    } catch (e) {
      print('AuthCubit: Terjadi error saat login Google: $e'); // DEBUG
      emit(AuthError(_mapFailureToMessage(ServerFailure('Gagal login dengan Google. Silakan coba lagi.'))));
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
      (user) {
        // Setelah registrasi berhasil, arahkan ke halaman OTP.
        emit(AuthOtpRequired(user));
      },
    );
  }

  /// Metode untuk verifikasi OTP.
  Future<void> verifyOtp(String userId, String otpCode) async {
    print('AuthCubit: Memulai verifikasi OTP untuk user ID: $userId'); // DEBUG
    emit(AuthLoading());
    print('AuthCubit: Emitting AuthLoading...'); // DEBUG

    final result = await verifyOtpUseCase(VerifyOtpParams(userId: userId, otpCode: otpCode));

    result.fold(
      (failure) {
        final message = _mapFailureToMessage(failure);
        print('AuthCubit: Verifikasi OTP gagal. Emitting AuthError: $message'); // DEBUG
        emit(AuthError(message)); // Jika gagal, emit AuthError
      },
      (user) {
        print('AuthCubit: Verifikasi OTP berhasil. Emitting AuthAuthenticated untuk user: ${user.username}'); // DEBUG
        emit(AuthAuthenticated(user));
      },
    );
  }

  /// Helper untuk mengubah objek Failure menjadi pesan yang mudah dibaca.
  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    }
    return 'Terjadi kesalahan yang tidak terduga.';
  }
}