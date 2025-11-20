import 'package:glupulse/features/auth/domain/entities/user_entity.dart';
import 'package:glupulse/features/profile/data/models/address_model.dart';

/// Model untuk data pengguna yang datang dari API (data layer).
/// Ini adalah implementasi dari UserEntity.
class UserModel extends UserEntity {
  const UserModel({
    required String id,
    required String username,
    required String email,
    String? firstName,
    String? lastName,
    this.dob,
    this.gender,
    this.accountType,
    this.isEmailVerified,
    this.avatarUrl,
    this.isGoogleLinked,
    this.addresses,
  }) : super(
          id: id,
          username: username,
          email: email,
          firstName: firstName,
          lastName: lastName,
        );

  final String? dob;
  final String? gender;
  final int? accountType;
  final bool? isEmailVerified;
  final String? avatarUrl;
  final bool? isGoogleLinked;
  final List<AddressModel>? addresses;

  @override
  List<Object?> get props => [
        id,
        username,
        email,
        firstName,
        lastName,
        dob,
        gender,
        accountType,
        isEmailVerified,
        avatarUrl,
        isGoogleLinked,
        addresses
      ];

  /// Factory constructor untuk membuat instance UserModel dari JSON.
  factory UserModel.fromJson(
    Map<String, dynamic> json, {
    String source = 'unknown',
    String? fallbackUsername,
    String? fallbackEmail,
  }) {
    print('UserModel.fromJson (Source: $source): Menerima JSON: $json'); // DEBUG
    // Gunakan fallback jika field tidak ada di JSON (kasus setelah register)

    // Data profil bisa ada di dalam key 'profile' atau langsung di root.
    final profileData = json['profile'] is Map<String, dynamic>
        ? json['profile'] as Map<String, dynamic>
        : json;

    final parsedUsername =
        profileData['username'] as String? ?? fallbackUsername ?? '';
    final parsedEmail = profileData['email'] as String? ?? fallbackEmail ?? '';
    print('UserModel.fromJson (Source: $source): Parsed Username: "$parsedUsername", Parsed Email: "$parsedEmail"'); // DEBUG

    // Parsing daftar alamat
    List<AddressModel> parsedAddresses = [];
    if (json['addresses'] is List) {
      parsedAddresses = (json['addresses'] as List)
          .map((addressJson) =>
              AddressModel.fromJson(addressJson as Map<String, dynamic>))
          .toList();
      print(
          'UserModel.fromJson (Source: $source): Berhasil mem-parsing ${parsedAddresses.length} alamat.'); // DEBUG
    }

    return UserModel(
      // Backend mengembalikan 'user_id' saat login/register, dan 'id' saat get profile.
      id: (profileData['user_id'] ?? profileData['id'] ?? '').toString(),
      username: parsedUsername,
      email: parsedEmail,
      firstName: profileData['first_name'] as String?,
      lastName: profileData['last_name'] as String?,
      dob: profileData['dob'] as String?,
      gender: profileData['gender'] as String?,
      accountType: profileData['account_type'] as int?,
      isEmailVerified: profileData['is_email_verified'] as bool?,
      avatarUrl: profileData['avatar_url'] as String?,
      isGoogleLinked: profileData['is_google_linked'] as bool?,
      addresses: parsedAddresses,
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
      'account_type': accountType,
      'is_email_verified': isEmailVerified,
      'avatar_url': avatarUrl,
      'is_google_linked': isGoogleLinked,
      // toJson untuk addresses bisa ditambahkan jika diperlukan
    };
  }
}