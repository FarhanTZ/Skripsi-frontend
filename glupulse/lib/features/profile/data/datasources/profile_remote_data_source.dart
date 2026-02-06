import 'package:flutter/foundation.dart';
import 'package:glupulse/core/api/api_client.dart';
import 'package:glupulse/core/error/exceptions.dart';
import 'package:glupulse/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:glupulse/features/auth/data/models/user_model.dart';
import 'package:glupulse/features/profile/domain/usecases/update_profile_usecase.dart';

abstract class ProfileRemoteDataSource {
  Future<UserModel> getUserProfile();
  Future<UserModel> updateUserProfile(UpdateProfileParams params);
  Future<UserModel> updateUsername(String newUsername);
  Future<void> updatePassword(String currentPassword, String newPassword, String confirmPassword);
  Future<void> deleteAccount(String password);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiClient apiClient;
  final AuthLocalDataSource localDataSource;

  ProfileRemoteDataSourceImpl({
    required this.apiClient,
    required this.localDataSource,
  });

  @override
  Future<UserModel> getUserProfile() async {
    try {
      final token = await localDataSource.getLastToken();
      final response = await apiClient.get('/profile', token: token);
      debugPrint(
          'ProfileRemoteDataSourceImpl: Respon API /profile: $response'); // DEBUG - Tetap ada

      if (response['profile'] == null || response['profile'] is! Map<String, dynamic>) {
        throw ServerException('Struktur data profil dari server tidak valid.');
      }
      // Mengirim seluruh response ke fromJson agar bisa memproses 'profile' dan 'addresses'
      return UserModel.fromJson(response, source: 'profile_get');
    } on ServerException {
      rethrow;
    } on CacheException {
      throw ServerException('Sesi tidak ditemukan. Silakan login kembali.');
    } catch (e) {
      throw ServerException('Gagal mengambil data profil.');
    }
  }

  @override
  Future<UserModel> updateUserProfile(UpdateProfileParams params) async {
    try {
      final token = await localDataSource.getLastToken();
      final response = await apiClient.put(
        '/profile',
        body: params.toJson(), // Menggunakan method toJson dari params
        token: token,
      );
      debugPrint('ProfileRemoteDataSourceImpl: Respon API PUT /profile: $response'); // DEBUG
      // PERBAIKAN: Asumsikan backend mengembalikan data user yang sudah diupdate di dalam key 'user',
      // sama seperti endpoint GET /profile.
      if (response.containsKey('user') && response['user'] is Map<String, dynamic>) {
        return UserModel.fromJson(response['user']);
      } else {
        // Jika struktur respons tidak sesuai, lempar exception
        throw ServerException('Struktur respons tidak sesuai saat memperbarui profil.');
      }
    } on ServerException {
      rethrow;
    } on CacheException {
      throw ServerException('Sesi tidak ditemukan. Silakan login kembali.');
    } catch (e) {
      throw ServerException('Gagal memperbarui profil.');
    }
  }

  @override
  Future<UserModel> updateUsername(String newUsername) async {
    try {
      final token = await localDataSource.getLastToken();
      final response = await apiClient.put(
        '/profile/username', // Endpoint khusus untuk username
        body: {
          'new_username': newUsername,
        },
        token: token,
      );
      // PERBAIKAN: Asumsikan jika request sukses (2xx), body respons adalah data user yang baru,
      // baik itu di dalam key 'user' atau langsung di root.
      if (response.containsKey('user') && response['user'] is Map<String, dynamic>) {
        return UserModel.fromJson(response['user'], source: 'update_username');
      } else {
        // Jika tidak ada key 'user', coba parsing langsung dari root response.
        return UserModel.fromJson(response, source: 'update_username_root');
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Gagal memperbarui username.');
    }
  }

  @override
  Future<void> updatePassword(String currentPassword, String newPassword, String confirmPassword) async {
    try {
      final token = await localDataSource.getLastToken();
      await apiClient.put(
        '/profile/password',
        body: {
          'current_password': currentPassword,
          'new_password': newPassword,
          'confirm_password': confirmPassword,
        },
        token: token,
      );
      // Tidak ada return value, sukses ditandai dengan status 2xx
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Gagal memperbarui password.');
    }
  }

  @override
  Future<void> deleteAccount(String password) async {
    try {
      final token = await localDataSource.getLastToken();
      await apiClient.delete(
        '/profile', // Endpoint diubah menjadi /profile dengan method DELETE
        body: {
          'password': password,
        },
        token: token,
      );
      // Jika berhasil, API client akan menangani status 2xx dan tidak akan melempar error.
    } on ServerException {
      rethrow; // Lempar kembali jika error sudah ditangani oleh ApiClient
    } on CacheException {
      throw ServerException('Sesi tidak ditemukan. Silakan login kembali.');
    } catch (e) {
      throw ServerException('Gagal menghapus akun. Periksa koneksi Anda.');
    }
  }
}