import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/failures.dart';
import '../repositories/recommendation_repository.dart';

class SubmitFoodFeedback {
  final RecommendationRepository repository;

  SubmitFoodFeedback(this.repository);

  Future<Either<Failure, void>> call(String recommendationFoodId, Map<String, dynamic> feedbackData) async {
    return await repository.submitFoodFeedback(recommendationFoodId, feedbackData);
  }
}
