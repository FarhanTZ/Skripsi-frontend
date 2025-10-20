import 'package:glupulse/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<void> execute(RegisterParams params) {
    return repository.register(
      username: params.username,
      email: params.email,
      password: params.password,
      firstName: params.firstName,
      lastName: params.lastName,
      dob: params.dob,
      gender: params.gender,
    );
  }
}

class RegisterParams {
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String password;
  final String dob;
  final String gender;

  RegisterParams({
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.password,
    required this.dob,
    required this.gender,
  });
}