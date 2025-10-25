import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/auth/domain/entities/user_entity.dart';
import 'package:glupulse/features/profile/domain/repositories/profile_repository.dart';

/// Use case untuk memperbarui data profil pengguna.
class UpdateProfileUseCase implements UseCase<UserEntity, UpdateProfileParams> {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(UpdateProfileParams params) async {
    return await repository.updateUserProfile(params);
  }
}

/// Parameter yang dibutuhkan oleh UpdateProfileUseCase.
/// Semua field dibuat nullable agar pengguna bisa memperbarui hanya sebagian data.
class UpdateProfileParams extends Equatable {
  final String? username;
  final String? firstName;
  final String? lastName;
  final String? dob;
  final String? gender;
  final String? addressLine1;
  final String? city;
  // Tambahkan password untuk verifikasi perubahan username
  final String? password;
  // Tambahkan field lain jika ada yang bisa diupdate, misal: password
  // final String? password;

  const UpdateProfileParams({
    this.username,
    this.firstName,
    this.lastName,
    this.dob,
    this.gender,
    this.addressLine1,
    this.city,
    this.password,
    // this.password,
  });

  /// Mengubah parameter menjadi format JSON untuk dikirim ke API.
  /// Hanya field yang tidak null yang akan dimasukkan ke dalam map.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (username != null) data['username'] = username;
    if (firstName != null) data['first_name'] = firstName;
    if (lastName != null) data['last_name'] = lastName;
    if (dob != null) data['dob'] = dob;
    if (gender != null) data['gender'] = gender;
    if (addressLine1 != null) data['address_line1'] = addressLine1;
    if (city != null) data['city'] = city;
    // if (password != null && password!.isNotEmpty) data['password'] = password;
    return data;
  }

  @override
  List<Object?> get props => [
        username,
        firstName,
        lastName,
        dob,
        gender,
        addressLine1,
        city,
        password,
      ];
}