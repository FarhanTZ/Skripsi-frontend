import 'package:glupulse/core/api/api_client.dart';
import 'package:glupulse/core/error/exceptions.dart';
import 'package:glupulse/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:glupulse/features/auth/data/models/user_model.dart';
import 'package:glupulse/features/profile/domain/usecases/update_profile_usecase.dart';

abstract class ProfileRemoteDataSource {
  Future<UserModel> getUserProfile();
  Future<UserModel> updateUserProfile(UpdateProfileParams params);
  Future<UserModel> updateUsername(String newUsername, String password);
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
      print('ProfileRemoteDataSourceImpl: Respon API /profile: $response'); // DEBUG - Tetap ada
      // API /profile mengembalikan data user di dalam key 'user'
      return UserModel.fromJson(response['user'], source: 'profile_get');
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
      print('ProfileRemoteDataSourceImpl: Respon API PUT /profile: $response'); // DEBUG
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
  Future<UserModel> updateUsername(String newUsername, String password) async {
    try {
      final token = await localDataSource.getLastToken();
      final response = await apiClient.put(
        '/profile/username', // Endpoint khusus untuk username
        body: {
          'new_username': newUsername,
          'password': password,
        },
        token: token,
      );
      // Asumsikan responsenya sama, mengembalikan data user yang diupdate di key 'data'
      return UserModel.fromJson(response['data']);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Gagal memperbarui username.');
    }
  }
}