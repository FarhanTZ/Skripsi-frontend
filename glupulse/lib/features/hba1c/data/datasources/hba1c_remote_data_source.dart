import 'package:glupulse/core/api/api_client.dart';
import 'package:glupulse/core/error/exceptions.dart';
import 'package:glupulse/features/hba1c/data/models/hba1c_model.dart';

abstract class Hba1cRemoteDataSource {
  Future<List<Hba1cModel>> getHba1cRecords(String token);
  Future<Hba1cModel> getHba1cRecord(String id, String token);
  Future<Hba1cModel> addHba1cRecord(Hba1cModel hba1c, String token);
  Future<Hba1cModel> updateHba1cRecord(Hba1cModel hba1c, String token);
  Future<void> deleteHba1cRecord(String id, String token);
}

class Hba1cRemoteDataSourceImpl implements Hba1cRemoteDataSource {
  final ApiClient apiClient;

  Hba1cRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<Hba1cModel> addHba1cRecord(Hba1cModel hba1c, String token) async {
    try {
      final response = await apiClient.post(
        '/health/hba1c',
        body: hba1c.toJson(),
        token: token,
      );
      return Hba1cModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteHba1cRecord(String id, String token) async {
    try {
      await apiClient.delete(
        '/health/hba1c/$id',
        token: token,
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Hba1cModel> getHba1cRecord(String id, String token) async {
    try {
      final response = await apiClient.get(
        '/health/hba1c/$id',
        token: token,
      );
      return Hba1cModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<Hba1cModel>> getHba1cRecords(String token) async {
    try {
      final response = await apiClient.getList(
        '/health/hba1c',
        token: token,
      );
      return response.map((json) => Hba1cModel.fromJson(json)).toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Hba1cModel> updateHba1cRecord(Hba1cModel hba1c, String token) async {
    try {
      final response = await apiClient.put(
        '/health/hba1c/${hba1c.id}',
        body: hba1c.toJson(),
        token: token,
      );
      return Hba1cModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}