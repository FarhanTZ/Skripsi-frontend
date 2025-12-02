import '../../../../core/api/api_client.dart';
import '../../../../core/error/exceptions.dart';
import '../models/recommendation_model.dart';

abstract class RecommendationRemoteDataSource {
  Future<RecommendationModel> getRecommendation(Map<String, dynamic> requestData, String token);
}

class RecommendationRemoteDataSourceImpl implements RecommendationRemoteDataSource {
  final ApiClient apiClient;

  RecommendationRemoteDataSourceImpl({
    required this.apiClient,
  });

  @override
  Future<RecommendationModel> getRecommendation(Map<String, dynamic> requestData, String token) async {
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
}
