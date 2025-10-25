import 'package:equatable/equatable.dart';

/// Entity untuk merepresentasikan data pengguna di dalam aplikasi (domain layer).
class UserEntity extends Equatable {
  final String id;
  final String username;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? dob;
  final String? gender;
  final String? addressLine1;
  final String? city;

  const UserEntity({
    required this.id,
    required this.username,
    required this.email,
    this.firstName,
    this.lastName,
    this.dob,
    this.gender,
    this.addressLine1,
    this.city,
  });

  /// Getter untuk memeriksa apakah profil pengguna sudah lengkap.
  /// Anda bisa menyesuaikan logika ini sesuai kebutuhan field wajib Anda.
  bool get isProfileComplete {
    return firstName != null && firstName!.isNotEmpty &&
           lastName != null && lastName!.isNotEmpty && // Tetap wajib
           dob != null && dob!.isNotEmpty && // Tetap wajib
           gender != null && gender!.isNotEmpty; // Tetap wajib
  }

  @override
  List<Object?> get props => [id, username, email, firstName, lastName, dob, gender, addressLine1, city];
}