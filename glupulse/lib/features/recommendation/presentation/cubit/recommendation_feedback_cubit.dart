import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecases/submit_recommendation_feedback.dart';
import '../../domain/usecases/submit_food_feedback.dart';
import '../../domain/usecases/submit_activity_feedback.dart';

part 'recommendation_feedback_state.dart';

class RecommendationFeedbackCubit extends Cubit<RecommendationFeedbackState> {
  final SubmitRecommendationFeedback submitRecommendationFeedback;
  final SubmitFoodFeedback submitFoodFeedback;
  final SubmitActivityFeedback submitActivityFeedback;

  RecommendationFeedbackCubit({
    required this.submitRecommendationFeedback,
    required this.submitFoodFeedback,
    required this.submitActivityFeedback,
  }) : super(RecommendationFeedbackInitial());

  Future<void> submitOverallFeedback(String sessionId, String overallFeedback, String notes) async {
    emit(RecommendationFeedbackLoading());
    
    final feedbackData = {
      "overall_feedback": overallFeedback,
      "notes": notes,
    };

    final result = await submitRecommendationFeedback(sessionId, feedbackData);

    result.fold(
      (failure) => emit(RecommendationFeedbackError(failure.message)),
      (_) => emit(RecommendationFeedbackSuccess()),
    );
  }

  Future<void> submitFoodFeedbackEntry(String recommendationFoodId, String foodId, int rating, String notes, int glucoseSpike) async {
    emit(RecommendationFeedbackLoading());

    final feedbackData = {
      "food_id": foodId,
      "rating": rating,
      "notes": notes,
      "glucose_spike": glucoseSpike,
    };

    final result = await submitFoodFeedback(recommendationFoodId, feedbackData);

    result.fold(
      (failure) => emit(RecommendationFeedbackError(failure.message)),
      (_) => emit(RecommendationFeedbackSuccess()),
    );
  }

  Future<void> submitActivityFeedbackEntry(String recommendationActivityId, int activityId, int rating, String notes, int glucoseChange) async {
    emit(RecommendationFeedbackLoading());

    final feedbackData = {
      "activity_id": activityId,
      "rating": rating,
      "notes": notes,
      "glucose_change": glucoseChange,
    };

    final result = await submitActivityFeedback(recommendationActivityId, feedbackData);

    result.fold(
      (failure) => emit(RecommendationFeedbackError(failure.message)),
      (_) => emit(RecommendationFeedbackSuccess()),
    );
  }
}
