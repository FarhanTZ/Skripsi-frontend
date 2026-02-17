import 'package:flutter/foundation.dart';
import 'package:glupulse/core/api/api_client.dart';
import 'package:glupulse/core/error/exceptions.dart';
import 'package:glupulse/features/auth/data/models/login_response_model.dart';
import 'package:glupulse/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:glupulse/features/auth/domain/usecases/register_usecase.dart';

/// Abstract class untuk mendefinisikan kontrak dari Auth Remote Data Source.
/// Ini berguna untuk dependency injection dan testing.
abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> login(String username, String password);
  Future<LoginResponseModel> loginWithGoogle(String idToken);
  Future<LoginResponseModel> register({required RegisterParams params});
  Future<LoginResponseModel> verifyOtp(String userId, String otpCode);
  Future<LoginResponseModel> verifySignupOtp(String pendingId, String otpCode); // Metode baru
  Future<LoginResponseModel> linkGoogleAccount(String idToken);
  Future<LoginResponseModel> unlinkGoogleAccount(String password);
  Future<void> resendOtp({String? userId, String? pendingId});
  Future<LoginResponseModel> requestPasswordReset(String email);
  Future<void> completePasswordReset({
    required String userId,
    required String otpCode,
    required String newPassword,
    required String confirmPassword,
  });
}

