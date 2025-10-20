import 'package:glupulse/features/auth/domain/entities/auth_response.dart';
import 'package:glupulse/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);
  
  Future<AuthResponseEntity> execute(String username, String password) {
    return repository.login(username, password);
  }
}