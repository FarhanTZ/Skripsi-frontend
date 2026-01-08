import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/failures.dart';
import '../repositories/recommendation_repository.dart';

class SubmitRecommendationFeedback {
  final RecommendationRepository repository;

  SubmitRecommendationFeedback(this.repository);

  Future<Either<Failure, void>> call(String sessionId, Map<String, dynamic> feedbackData) async {
    return await repository.submitFeedback(sessionId, feedbackData);
  }
}
