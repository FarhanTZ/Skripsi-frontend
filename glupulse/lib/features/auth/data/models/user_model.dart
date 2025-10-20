import 'package:glupulse/features/auth/domain/entities/user_entity.dart';

/// UserModel adalah implementasi dari UserEntity di layer data.
/// Ia bertanggung jawab untuk konversi data dari/ke format eksternal (JSON).
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.username,
    required super.email,
    required super.name,
  });

  /// Factory constructor untuk membuat instance UserModel dari Map (JSON).
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      // Backend mengirim 'user_id' saat login, dan mungkin 'id' di konteks lain.
      id: (json['user_id'] ?? json['id']) as String? ?? '',
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      // Menggabungkan first_name dan last_name untuk field 'name'
      name: [
        json['first_name'] as String? ?? '',
        json['last_name'] as String? ?? ''
      ].where((e) => e.isNotEmpty).join(' ').trim(),
    );
  }

  /// Method untuk mengubah instance UserModel menjadi Map (JSON).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'name': name,
    };
  }
}