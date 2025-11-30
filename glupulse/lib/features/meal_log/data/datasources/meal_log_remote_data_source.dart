import 'package:glupulse/core/api/api_client.dart';
import 'package:glupulse/core/error/exceptions.dart';
import 'package:glupulse/features/meal_log/data/models/meal_log_model.dart';

abstract class MealLogRemoteDataSource {
  Future<List<MealLogModel>> getMealLogs(String token);
  Future<MealLogModel> getMealLog(String id, String token);
  Future<MealLogModel> addMealLog(MealLogModel mealLog, String token);
  Future<MealLogModel> updateMealLog(MealLogModel mealLog, String token);
  Future<void> deleteMealLog(String id, String token);
}

class MealLogRemoteDataSourceImpl implements MealLogRemoteDataSource {
  final ApiClient apiClient;

  MealLogRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<MealLogModel>> getMealLogs(String token) async {
    try {
      final response = await apiClient.getList(
        '/health/log/meals',
        token: token,
      );
      return response.map((json) => MealLogModel.fromJson(json)).toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<MealLogModel> getMealLog(String id, String token) async {
    try {
      final response = await apiClient.get(
        '/health/log/meal/$id',
        token: token,
      );
      return _parseMealLogResponse(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<MealLogModel> addMealLog(MealLogModel mealLog, String token) async {
    try {
      final response = await apiClient.post(
        '/health/log/meal',
        body: mealLog.toJson(),
        token: token,
      );
      return _parseMealLogResponse(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<MealLogModel> updateMealLog(MealLogModel mealLog, String token) async {
    try {
      final response = await apiClient.put(
        '/health/log/meal/${mealLog.mealId}',
        body: mealLog.toJson(),
        token: token,
      );
      return _parseMealLogResponse(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  MealLogModel _parseMealLogResponse(dynamic response) {
    if (response is Map<String, dynamic>) {
      Map<String, dynamic>? mealLogData;
      if (response.containsKey('meal_log')) {
        mealLogData = response['meal_log'];
      } else if (response.containsKey('_meal_log')) {
        mealLogData = response['_meal_log'];
      }

      if (mealLogData != null) {
        final List<dynamic>? itemsData = response['items'];

        final Map<String, dynamic> mergedData = Map.from(mealLogData);
        if (itemsData != null) {
          mergedData['items'] = itemsData;
        }
        return MealLogModel.fromJson(mergedData);
      }
    }
    return MealLogModel.fromJson(response);
  }

  @override
  Future<void> deleteMealLog(String id, String token) async {
    try {
      await apiClient.delete(
        '/health/log/meal/$id',
        token: token,
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
