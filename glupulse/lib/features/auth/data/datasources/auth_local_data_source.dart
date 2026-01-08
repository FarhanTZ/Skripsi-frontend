import 'dart:convert';
import 'package:glupulse/core/error/exceptions.dart';
import 'package:glupulse/features/auth/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel userToCache);
  Future<void> cacheToken(String token);
  Future<void> cacheRefreshToken(String refreshToken);
  Future<UserModel> getLastUser();
  Future<String> getLastToken();
  Future<String> getLastRefreshToken();
  Future<void> clearUser();
  Future<void> clearToken();
  Future<void> clearRefreshToken();
}

const CACHED_USER = 'CACHED_USER';
const CACHED_TOKEN = 'CACHED_TOKEN';
const CACHED_REFRESH_TOKEN = 'CACHED_REFRESH_TOKEN';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<UserModel> getLastUser() {
    final jsonString = sharedPreferences.getString(CACHED_USER);
    print('AuthLocalDataSourceImpl: Mengambil CACHED_USER. JSON string: $jsonString'); // DEBUG
    if (jsonString != null) {
      // Jika ada data user tersimpan, parse dan kembalikan sebagai UserModel
      return Future.value(UserModel.fromJson(json.decode(jsonString), source: 'local_cache_get'));
    } else {
      print('AuthLocalDataSourceImpl: CACHED_USER tidak ditemukan.'); // DEBUG
      // Jika tidak ada, lempar exception
      throw CacheException();
    }
  }

  @override
  Future<void> cacheUser(UserModel userToCache) {
    print('AuthLocalDataSourceImpl: Mencache user: username="${userToCache.username}", email="${userToCache.email}"'); // DEBUG
    return sharedPreferences.setString(
      CACHED_USER,
      json.encode(userToCache.toJson()),
    );
  }

  @override
  Future<void> clearUser() {
    return sharedPreferences.remove(CACHED_USER); // Hanya hapus user
  }

  @override
  Future<void> cacheToken(String token) {
    return sharedPreferences.setString(CACHED_TOKEN, token);
  }

  @override
  Future<String> getLastToken() {
    final token = sharedPreferences.getString(CACHED_TOKEN);
    if (token != null) {
      return Future.value(token);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> clearToken() {
    return sharedPreferences.remove(CACHED_TOKEN);
  }

  @override
  Future<void> cacheRefreshToken(String refreshToken) {
    return sharedPreferences.setString(CACHED_REFRESH_TOKEN, refreshToken);
  }

  @override
  Future<String> getLastRefreshToken() {
    final token = sharedPreferences.getString(CACHED_REFRESH_TOKEN);
    if (token != null) {
      return Future.value(token);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> clearRefreshToken() {
    return sharedPreferences.remove(CACHED_REFRESH_TOKEN);
  }
}
