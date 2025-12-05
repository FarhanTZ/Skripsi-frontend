import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/recommendation_entity.dart';
import '../../domain/usecases/post_recommendation.dart';
import '../../domain/usecases/get_latest_recommendation.dart'; // New import

part 'recommendation_state.dart';

class RecommendationCubit extends Cubit<RecommendationState> {
  final PostRecommendation postRecommendation;
  final GetLatestRecommendation getLatestRecommendation; // New dependency

  RecommendationCubit({
    required this.postRecommendation,
    required this.getLatestRecommendation, // New dependency
  }) : super(RecommendationInitial());

  Future<void> fetchRecommendation(Map<String, dynamic> requestData) async {
    emit(RecommendationLoading());
    final failureOrRecommendation = await postRecommendation(requestData);
    
    failureOrRecommendation.fold(
      (failure) => emit(RecommendationError(failure.message)),
      (recommendation) => emit(RecommendationLoaded(recommendation)),
    );
  }

  Future<void> fetchLatestRecommendation() async {
    emit(RecommendationLoading());
    final failureOrRecommendation = await getLatestRecommendation();

    failureOrRecommendation.fold(
      (failure) => emit(RecommendationError(failure.message)),
      (recommendation) => emit(RecommendationLoaded(recommendation)),
    );
  }
}
