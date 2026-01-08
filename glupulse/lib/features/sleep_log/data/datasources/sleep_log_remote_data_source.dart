import 'package:glupulse/core/api/api_client.dart';
import 'package:glupulse/core/error/exceptions.dart';
import 'package:glupulse/features/sleep_log/data/models/sleep_log_model.dart';

abstract class SleepLogRemoteDataSource {
  Future<List<SleepLogModel>> getSleepLogs(String token);
  Future<SleepLogModel> getSleepLog(String id, String token);
  Future<SleepLogModel> addSleepLog(SleepLogModel sleepLog, String token);
  Future<SleepLogModel> updateSleepLog(SleepLogModel sleepLog, String token);
  Future<void> deleteSleepLog(String id, String token);
}

class SleepLogRemoteDataSourceImpl implements SleepLogRemoteDataSource {
  final ApiClient apiClient;

  SleepLogRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<SleepLogModel> addSleepLog(SleepLogModel sleepLog, String token) async {
    try {
      final response = await apiClient.post(
        '/health/log/sleep',
        body: sleepLog.toJson(),
        token: token,
      );
      return SleepLogModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteSleepLog(String id, String token) async {
    try {
      await apiClient.delete(
        '/health/log/sleep/$id',
        token: token,
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<SleepLogModel> getSleepLog(String id, String token) async {
    try {
      final response = await apiClient.get(
        '/health/log/sleep/$id',
        token: token,
      );
      return SleepLogModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<SleepLogModel>> getSleepLogs(String token) async {
    try {
      final response = await apiClient.getList(
        '/health/log/sleep',
        token: token,
      );
      return response.map((json) => SleepLogModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<SleepLogModel> updateSleepLog(SleepLogModel sleepLog, String token) async {
    try {
      final response = await apiClient.put(
        '/health/log/sleep/${sleepLog.id}',
        body: sleepLog.toJson(),
        token: token,
      );
      return SleepLogModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
