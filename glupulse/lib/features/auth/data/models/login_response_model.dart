import 'package:glupulse/features/auth/data/models/user_model.dart';

/// Model untuk merepresentasikan response lengkap dari API login.
/// Ini adalah objek di layer data.
class LoginResponseModel {
  final String token;
  final String refreshToken;
  final UserModel user;

  const LoginResponseModel({required this.token, required this.refreshToken, required this.user});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    print('LoginResponseModel.fromJson: Menerima JSON: $json'); // DEBUG
    // Struktur respons login: { "user_id": "...", "email": "..." }
    // Struktur respons verify-otp: { "access_token": "...", "data": { ... } }
    return LoginResponseModel(
      token: json['access_token'] as String? ?? '', // Access token
      refreshToken: json['refresh_token'] as String? ?? '', // Refresh token
      // Saat login, data user ada di root. Saat verify-otp, ada di dalam 'data'.
      // Kita cek keberadaan 'data', jika tidak ada, kita gunakan json root.
      user: UserModel.fromJson(json['data'] as Map<String, dynamic>? ?? json,
          source: 'login_response'),
    );
  }
}