import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/features/auth/data/models/login_response_model.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/auth/domain/repositories/auth_repository.dart';

/// Use case untuk registrasi user.
class RegisterUseCase implements UseCase<LoginResponseModel, RegisterParams> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, LoginResponseModel>> call(RegisterParams params) async {
    return await repository.register(params: params);
  }
}

/// Parameter yang dibutuhkan oleh RegisterUseCase.
class RegisterParams extends Equatable {
  final String username;
  final String password;
  final String email;
  final String firstName;
  final String lastName;
  final String dob;
  final String gender;
  final String addressLine1;
  final String city;

  const RegisterParams({
    required this.username,
    required this.password,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.dob,
    required this.gender,
    required this.addressLine1,
    required this.city,
  });

  @override
  List<Object?> get props => [username, password, email, firstName, lastName, dob, gender, addressLine1, city];
}