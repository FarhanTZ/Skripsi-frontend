import 'package:glupulse/core/api/api_client.dart';
import 'package:glupulse/core/error/exceptions.dart';
import 'package:glupulse/features/glucose/data/models/glucose_model.dart';

abstract class GlucoseRemoteDataSource {
  Future<List<GlucoseModel>> getGlucoseRecords(String token);
  Future<GlucoseModel> getGlucoseRecord(String id, String token);
  Future<GlucoseModel> addGlucoseRecord(GlucoseModel glucose, String token);
  Future<GlucoseModel> updateGlucoseRecord(GlucoseModel glucose, String token);
  Future<void> deleteGlucoseRecord(String id, String token);
}

class GlucoseRemoteDataSourceImpl implements GlucoseRemoteDataSource {
  final ApiClient apiClient;

  GlucoseRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<GlucoseModel> addGlucoseRecord(GlucoseModel glucose, String token) async {
    try {
      final response = await apiClient.post(
        '/health/glucose',
        body: glucose.toJson(),
        token: token,
      );
      return GlucoseModel.fromJson(response);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteGlucoseRecord(String id, String token) async {
    try {
      await apiClient.delete(
        '/health/glucose/$id',
        token: token,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<GlucoseModel> getGlucoseRecord(String id, String token) async {
    try {
      final response = await apiClient.get(
        '/health/glucose/$id',
        token: token,
      );
      return GlucoseModel.fromJson(response);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<GlucoseModel>> getGlucoseRecords(String token) async {
    try {
      final response = await apiClient.getList(
        '/health/glucose',
        token: token,
      );
      return response.map((json) => GlucoseModel.fromJson(json)).toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<GlucoseModel> updateGlucoseRecord(GlucoseModel glucose, String token) async {
    try {
      final response = await apiClient.put(
        '/health/glucose/${glucose.readingId}',
        body: glucose.toJson(),
        token: token,
      );
      return GlucoseModel.fromJson(response);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
