import 'dart:convert';
import 'package:glupulse/core/error/exceptions.dart';
import 'package:glupulse/features/auth/data/models/auth_response_model.dart';
import 'package:http/http.dart' as http;

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(String username, String password);
  Future<void> register(
      {required String firstName,
      required String lastName,
      required String username,
      required String email,
      required String password,
      required String dob,
      required String gender});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  // Ganti dengan URL base Anda, bisa dari environment variable
  final String _baseUrl = 'https://noncereal-uncongenially-gloria.ngrok-free.dev';

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<AuthResponseModel> login(String username, String password) async {
    final url = Uri.parse('$_baseUrl/login');

    final request = http.Request('POST', url)
      ..headers['Content-Type'] = 'application/json'
      ..headers['Accept'] = 'application/json'
      ..headers['X-Platform'] = 'mobile'
      ..body = jsonEncode({
        'Username': username,
        'Password': password,
      });

    final streamedResponse = await client.send(request);
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return AuthResponseModel.fromJson(jsonDecode(response.body));
    } else {
      // Melempar exception yang akan ditangkap oleh Repository
      final errorBody = jsonDecode(response.body);
      throw ServerException(message: errorBody['message'] ?? 'Login Gagal');
    }
  }

  @override
  Future<void> register(
      {required String username,
      required String email,
      required String password,
      required String firstName,
      required String lastName,
      required String dob,
      required String gender}) async {
    final url = Uri.parse('$_baseUrl/signup');
    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-Platform': 'mobile',
      },
      body: jsonEncode({
        'first_name': firstName,
        'last_name': lastName,
        'username': username,
        'email': email,
        'password': password,
        'dob': dob,
        'gender': gender,
      }),
    );

    if (response.statusCode != 201 && response.statusCode != 200) { // 201 Created atau 200 OK
      final errorBody = jsonDecode(response.body);
      throw ServerException(message: errorBody['message'] ?? 'Registrasi Gagal');
    }
    // Tidak mengembalikan apa-apa jika sukses
  }
}