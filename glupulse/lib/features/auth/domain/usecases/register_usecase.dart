import 'package:glupulse/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<void> execute(RegisterParams params) {
    return repository.register(
      username: params.username,
      email: params.email,
      password: params.password,
    );
  }
}

class RegisterParams {
  final String username;
  final String email;
  final String password;

  RegisterParams(
      {required this.username, required this.email, required this.password});
}