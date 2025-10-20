/// Exception yang dilempar dari RemoteDataSource ketika terjadi error dari server.
class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}