import 'package:equatable/equatable.dart';

/// Base class untuk semua jenis kegagalan (Failure) dalam aplikasi.
/// Menggunakan Equatable agar mudah dibandingkan.
abstract class Failure extends Equatable {
  const Failure([List properties = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}


/// Kegagalan yang terjadi karena masalah pada cache lokal (misal: data tidak ditemukan).
class CacheFailure extends Failure {}

/// Kegagalan yang terjadi karena masalah di sisi server (misal: API error).
class ServerFailure extends Failure {
  final String message;

  const ServerFailure(this.message);

  @override
  List<Object> get props => [message];
}
