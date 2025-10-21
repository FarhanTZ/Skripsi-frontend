import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:glupulse/core/error/exceptions.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  // URL base dari API ngrok Anda
  static const String _baseUrl =
      'https://noncereal-uncongenially-gloria.ngrok-free.dev';

  // Header default untuk setiap request
  final Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json; charset=UTF-8',
    'X-Platform': 'mobile',
  };

  // Metode POST generik
  Future<Map<String, dynamic>> post(String endpoint, {Map<String, dynamic>? body}) async {
    final url = Uri.parse('$_baseUrl$endpoint');

    try {
      final response = await http.post(
        url,
        headers: _defaultHeaders,
        body: body != null ? jsonEncode(body) : null,
      ).timeout(const Duration(seconds: 15));

      final responseBody = jsonDecode(response.body);

      // Periksa apakah status code berada dalam rentang sukses (2xx)
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Jika sukses, kembalikan body response
        return responseBody;
      } else {
        // Jika gagal, lempar exception dengan pesan dari server.
        throw ServerException(responseBody['message'] ?? 'Terjadi kesalahan pada server');
      }
    } on SocketException {
      // Error koneksi jaringan
      throw ServerException('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on TimeoutException {
      // Error saat request memakan waktu terlalu lama
      throw ServerException('Server tidak merespons. Coba lagi nanti.');
    } catch (e) {
      // Error lainnya, termasuk parsing JSON jika response tidak valid
      throw ServerException('Gagal terhubung ke server. Terjadi kesalahan tak terduga.');
    }
  }
}