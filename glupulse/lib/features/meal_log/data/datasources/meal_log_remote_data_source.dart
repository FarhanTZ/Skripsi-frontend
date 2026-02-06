import 'package:flutter/foundation.dart';
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
      debugPrint('DEBUG: Calling getMealLogs...');
      final response = await apiClient.getList(
        '/health/log/meals',
        token: token,
      );
      debugPrint('DEBUG: getMealLogs response received. items count: ${response.length}');
      
      return response.map((json) {
        try {
          // Print raw JSON to debug server response
          debugPrint('DEBUG: Raw Meal Log JSON: $json');
          return MealLogModel.fromJson(json);
        } catch (e) {
          debugPrint('DEBUG: Error parsing meal log item: $e');
          debugPrint('DEBUG: JSON that failed: $json');
          rethrow;
        }
      }).toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      debugPrint('DEBUG: Error in getMealLogs: $e');
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
      debugPrint('DEBUG: Calling PUT updateMealLog for ID ${mealLog.mealId}');
      final response = await apiClient.put(
        '/health/log/meal/${mealLog.mealId}',
        body: mealLog.toJson(),
        token: token,
      );
      debugPrint('DEBUG: PUT response received: $response');
      return _parseMealLogResponse(response);
    } catch (e) {
      debugPrint('DEBUG: Error in updateMealLog: $e');
      throw ServerException(e.toString());
    }
  }

  MealLogModel _parseMealLogResponse(dynamic response) {
    try {
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
    } catch (e) {
      debugPrint('DEBUG: Error parsing response: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteMealLog(String id, String token) async {
    try {
      await apiClient.delete(
        '/health/log/meal/$id',
        token: token,
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }
}
