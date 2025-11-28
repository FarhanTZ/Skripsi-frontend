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
      // The API returns a wrapped object { "items": [...], "meal_log": {...} } for detail
      // But MealLogModel.fromJson expects the flattened fields or nested structure?
      // Let's check the API response structure for detail again.
      /*
        {
            "items": [...],
            "meal_log": {
                "meal_id": "...",
                ...
            }
        }
      */
      // My MealLogModel structure has `items` and `mealId` etc at the same level.
      // I need to merge them or handle this structure.
      // I will handle it here by merging them into a single map before passing to fromJson.

      final Map<String, dynamic> mealLogData = response['meal_log'];
      final List<dynamic> itemsData = response['items'];
      
      final Map<String, dynamic> mergedData = Map.from(mealLogData);
      mergedData['items'] = itemsData;

      return MealLogModel.fromJson(mergedData);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<MealLogModel> addMealLog(MealLogModel mealLog, String token) async {
    try {
      // API expects payload structure for POST.
      // Check @api.md for POST payload.
      // It seems to accept fields directly.
      final response = await apiClient.post(
        '/health/log/meal',
        body: mealLog.toJson(), // Ensure toJson matches POST payload expectations
        token: token,
      );
      // Response might be the created object? Standard REST practice.
      // Assuming it returns the created object or I might need to fetch it.
      // Codebase usually assumes response is the object.
      return MealLogModel.fromJson(response);
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
      return MealLogModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
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
      throw ServerException(e.toString());
    }
  }
}
