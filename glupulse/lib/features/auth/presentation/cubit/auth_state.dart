import 'package:equatable/equatable.dart';
import 'package:glupulse/features/auth/domain/entities/user_entity.dart';

/// Abstract base class untuk semua state otentikasi.
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
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

/// State saat pengguna terotentikasi tetapi profilnya belum lengkap.
class AuthProfileIncomplete extends AuthState {
  final UserEntity user;
  const AuthProfileIncomplete(this.user);

  @override
  List<Object> get props => [user];
}

/// State ketika OTP diperlukan (setelah login atau register).
class AuthOtpRequired extends AuthState {
  final String? userId; // Nullable, untuk alur login
  final String? pendingId; // Nullable, untuk alur signup

  const AuthOtpRequired({this.userId, this.pendingId});

  @override
  List<Object?> get props => [userId, pendingId];
}

/// State saat OTP berhasil dikirim ulang.
class AuthOtpResent extends AuthState {
  final String message;

  const AuthOtpResent(this.message);

  @override
  List<Object> get props => [message];
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

/// State ketika permintaan reset password berhasil dan OTP diperlukan.
class PasswordResetOtpRequired extends AuthState {
  final String email; // Kita teruskan email untuk digunakan nanti
  const PasswordResetOtpRequired(this.email);

  @override
  List<Object?> get props => [email];
}

/// State ketika password berhasil direset.
class PasswordResetCompleted extends AuthState {
  @override
  List<Object?> get props => [];
}