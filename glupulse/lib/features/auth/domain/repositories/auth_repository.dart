import 'package:glupulse/features/auth/domain/entities/auth_response.dart';

abstract class AuthRepository {
  Future<AuthResponseEntity> login(String username, String password);

  Future<void> register({
    required String username,
    required String email,
    required String password,
  });
}