import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/failures.dart';
import '../repositories/recommendation_repository.dart';

class SubmitActivityFeedback {
  final RecommendationRepository repository;

  SubmitActivityFeedback(this.repository);

  Future<Either<Failure, void>> call(String recommendationActivityId, Map<String, dynamic> feedbackData) async {
    return await repository.submitActivityFeedback(recommendationActivityId, feedbackData);
  }
}
