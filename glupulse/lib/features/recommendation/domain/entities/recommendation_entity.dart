import 'package:equatable/equatable.dart';

class RecommendationEntity extends Equatable {
  final String sessionId;
  final String analysisSummary;
  final String insightsResponse;
  final List<ActivityRecommendationEntity> activityRecommendations;
  // foodRecommendations is empty in example, but we can structure it if needed. 
  // For now keeping it dynamic or list of strings to avoid complexity if structure is unknown.
  final List<FoodRecommendationEntity> foodRecommendations;

  const RecommendationEntity({
    required this.sessionId,
    required this.analysisSummary,
    required this.insightsResponse,
    required this.activityRecommendations,
    required this.foodRecommendations,
  });

  @override
  List<Object?> get props => [
        sessionId,
        analysisSummary,
        insightsResponse,
        activityRecommendations,
        foodRecommendations,
      ];
}

class ActivityRecommendationEntity extends Equatable {
  final int activityId;
  final String activityCode;
  final String activityName;
  final String description;
  final String imageUrl;
  final double metValue;
  final String measurementUnit;
  final double recommendedMinValue;
  final String reason;
  final double recommendedDurationMinutes;
  final String recommendedIntensity;
  final String safetyNote;
  final String bestTime;
  final int rank;

  const ActivityRecommendationEntity({
    required this.activityId,
    required this.activityCode,
    required this.activityName,
    required this.description,
    required this.imageUrl,
    required this.metValue,
    required this.measurementUnit,
    required this.recommendedMinValue,
    required this.reason,
    required this.recommendedDurationMinutes,
    required this.recommendedIntensity,
    required this.safetyNote,
    required this.bestTime,
    required this.rank,
  });

  @override
  List<Object?> get props => [
        activityId,
        activityCode,
        activityName,
        description,
        imageUrl,
        metValue,
        measurementUnit,
        recommendedMinValue,
        reason,
        recommendedDurationMinutes,
        recommendedIntensity,
        safetyNote,
        bestTime,
        rank,
      ];
}

class FoodRecommendationEntity extends Equatable {
  final String foodId;
  final String foodName;
  final String description;
  final double price;
  final String currency;
  final double calories;
  final double carbsGrams;
  final double proteinGrams;
  final double fatGrams;
  final String reason;
  final String nutritionHighlight;
  final String portionSuggestion;
  final int rank;

  const FoodRecommendationEntity({
    required this.foodId,
    required this.foodName,
    required this.description,
    required this.price,
    required this.currency,
    required this.calories,
    required this.carbsGrams,
    required this.proteinGrams,
    required this.fatGrams,
    required this.reason,
    required this.nutritionHighlight,
    required this.portionSuggestion,
    required this.rank,
  });

  @override
  List<Object?> get props => [
        foodId,
        foodName,
        description,
        price,
        currency,
        calories,
        carbsGrams,
        proteinGrams,
        fatGrams,
        reason,
        nutritionHighlight,
        portionSuggestion,
        rank,
      ];
}
