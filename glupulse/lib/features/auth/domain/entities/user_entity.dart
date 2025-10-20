import 'package:equatable/equatable.dart';

/// UserEntity merepresentasikan objek User dalam domain bisnis aplikasi.
/// Ia tidak bergantung pada sumber data (API, database, dll).
/// Menggunakan Equatable untuk mempermudah perbandingan objek.
class UserEntity extends Equatable {
  final String id;
  final String username;
  final String email;
  final String name;

  const UserEntity({
    required this.id,
    required this.username,
    required this.email,
    required this.name,
  });

  @override
  List<Object?> get props => [id, username, email, name];
}