import 'dart:convert';
import 'package:glupulse/core/error/exceptions.dart';
import 'package:glupulse/features/auth/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel userToCache);
  Future<UserModel> getLastUser();
  Future<void> clearUser();
}

const CACHED_USER = 'CACHED_USER';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<UserModel> getLastUser() {
    final jsonString = sharedPreferences.getString(CACHED_USER);
    if (jsonString != null) {
      // Jika ada data user tersimpan, parse dan kembalikan sebagai UserModel
      return Future.value(UserModel.fromJson(json.decode(jsonString)));
    } else {
      // Jika tidak ada, lempar exception
      throw CacheException();
    }
  }

  @override
  Future<void> cacheUser(UserModel userToCache) {
    return sharedPreferences.setString(
      CACHED_USER,
      json.encode(userToCache.toJson()),
    );
  }

  @override
  Future<void> clearUser() {
    return sharedPreferences.remove(CACHED_USER);
  }
}
