import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:glupulse/core/error/exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:glupulse/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:glupulse/injection_container.dart';

class ApiClient {
  // Akses service locator untuk mendapatkan data source
  final AuthLocalDataSource _localDataSource = sl<AuthLocalDataSource>();

  // URL base dari API ngrok Anda
  static const String _baseUrl =
      'https://noncereal-uncongenially-gloria.ngrok-free.dev';

  // Header default untuk setiap request
  final Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json; charset=UTF-8',
    'X-Platform': 'mobile',
  };

  Future<Map<String, dynamic>> _refreshToken() async {
    final url = Uri.parse('$_baseUrl/auth/refresh');
    try {
      final refreshToken = await _localDataSource.getLastRefreshToken();
      final response = await http.post(
        url,
        headers: {
          ..._defaultHeaders,
          'Authorization': 'Bearer $refreshToken',
        },
      ).timeout(const Duration(seconds: 15));

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final newAccessToken = responseBody['access_token'] as String;
        await _localDataSource.cacheToken(newAccessToken);
        // Backend mungkin juga mengirim refresh token baru
        if (responseBody['refresh_token'] != null) {
          final newRefreshToken = responseBody['refresh_token'] as String;
          await _localDataSource.cacheRefreshToken(newRefreshToken);
        }
        return responseBody;
      } else {
        // Jika refresh token juga gagal, paksa logout
        await _localDataSource.clearToken();
        await _localDataSource.clearRefreshToken();
        await _localDataSource.clearUser();
        throw ServerException('Sesi Anda telah berakhir. Silakan login kembali.');
      }
    } catch (e) {
      // Tangani semua jenis error saat refresh token dengan memaksa logout
      await _localDataSource.clearToken();
      await _localDataSource.clearRefreshToken();
      await _localDataSource.clearUser();
      throw ServerException('Sesi Anda telah berakhir. Silakan login kembali.');
    }
  }

  bool _isTokenExpired(http.Response response) {
    // Backend Anda mungkin mengembalikan 401 untuk token expired
    return response.statusCode == 401;
  }

  // Metode GET generik
  Future<Map<String, dynamic>> get(String endpoint, {required String token}) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    final headers = {
      ..._defaultHeaders,
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http
          .get(
            url,
            headers: headers,
          )
          .timeout(const Duration(seconds: 15));

      if (_isTokenExpired(response)) {
        await _refreshToken();
        final newToken = await _localDataSource.getLastToken();
        // Ulangi request dengan token baru
        return await get(endpoint, token: newToken);
      }

      final responseBody = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return responseBody;
      } else {
        // Tangani error lain dari server
        throw ServerException(responseBody['message'] ?? 'Terjadi kesalahan pada server');
      }
    } on SocketException {
      throw ServerException('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on TimeoutException {
      throw ServerException('Server tidak merespons. Coba lagi nanti.');
    } catch (e) {
      // Jika error berasal dari _refreshToken, lempar kembali
      if (e is ServerException) rethrow;
      throw ServerException('Gagal terhubung ke server. Terjadi kesalahan tak terduga.');
    }
  }
  // Metode POST generik
  Future<Map<String, dynamic>> post(String endpoint,
      {Map<String, dynamic>? body, String? token}) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    final headers = {
      ..._defaultHeaders,
      if (token != null) 'Authorization': 'Bearer $token',
    };

    http.Response response; // Deklarasikan di luar try-catch
    try {
      response = await http.post(
        url,
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      ).timeout(const Duration(seconds: 15));

      // Periksa apakah status code berada dalam rentang sukses (2xx)
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseBody = jsonDecode(response.body);
        // Jika sukses, kembalikan body response
        return responseBody;
      } else {
        // Coba parsing body sebagai JSON untuk mendapatkan pesan error dari backend
        try {
          final responseBody = jsonDecode(response.body);
          final errorMessage = responseBody['message'] ?? responseBody['error'] ?? 'Terjadi kesalahan pada server (Status: ${response.statusCode})';
          throw ServerException(errorMessage);
        } catch (_) {
          // Jika body bukan JSON (misal: halaman error HTML), tampilkan body mentah
          throw ServerException('Server memberikan respons tidak valid (Status: ${response.statusCode}). Respons: ${response.body}');
        }
        // Jika gagal, lempar exception dengan pesan dari server.
      }
    } on SocketException {
      // Error koneksi jaringan
      throw ServerException('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on TimeoutException {
      // Error saat request memakan waktu terlalu lama
      throw ServerException('Server tidak merespons. Coba lagi nanti.');
    } on FormatException {
      // Error jika response.body bukan JSON yang valid
      throw ServerException('Gagal memproses respons dari server. Format tidak valid.');
    } catch (e) {
      // Jika error yang ditangkap sudah merupakan ServerException, lempar kembali agar tidak dibungkus ulang.
      if (e is ServerException) {
        rethrow;
      }
      // Error lainnya, termasuk parsing JSON jika response tidak valid
      throw ServerException('Gagal terhubung ke server. Terjadi kesalahan tak terduga: ${e.toString()}');
    }
  }

  // Metode PUT generik
  Future<Map<String, dynamic>> put(String endpoint, {required Map<String, dynamic> body, required String token}) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    final headers = {
      ..._defaultHeaders,
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http
          .put(
            url,
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));

      if (_isTokenExpired(response)) {
        await _refreshToken();
        final newToken = await _localDataSource.getLastToken();
        // Ulangi request dengan token baru
        return await put(endpoint, body: body, token: newToken);
      }

      final responseBody = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return responseBody;
      } else {
        // Tangani error lain dari server
        throw ServerException(responseBody['message'] ?? 'Terjadi kesalahan pada server');
      }
    } on SocketException {
      throw ServerException('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on TimeoutException {
      throw ServerException('Server tidak merespons. Coba lagi nanti.');
    } catch (e) {
      // Jika error berasal dari _refreshToken, lempar kembali
      if (e is ServerException) rethrow;
      throw ServerException('Gagal terhubung ke server. Terjadi kesalahan tak terduga.');
    }
  }

  // Metode DELETE generik
  Future<Map<String, dynamic>> delete(String endpoint, {required String token}) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    final headers = {
      ..._defaultHeaders,
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http
          .delete(
            url,
            headers: headers,
          )
          .timeout(const Duration(seconds: 15));

      if (_isTokenExpired(response)) {
        await _refreshToken();
        final newToken = await _localDataSource.getLastToken();
        // Ulangi request dengan token baru
        return await delete(endpoint, token: newToken);
      }

      // Untuk DELETE, sukses seringkali ditandai dengan status 204 No Content
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Jika ada body, parse. Jika tidak (seperti 204), kembalikan map kosong.
        return response.body.isNotEmpty ? jsonDecode(response.body) : {};
      } else {
        final responseBody = jsonDecode(response.body);
        throw ServerException(responseBody['message'] ?? 'Gagal menghapus data');
      }
    } on SocketException {
      throw ServerException('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on TimeoutException {
      throw ServerException('Server tidak merespons. Coba lagi nanti.');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Gagal menghapus data. Terjadi kesalahan tak terduga.');
    }
  }
}