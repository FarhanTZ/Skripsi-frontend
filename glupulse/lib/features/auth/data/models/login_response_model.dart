import 'package:glupulse/features/auth/data/models/user_model.dart';

/// Model untuk merepresentasikan response lengkap dari API login.
/// Juga digunakan untuk parsing respons signup yang mungkin hanya berisi pending_id.
/// Ini adalah objek di layer data.
class LoginResponseModel {
  final String token;
  final String refreshToken;
  final UserModel user;
  final String? pendingId; // Tambahkan pendingId

  const LoginResponseModel({required this.token, required this.refreshToken, required this.user, this.pendingId});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    print('LoginResponseModel.fromJson: Menerima JSON: $json'); // DEBUG

    // Cek jika ini adalah respons dari signup yang hanya berisi pending_id
    if (json.containsKey('pending_id') && !json.containsKey('data')) {
      return LoginResponseModel(
        token: '',
        refreshToken: '',
        pendingId: json['pending_id'] as String?,
        // Buat UserModel kosong karena data user belum ada
        user: UserModel.fromJson({}, source: 'signup_response'),
      );
    }

    return LoginResponseModel(
      token: json['access_token'] as String? ?? '', // Access token
      refreshToken: json['refresh_token'] as String? ?? '', // Refresh token
      pendingId: json['pending_id'] as String?, // Ambil pending_id jika ada
      user: UserModel.fromJson(json['data'] as Map<String, dynamic>? ?? json,
          source: 'login_response'),
    );
  }
}