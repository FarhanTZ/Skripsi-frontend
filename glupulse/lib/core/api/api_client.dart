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
          .timeout(const Duration(seconds: 60));

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

  // Metode GET generik untuk List
  Future<List<dynamic>> getList(String endpoint, {required String token}) async {
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
          .timeout(const Duration(seconds: 60));

      if (_isTokenExpired(response)) {
        await _refreshToken();
        final newToken = await _localDataSource.getLastToken();
        // Ulangi request dengan token baru
        return await getList(endpoint, token: newToken);
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isEmpty) {
          return []; // Return empty list for 2xx status with empty body
        }
        final responseBody = jsonDecode(response.body);
        if (responseBody is List) {
          return responseBody;
        } else if (responseBody is Map<String, dynamic>) {
          // Check if the map contains a message indicating no data
          final message = (responseBody['message'] as String? ?? responseBody['error'] as String? ?? '').toLowerCase();
          if (message.contains('no records') || message.contains('data not found') || message.contains('empty')) {
            return []; // Treat as empty list
          }
          
          // Prioritize common keys for data lists
          if (responseBody['data'] is List) return responseBody['data'];
          if (responseBody['items'] is List) return responseBody['items'];
          if (responseBody['orders'] is List) return responseBody['orders'];
          if (responseBody['results'] is List) return responseBody['results'];
          
          // NEW: Attempt to find a list inside the map values (e.g. { "data": [...] })
          for (final value in responseBody.values) {
            if (value is List) {
              return value;
            }
          }
          
          // If map is empty, treat as empty list
          if (responseBody.isEmpty) {
            return [];
          }

          // If it's a map but doesn't indicate no data and contains no list
          throw ServerException('Respons dari server bukan format yang diharapkan (diharapkan List, menerima Map).');
        } else {
          throw ServerException('Respons dari server bukan format yang diharapkan (diharapkan List).');
        }
      } else if (response.statusCode == 404) {
        // Handle 404 for list endpoint as an empty list, as no resources were found.
        return [];
      } else {
        // Original error handling for other non-2xx status codes
        if (response.body.isNotEmpty) {
          try {
            final responseBody = jsonDecode(response.body);
            if (responseBody is Map<String, dynamic>) {
              throw ServerException(responseBody['message'] ?? 'Terjadi kesalahan pada server');
            }
          } on FormatException {
            // responseBody is not JSON, throw a generic server exception
          }
        }
        throw ServerException('Terjadi kesalahan pada server (Status: ${response.statusCode})');
      }
    } on SocketException {
      throw ServerException('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on TimeoutException {
      throw ServerException('Server tidak merespons. Coba lagi nanti.');
    } on FormatException { // Catch FormatException if jsonDecode fails for non-2xx with body
      throw ServerException('Gagal memproses respons dari server. Format tidak valid.');
    } catch (e) {
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
      ).timeout(const Duration(seconds: 60));

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
          .timeout(const Duration(seconds: 60));

      if (_isTokenExpired(response)) {
        await _refreshToken();
        final newToken = await _localDataSource.getLastToken();
        // Ulangi request dengan token baru
        return await put(endpoint, body: body, token: newToken);
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Jika body kosong (misal status 204), kembalikan map kosong
        if (response.body.isEmpty) {
          return {};
        }
        final responseBody = jsonDecode(response.body);
        return responseBody;
      } else {
        try {
          final responseBody = jsonDecode(response.body);
          final errorMessage = responseBody['message'] ?? responseBody['error'] ?? 'Terjadi kesalahan pada server (Status: ${response.statusCode})';
          throw ServerException(errorMessage);
        } catch (_) {
          throw ServerException('Server memberikan respons tidak valid (Status: ${response.statusCode}).');
        }
      }
    } on SocketException {
      throw ServerException('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on TimeoutException {
      throw ServerException('Server tidak merespons. Coba lagi nanti.');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Gagal terhubung ke server. Terjadi kesalahan tak terduga.');
    }
  }

  // Metode DELETE generik
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    required String token,
    Map<String, dynamic>? body, // Tambahkan parameter body
  }) async {
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
            body: body != null ? jsonEncode(body) : null, // Kirim body jika ada
          )
          .timeout(const Duration(seconds: 60));

      if (_isTokenExpired(response)) {
        await _refreshToken();
        final newToken = await _localDataSource.getLastToken();
        // Ulangi request dengan token baru
        return await delete(endpoint, token: newToken, body: body);
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

  // Metode untuk mengambil gambar dengan header khusus ngrok
  Future<http.Response> getImage(String imageUrl) async {
    final url = Uri.parse(imageUrl);
    final headers = {
      'ngrok-skip-browser-warning': 'true',
    };

    try {
      final response = await http
          .get(
            url,
            headers: headers,
          )
          .timeout(const Duration(seconds: 60));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response;
      } else {
        throw ServerException('Gagal memuat gambar (Status: ${response.statusCode})');
      }
    } on SocketException {
      throw ServerException('Tidak ada koneksi internet untuk memuat gambar.');
    } on TimeoutException {
      throw ServerException('Server tidak merespons saat memuat gambar.');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Terjadi kesalahan tak terduga saat memuat gambar.');
    }
  }
}