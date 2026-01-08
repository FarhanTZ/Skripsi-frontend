import 'package:glupulse/core/api/api_client.dart';
import 'package:glupulse/core/error/exceptions.dart';
import 'package:glupulse/features/health_event/data/models/health_event_model.dart';

abstract class HealthEventRemoteDataSource {
  Future<List<HealthEventModel>> getHealthEventRecords(String token);
  Future<HealthEventModel> getHealthEventRecord(String id, String token);
  Future<HealthEventModel> addHealthEventRecord(
      HealthEventModel healthEvent, String token);
  Future<HealthEventModel> updateHealthEventRecord(
      HealthEventModel healthEvent, String token);
  Future<void> deleteHealthEventRecord(String id, String token);
}

class HealthEventRemoteDataSourceImpl implements HealthEventRemoteDataSource {
  final ApiClient apiClient;

  HealthEventRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<HealthEventModel> addHealthEventRecord(
      HealthEventModel healthEvent, String token) async {
    try {
      final response = await apiClient.post(
        '/health/events',
        body: healthEvent.toJson(),
        token: token,
      );
      return HealthEventModel.fromJson(response);
    } catch (e) {
      // Coba ekstrak pesan yang lebih baik jika memungkinkan
      if (e is ServerException) {
        // Jika sudah ServerException, lempar kembali
        rethrow;
      }
      // Jika tidak, bungkus dengan pesan yang lebih umum atau dari e.toString()
      throw ServerException(e.toString()); // Atau buat pesan yang lebih spesifik
    }
  }

  @override
  Future<void> deleteHealthEventRecord(String id, String token) async {
    try {
      await apiClient.delete(
        '/health/events/$id',
        token: token,
      );
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(e.toString());
    }
  }

  @override
  Future<HealthEventModel> getHealthEventRecord(String id, String token) async {
    try {
      final response = await apiClient.get(
        '/health/events/$id',
        token: token,
      );
      return HealthEventModel.fromJson(response);
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<HealthEventModel>> getHealthEventRecords(String token) async {
    try {
      final response = await apiClient.getList(
        '/health/events',
        token: token,
      );
      return response.map((json) => HealthEventModel.fromJson(json)).toList();
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(e.toString());
    }
  }

  @override
  Future<HealthEventModel> updateHealthEventRecord(
      HealthEventModel healthEvent, String token) async {
    try {
      final response = await apiClient.put(
        '/health/events/${healthEvent.id}',
        body: healthEvent.toJson(),
        token: token,
      );
      return HealthEventModel.fromJson(response);
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(e.toString());
    }
  }
}