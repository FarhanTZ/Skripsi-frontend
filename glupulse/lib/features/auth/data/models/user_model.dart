import 'package:glupulse/features/auth/domain/entities/user.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.userId,
    required super.username,
    required super.email,
    super.firstName,
    super.lastName,
    super.dob,
    super.gender,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'] as String? ?? '',
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      firstName: json['first_name'],
      lastName: json['last_name'],
      dob: json['dob'],
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'dob': dob,
      'gender': gender,
    };
  }
}