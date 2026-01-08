part of 'recommendation_feedback_cubit.dart';

abstract class RecommendationFeedbackState extends Equatable {
  const RecommendationFeedbackState();

  @override
  List<Object> get props => [];
}

class RecommendationFeedbackInitial extends RecommendationFeedbackState {}

class RecommendationFeedbackLoading extends RecommendationFeedbackState {}

class RecommendationFeedbackSuccess extends RecommendationFeedbackState {}

class RecommendationFeedbackError extends RecommendationFeedbackState {
  final String message;

  const RecommendationFeedbackError(this.message);

  @override
  List<Object> get props => [message];
}
