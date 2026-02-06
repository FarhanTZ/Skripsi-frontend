import 'package:flutter/foundation.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/error/exceptions.dart';
import '../models/recommendation_model.dart';

abstract class RecommendationRemoteDataSource {
  Future<RecommendationModel> postRecommendation(Map<String, dynamic> requestData, String token);
  Future<RecommendationModel?> getLatestRecommendation(String token);
  Future<void> submitFeedback(String sessionId, Map<String, dynamic> feedbackData, String token);
  Future<void> submitFoodFeedback(String recommendationFoodId, Map<String, dynamic> feedbackData, String token);
  Future<void> submitActivityFeedback(String recommendationActivityId, Map<String, dynamic> feedbackData, String token);
}

class RecommendationRemoteDataSourceImpl implements RecommendationRemoteDataSource {
  final ApiClient apiClient;

  RecommendationRemoteDataSourceImpl({
    required this.apiClient,
  });

  @override
  Future<RecommendationModel> postRecommendation(Map<String, dynamic> requestData, String token) async {
    try {
      debugPrint('DEBUG: Sending Recommendation Request: $requestData'); // Added debug print
      final response = await apiClient.post(
        '/recommendations',
        body: requestData,
        token: token,
      );
      debugPrint('DEBUG: Received Recommendation Response: $response'); // Added debug print
      return RecommendationModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> submitFeedback(String sessionId, Map<String, dynamic> feedbackData, String token) async {
    try {
      await apiClient.post(
        '/recommendation/feedback/$sessionId',
        body: feedbackData,
        token: token,
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> submitFoodFeedback(String recommendationFoodId, Map<String, dynamic> feedbackData, String token) async {
    try {
      await apiClient.post(
        '/recommendation/feedback/food/$recommendationFoodId',
        body: feedbackData,
        token: token,
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> submitActivityFeedback(String recommendationActivityId, Map<String, dynamic> feedbackData, String token) async {
    try {
      await apiClient.post(
        '/recommendation/feedback/activity/$recommendationActivityId',
        body: feedbackData,
        token: token,
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<RecommendationModel?> getLatestRecommendation(String token) async {
    try {
      final responseMap = await apiClient.get( // Changed to get() as it returns a Map
        '/recommendations',
        token: token,
      );

      List<dynamic> sessionsData = [];
      if (responseMap.containsKey('sessions')) {
         sessionsData = responseMap['sessions'] as List<dynamic>;
      }

      if (sessionsData.isEmpty) {
        return null;
      }

      // Sort sessions by created_at in descending order to get the latest
      sessionsData.sort((a, b) {
        final DateTime dateA = DateTime.parse(a['created_at']);
        final DateTime dateB = DateTime.parse(b['created_at']);
        return dateB.compareTo(dateA);
      });

      final latestSession = sessionsData.first;
      final String sessionId = latestSession['session_id'];
      
      try {
         final responseDetail = await apiClient.get(
          '/recommendation/$sessionId', 
          token: token,
        );
        debugPrint('DEBUG: Received Recommendation Detail: $responseDetail'); // Added debug print

        return RecommendationModel.fromJson(responseDetail);
      } catch (e) {
        // If detail fetch fails (e.g. 404), fallback to the list item
        // This handles the case where the endpoint might be wrong or unavailable,
        // but ensures we at least show the summary data we have.
        debugPrint('DEBUG: Failed to fetch detail, falling back to session list item: $latestSession. Error: $e'); // Added debug print
        
        return RecommendationModel.fromJson(latestSession);
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
