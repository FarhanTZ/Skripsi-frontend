import 'package:glupulse/features/auth/data/models/user_model.dart';

/// Model untuk merepresentasikan response lengkap dari API login.
/// Ini adalah objek di layer data.
class LoginResponseModel {
  final String token;
  final UserModel user;

  const LoginResponseModel({required this.token, required this.user});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    // Struktur respons login: { "user_id": "...", "email": "..." }
    // Struktur respons verify-otp: { "access_token": "...", "data": { ... } }
    return LoginResponseModel(
      // Token hanya ada setelah verifikasi OTP, jadi bisa kosong saat login.
      token: json['access_token'] as String? ?? '',
      // Saat login, data user ada di root. Saat verify-otp, ada di dalam 'data'.
      // Kita cek keberadaan 'data', jika tidak ada, kita gunakan json root.
      user: UserModel.fromJson(
          json['data'] as Map<String, dynamic>? ?? json),
    );
  }
}