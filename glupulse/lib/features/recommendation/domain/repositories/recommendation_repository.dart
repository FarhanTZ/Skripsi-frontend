import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/failures.dart';
import '../entities/recommendation_entity.dart';

abstract class RecommendationRepository {
  Future<Either<Failure, RecommendationEntity>> postRecommendation(Map<String, dynamic> requestData);
  Future<Either<Failure, RecommendationEntity>> getLatestRecommendation();
  Future<Either<Failure, void>> submitFeedback(String sessionId, Map<String, dynamic> feedbackData);
  Future<Either<Failure, void>> submitFoodFeedback(String recommendationFoodId, Map<String, dynamic> feedbackData);
  Future<Either<Failure, void>> submitActivityFeedback(String recommendationActivityId, Map<String, dynamic> feedbackData);
}
