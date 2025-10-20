import 'package:glupulse/features/auth/domain/entities/user.dart';

class AuthResponseEntity {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;
  final UserEntity user;

  AuthResponseEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
    required this.user,
  });

  // Anda bisa menambahkan getter atau method lain di sini jika diperlukan.
  // Contoh:
  String get authorizationHeader => '$tokenType $accessToken';
}