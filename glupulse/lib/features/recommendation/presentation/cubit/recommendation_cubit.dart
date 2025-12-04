import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';// Added this import
import '../../domain/entities/recommendation_entity.dart';
import '../../domain/usecases/post_recommendation.dart';

part 'recommendation_state.dart';

class RecommendationCubit extends Cubit<RecommendationState> {
  final PostRecommendation postRecommendation;

  RecommendationCubit({required this.postRecommendation}) : super(RecommendationInitial());

  Future<void> fetchRecommendation(Map<String, dynamic> requestData) async {
    emit(RecommendationLoading());
    final failureOrRecommendation = await postRecommendation(requestData);
    
    failureOrRecommendation.fold(
      (failure) => emit(RecommendationError(failure.message)),
      (recommendation) => emit(RecommendationLoaded(recommendation)),
    );
  }
}
