import 'package:equatable/equatable.dart';

/// Base class untuk semua jenis kegagalan (Failure) dalam aplikasi.
/// Menggunakan Equatable agar mudah dibandingkan.
abstract class Failure extends Equatable {
  final String message;

  const Failure([this.message = 'An unexpected error occurred.']);

  @override
  List<Object> get props => [message];
}


/// Kegagalan yang terjadi karena masalah pada cache lokal (misal: data tidak ditemukan).
class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache error.']) : super(message);
}

/// Kegagalan yang terjadi karena masalah di sisi server (misal: API error).
class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);

  @override
  List<Object> get props => [message];
}

class ConnectionFailure extends Failure {
  const ConnectionFailure([String message = 'No internet connection.']) : super(message);
}
