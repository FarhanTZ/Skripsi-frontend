import 'package:flutter/foundation.dart';
import 'package:glupulse/features/auth/domain/entities/user_entity.dart';
import 'package:glupulse/features/profile/data/models/address_model.dart';

/// Model untuk data pengguna yang datang dari API (data layer).
/// Ini adalah implementasi dari UserEntity.
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.username,
    required super.email,
    super.firstName,
    super.lastName,
    this.dob,
    this.gender,
    this.accountType,
    this.isEmailVerified,
    this.avatarUrl,
    this.isGoogleLinked,
    this.addresses,
  }) : super(
          avatarUrl: avatarUrl,
          isGoogleLinked: isGoogleLinked,
        );

  @override
  final String? dob;
  @override
  final String? gender;
  final int? accountType;
  final bool? isEmailVerified;
  @override
  final String? avatarUrl;
  @override
  final bool? isGoogleLinked;
  @override
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
    debugPrint('UserModel.fromJson (Source: $source): Menerima JSON: $json'); // DEBUG
    // Gunakan fallback jika field tidak ada di JSON (kasus setelah register)

    // Data profil bisa ada di dalam key 'profile' atau langsung di root.
    final profileData = json['profile'] is Map<String, dynamic>
        ? json['profile'] as Map<String, dynamic>
        : json;

    final parsedUsername =
        profileData['username'] as String? ?? fallbackUsername ?? '';
    final parsedEmail = profileData['email'] as String? ?? fallbackEmail ?? '';
    debugPrint('UserModel.fromJson (Source: $source): Parsed Username: "$parsedUsername", Parsed Email: "$parsedEmail"'); // DEBUG

    // Parsing daftar alamat
    List<AddressModel> parsedAddresses = [];
    bool defaultAddressFound = false;
    if (json['addresses'] is List) {
      List<dynamic> addressList = json['addresses'] as List;
      for (var addressJson in addressList) {
        if (addressJson is Map<String, dynamic>) {
          // Buat salinan yang bisa diubah dari JSON alamat
          final mutableAddressJson = Map<String, dynamic>.from(addressJson);

          // Cek apakah alamat ini adalah default dari API
          bool isApiDefault = mutableAddressJson['is_default'] == true;

          // Jika alamat ini default DAN kita belum menemukan alamat default lain
          if (isApiDefault && !defaultAddressFound) {
            // Alamat ini adalah alamat default pertama yang sah.
            defaultAddressFound = true; // Tandai bahwa kita sudah menemukan alamat default
            // Tidak perlu mengubah JSON, langsung tambahkan.
            parsedAddresses.add(AddressModel.fromJson(mutableAddressJson));
          } else {
            // Jika ini bukan alamat default, ATAU jika kita sudah menemukan alamat default, paksa is_default menjadi false.
            mutableAddressJson['is_default'] = false;
            parsedAddresses.add(AddressModel.fromJson(mutableAddressJson));
          }
        }
      }
      debugPrint('UserModel.fromJson (Source: $source): Berhasil mem-parsing dan membersihkan ${parsedAddresses.length} alamat.'); // DEBUG
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
      // avatarUrl sudah ada di sini dan akan diteruskan ke super
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
      'addresses': addresses?.map((address) => address.toJson()).toList(),
    };
  }
}