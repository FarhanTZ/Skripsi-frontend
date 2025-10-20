class UserEntity {
  final String userId;
  final String username;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? dob;
  final String? gender;

  UserEntity({
    required this.userId,
    required this.username,
    required this.email,
    this.firstName,
    this.lastName,
    this.dob,
    this.gender,
  });

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();
}