/// Implementasi konkret dari AuthRemoteDataSource.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;
  final AuthLocalDataSource localDataSource;

  AuthRemoteDataSourceImpl({
    required this.apiClient,
    required this.localDataSource,
  });

  @override
  Future<LoginResponseModel> login(String username, String password) async {
    try {
      final response = await apiClient.post(
        '/login', // Endpoint spesifik untuk login
        body: {
          'Username': username,
          'Password': password,
        },
      );
      debugPrint('AuthRemoteDataSourceImpl: Respon API /login: $response'); // DEBUG
      // Parsing response JSON menjadi LoginResponseModel
      final loginResponse = LoginResponseModel.fromJson(response);
      await _cacheTokens(loginResponse);
      return loginResponse;
    } on ServerException {
      rethrow; // Jika sudah ServerException (dari ApiClient), lempar kembali.
    } catch (e) {
      // Melempar ServerException agar bisa ditangkap oleh Repository
      throw ServerException('Gagal terhubung ke server. Periksa koneksi internet Anda.');
    }
  }

  @override
  Future<LoginResponseModel> loginWithGoogle(String idToken) async {
    try {
      final response = await apiClient.post(
        '/auth/mobile/google', // Endpoint spesifik untuk Google login
        body: {
          'id_token': idToken,
        },
      );
      debugPrint('AuthRemoteDataSourceImpl: Respon API /auth/mobile/google: $response'); // DEBUG
      // Parsing response JSON menjadi LoginResponseModel
      final loginResponse = LoginResponseModel.fromJson(response);
      await _cacheTokens(loginResponse);
      return loginResponse;
    } on ServerException {
      rethrow; // Jika sudah ServerException (dari ApiClient), lempar kembali.
    } catch (e) {
      // Melempar ServerException agar bisa ditangkap oleh Repository
      throw ServerException('Gagal terhubung ke server. Periksa koneksi internet Anda.');
    }
  }

  @override
  Future<LoginResponseModel> register({required RegisterParams params}) async {
    try {
      final response = await apiClient.post(
        '/signup', // Endpoint spesifik untuk registrasi
        body: {
          "username": params.username,
          "password": params.password,
          "email": params.email,
          "first_name": params.firstName,
          "last_name": params.lastName,
          "dob": params.dob,
          "gender": params.gender,
          "address_line1": params.addressLine1,
          "address_city": params.city,
        },
      );
      debugPrint('AuthRemoteDataSourceImpl: Respon API /signup: $response'); // DEBUG
      // Kita asumsikan responsenya sama dengan login (mengembalikan data user)
      final loginResponse = LoginResponseModel.fromJson(response);
      await _cacheTokens(loginResponse);
      return loginResponse;
    } on ServerException catch (e) {
      debugPrint('AuthRemoteDataSourceImpl: ServerException ditangkap di register: ${e.message}'); // DEBUG
      rethrow;
    } catch (e) {
      debugPrint('AuthRemoteDataSourceImpl: Exception umum ditangkap di register: $e'); // DEBUG
      throw ServerException('Gagal melakukan registrasi. Terjadi kesalahan tidak terduga.');
    }
  }

  @override
  Future<LoginResponseModel> verifyOtp(String userId, String otpCode) async {
    try {
      final response = await apiClient.post(
        '/verify-otp', // Endpoint spesifik untuk verifikasi OTP
        body: {
          'user_id': userId,   // Sesuai dengan spesifikasi Anda
          'otp_code': otpCode, // Sesuai dengan spesifikasi Anda
        },
      );
      debugPrint('AuthRemoteDataSourceImpl: Respon API /verify-otp: $response'); // DEBUG
      // Parsing response JSON menjadi LoginResponseModel
      final loginResponse = LoginResponseModel.fromJson(response);
      await _cacheTokens(loginResponse);
      return loginResponse;
    } on ServerException {
      rethrow; // Jika sudah ServerException (dari ApiClient), lempar kembali.
    } catch (e) {
      // Tangani error koneksi atau error tak terduga lainnya.
      throw ServerException('Gagal terhubung ke server. Periksa koneksi internet Anda.');
    }
  }

  @override
  Future<LoginResponseModel> verifySignupOtp(String pendingId, String otpCode) async {
    try {
      // Endpoint ini mungkin memerlukan token yang didapat dari langkah sebelumnya
      final response = await apiClient.post(
        '/verify-otp', // Sesuai konfirmasi: endpoint sama dengan verifikasi login
        body: {
          'pending_id': pendingId,
          'otp_code': otpCode,
        },
        // Tidak ada token yang dikirim di sini, yang mungkin menyebabkan 401.
        // Namun, jika endpoint ini memang publik setelah signup, maka masalahnya ada di backend.
        // Jika endpoint ini memerlukan otorisasi, Anda perlu menyediakan token.
        // Untuk saat ini, kita biarkan tanpa token sesuai logika sebelumnya,
        // karena respons signup tidak memberikan token.
      );
      debugPrint('AuthRemoteDataSourceImpl: Respon API /verify-signup-otp: $response'); // DEBUG
      // Parsing response JSON menjadi LoginResponseModel
      final loginResponse = LoginResponseModel.fromJson(response);
      await _cacheTokens(loginResponse);
      return loginResponse;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Gagal memverifikasi OTP pendaftaran. Periksa koneksi Anda.');
    }
  }

  @override
  Future<LoginResponseModel> linkGoogleAccount(String idToken) async {
    try {
      final response = await apiClient.post(
        '/auth/mobile/google/link', // Endpoint spesifik untuk link Google
        body: {
          'id_token': idToken,
        },
      );
      debugPrint('AuthRemoteDataSourceImpl: Respon API /auth/mobile/google/link: $response'); // DEBUG
      // Parsing response JSON menjadi LoginResponseModel
      final loginResponse = LoginResponseModel.fromJson(response);
      await _cacheTokens(loginResponse);
      return loginResponse;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Gagal menautkan akun Google. Periksa koneksi internet Anda.');
    }
  }

  @override
  Future<LoginResponseModel> unlinkGoogleAccount(String password) async {
    try {
      final token = await localDataSource.getLastToken();
      final response = await apiClient.post(
        '/auth/mobile/google/unlink', // Endpoint spesifik untuk unlink Google
        body: {
          'password': password,
        },
        token: token,
      );
      debugPrint('AuthRemoteDataSourceImpl: Respon API /auth/mobile/google/unlink: $response'); // DEBUG
      // Parsing response JSON menjadi LoginResponseModel
      final loginResponse = LoginResponseModel.fromJson(response);
      await _cacheTokens(loginResponse);
      return loginResponse;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Gagal memutus tautan akun Google. Periksa koneksi internet Anda.');
    }
  }

  Future<void> _cacheTokens(LoginResponseModel response) async {
    if (response.token.isNotEmpty) {
      await localDataSource.cacheToken(response.token);
    }
    if (response.refreshToken.isNotEmpty) {
      await localDataSource.cacheRefreshToken(response.refreshToken);
    }
  }

  @override
  Future<void> resendOtp({String? userId, String? pendingId}) async {
    try {
      // Buat body request berdasarkan ID yang tersedia
      final body = <String, String>{};
      if (userId != null) {
        body['user_id'] = userId;
      } else if (pendingId != null) {
        body['pending_id'] = pendingId;
      } else {
        // Seharusnya tidak terjadi jika logika di cubit benar
        throw ServerException('User ID atau Pending ID dibutuhkan untuk mengirim ulang OTP.');
      }

      await apiClient.post('/resend-otp', body: body);
      // Tidak ada return value, sukses jika tidak ada exception
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Gagal mengirim ulang OTP. Periksa koneksi Anda.');
    }
  }

  @override
  Future<LoginResponseModel> requestPasswordReset(String email) async {
    try {
      final response = await apiClient.post(
        '/password/reset/request',
        body: {
          'email': email,
        },
      );
      // Asumsikan backend mengembalikan data user (termasuk ID) setelah request berhasil
      return LoginResponseModel.fromJson(response);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Gagal meminta reset password. Periksa koneksi Anda.');
    }
  }

  @override
  Future<void> completePasswordReset({
    required String userId,
    required String otpCode,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      await apiClient.post(
        '/password/reset/complete',
        body: {
          'user_id': userId,
          'otp_code': otpCode,
          'new_password': newPassword,
          'confirm_password': confirmPassword,
        },
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Gagal menyelesaikan reset password. Periksa koneksi Anda.');
    }
  }
}