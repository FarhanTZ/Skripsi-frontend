import 'package:equatable/equatable.dart';
import 'package:glupulse/features/auth/domain/entities/user_entity.dart';

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

/// State saat pengguna terotentikasi tetapi profilnya belum lengkap.
class AuthProfileIncomplete extends AuthState {
  final UserEntity user;
  const AuthProfileIncomplete(this.user);

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