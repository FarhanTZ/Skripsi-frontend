import 'package:glupulse/features/auth/data/models/user_model.dart';
import 'package:glupulse/features/auth/domain/entities/auth_response.dart';

class AuthResponseModel extends AuthResponseEntity {
  AuthResponseModel({
    required super.accessToken,
    required super.refreshToken,
    required super.tokenType,
    required super.expiresIn,
    required UserModel super.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      tokenType: json['token_type'],
      expiresIn: json['expires_in'],
      user: UserModel.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'token_type': tokenType,
      'expires_in': expiresIn,
      // Pastikan UserModel punya method toJson() juga
      'user': (user as UserModel).toJson(),
    };
  }
}