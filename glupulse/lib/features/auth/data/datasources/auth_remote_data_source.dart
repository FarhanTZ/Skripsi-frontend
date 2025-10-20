import 'package:glupulse/core/api/api_client.dart';
import 'package:glupulse/core/error/exceptions.dart';
import 'package:glupulse/features/auth/data/models/login_response_model.dart';
import 'package:glupulse/features/auth/domain/usecases/register_usecase.dart';

/// Abstract class untuk mendefinisikan kontrak dari Auth Remote Data Source.
/// Ini berguna untuk dependency injection dan testing.
abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> login(String username, String password);
  Future<LoginResponseModel> loginWithGoogle(String idToken);
  Future<LoginResponseModel> register({required RegisterParams params});
  Future<LoginResponseModel> verifyOtp(String userId, String otpCode);
}

/// Implementasi konkret dari AuthRemoteDataSource.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

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
      // Parsing response JSON menjadi LoginResponseModel
      return LoginResponseModel.fromJson(response);
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
      // Parsing response JSON menjadi LoginResponseModel
      return LoginResponseModel.fromJson(response);
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
          "city": params.city,
        },
      );
      // Kita asumsikan responsenya sama dengan login (mengembalikan data user)
      return LoginResponseModel.fromJson(response);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Gagal terhubung ke server. Periksa koneksi internet Anda.');
    }
  }

  @override
  Future<LoginResponseModel> verifyOtp(String userId, String otpCode) async {
    try {
      final response = await apiClient.post(
        '/verify-otp', // Endpoint spesifik untuk verifikasi OTP
        body: {
          'user_id': userId,
          'otp_code': otpCode,
        },
      );
      // Parsing response JSON menjadi LoginResponseModel
      return LoginResponseModel.fromJson(response);
    } on ServerException {
      rethrow; // Jika sudah ServerException (dari ApiClient), lempar kembali.
    } catch (e) {
      // Tangani error koneksi atau error tak terduga lainnya.
      throw ServerException('Gagal terhubung ke server. Periksa koneksi internet Anda.');
    }
  }
}