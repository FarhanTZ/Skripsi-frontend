import 'package:glupulse/core/api/api_client.dart';
import 'package:glupulse/core/error/exceptions.dart';
import 'package:glupulse/features/activity/data/models/activity_log_model.dart';
import 'package:glupulse/features/activity/data/models/activity_type_model.dart';

abstract class ActivityRemoteDataSource {
  Future<List<ActivityTypeModel>> getActivityTypes(String token);
  Future<List<ActivityLogModel>> getActivityLogs(String token);
  Future<void> addActivityLog(ActivityLogModel activityLog, String token);
  Future<void> updateActivityLog(ActivityLogModel activityLog, String token);
  Future<void> deleteActivityLog(String id, String token);
}

class ActivityRemoteDataSourceImpl implements ActivityRemoteDataSource {
  final ApiClient apiClient;

  ActivityRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ActivityTypeModel>> getActivityTypes(String token) async {
    try {
      final response = await apiClient.getList(
        '/health/activity_type',
        token: token,
      );
      return response.map((json) => ActivityTypeModel.fromJson(json)).toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<ActivityLogModel>> getActivityLogs(String token) async {
    try {
      final response = await apiClient.getList(
        '/health/log/activity',
        token: token,
      );
      return response.map((json) => ActivityLogModel.fromJson(json)).toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> addActivityLog(ActivityLogModel activityLog, String token) async {
    try {
      await apiClient.post(
        '/health/log/activity',
        body: activityLog.toJson(),
        token: token,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updateActivityLog(ActivityLogModel activityLog, String token) async {
    try {
      await apiClient.put(
        '/health/log/activity/${activityLog.activityId}',
        body: activityLog.toJson(),
        token: token,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteActivityLog(String id, String token) async {
    try {
      await apiClient.delete(
        '/health/log/activity/$id',
        token: token,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
