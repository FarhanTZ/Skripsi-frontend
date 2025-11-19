import 'package:glupulse/features/auth/domain/entities/user_entity.dart';

/// Model untuk data pengguna yang datang dari API (data layer).
/// Ini adalah implementasi dari UserEntity.
class UserModel extends UserEntity {
  const UserModel({
    required String id,
    required String username,
    required String email,
    String? firstName,
    String? lastName,
    String? dob,
    String? gender,
    String? addressLine1,
    String? city,
  }) : super(
          id: id,
          username: username,
          email: email,
          firstName: firstName,
          lastName: lastName,
          dob: dob,
          gender: gender,
          addressLine1: addressLine1,
          city: city,
        );

  /// Factory constructor untuk membuat instance UserModel dari JSON.
  factory UserModel.fromJson(
    Map<String, dynamic> json, {
    String source = 'unknown',
    String? fallbackUsername,
    String? fallbackEmail,
  }) {
    print('UserModel.fromJson (Source: $source): Menerima JSON: $json'); // DEBUG
    // Gunakan fallback jika field tidak ada di JSON (kasus setelah register)
    final parsedUsername = json['username'] as String? ?? fallbackUsername ?? '';
    final parsedEmail = json['email'] as String? ?? fallbackEmail ?? '';
    print('UserModel.fromJson (Source: $source): Parsed Username: "$parsedUsername", Parsed Email: "$parsedEmail"'); // DEBUG
    return UserModel(
      // Backend mengembalikan 'user_id' saat login/register, dan 'id' saat get profile.
      id: (json['user_id'] ?? json['id'] ?? '').toString(),
      username: parsedUsername,
      email: parsedEmail,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      dob: json['dob'] as String?,
      gender: json['gender'] as String?,
      addressLine1: json['address_line1'] as String?,
      city: json['city'] as String?,
    );
  }

  /// Method untuk mengubah instance UserModel menjadi JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'dob': dob,
      'gender': gender,
      'address_line1': addressLine1,
      'city': city,
    };
  }
}