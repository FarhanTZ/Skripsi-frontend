/// Exception yang dilempar dari RemoteDataSource ketika terjadi error dari server.
class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

/// Exception yang dilempar dari LocalDataSource ketika terjadi error pada cache.
class CacheException implements Exception {}