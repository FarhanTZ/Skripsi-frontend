import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';// Added this import
import '../../domain/entities/recommendation_entity.dart';
import '../../domain/usecases/get_recommendation.dart';

part 'recommendation_state.dart';

class RecommendationCubit extends Cubit<RecommendationState> {
  final GetRecommendation getRecommendation;

  RecommendationCubit({required this.getRecommendation}) : super(RecommendationInitial());

  Future<void> fetchRecommendation(Map<String, dynamic> requestData) async {
    emit(RecommendationLoading());
    final failureOrRecommendation = await getRecommendation(requestData);
    
    failureOrRecommendation.fold(
      (failure) => emit(RecommendationError(failure.message)),
      (recommendation) => emit(RecommendationLoaded(recommendation)),
    );
  }
}
