import '../../../../core/api/api_client.dart';
import '../../../../core/error/exceptions.dart';
import '../models/recommendation_model.dart';

abstract class RecommendationRemoteDataSource {
  Future<RecommendationModel> postRecommendation(Map<String, dynamic> requestData, String token);
  Future<RecommendationModel?> getLatestRecommendation(String token);
}

class RecommendationRemoteDataSourceImpl implements RecommendationRemoteDataSource {
  final ApiClient apiClient;

  RecommendationRemoteDataSourceImpl({
    required this.apiClient,
  });

  @override
  Future<RecommendationModel> postRecommendation(Map<String, dynamic> requestData, String token) async {
    try {
      final response = await apiClient.post(
        '/recommendations',
        body: requestData,
        token: token,
      );
      return RecommendationModel.fromJson(response);
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

        return RecommendationModel.fromJson(responseDetail);
      } catch (e) {
        // If detail fetch fails (e.g. 404), fallback to the list item
        // This handles the case where the endpoint might be wrong or unavailable,
        // but ensures we at least show the summary data we have.
        
        return RecommendationModel.fromJson(latestSession);
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
