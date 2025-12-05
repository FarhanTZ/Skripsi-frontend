import '../../domain/entities/recommendation_entity.dart';

class RecommendationModel extends RecommendationEntity {
  const RecommendationModel({
    required super.sessionId,
    required super.analysisSummary,
    required super.insightsResponse,
    required super.activityRecommendations,
    required super.foodRecommendations,
  });

  factory RecommendationModel.fromJson(Map<String, dynamic> json) {
    // Determine if we are dealing with a detail response (has 'session' key) or a direct session object
    final sessionData = json.containsKey('session') 
        ? (json['session'] as Map<String, dynamic>) 
        : json;

    return RecommendationModel(
      sessionId: sessionData['session_id'] ?? '',
      analysisSummary: sessionData['analysis_summary'] ?? '',
      insightsResponse: sessionData['insights_response'] ?? '',
      
      // Try to find activities in 'activities' (detail) OR 'activity_recommendations' (list/legacy)
      activityRecommendations: (json['activities'] as List<dynamic>?)
              ?.map((e) => ActivityRecommendationModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          (sessionData['activity_recommendations'] as List<dynamic>?)
              ?.map((e) => ActivityRecommendationModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],

      // Try to find foods in 'foods' (detail) OR 'food_recommendations' (list/legacy)
      foodRecommendations: (json['foods'] as List<dynamic>?)
              ?.map((e) => FoodRecommendationModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          (sessionData['food_recommendations'] as List<dynamic>?)
              ?.map((e) => FoodRecommendationModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class ActivityRecommendationModel extends ActivityRecommendationEntity {
  const ActivityRecommendationModel({
    required super.activityId,
    required super.activityCode,
    required super.activityName,
    required super.description,
    required super.imageUrl,
    required super.metValue,
    required super.measurementUnit,
    required super.recommendedMinValue,
    required super.reason,
    required super.recommendedDurationMinutes,
    required super.recommendedIntensity,
    required super.safetyNote,
    required super.bestTime,
    required super.rank,
  });

  factory ActivityRecommendationModel.fromJson(Map<String, dynamic> json) {
    return ActivityRecommendationModel(
      activityId: json['activity_id'] ?? 0,
      activityCode: json['activity_code'] ?? '',
      activityName: json['activity_name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? '',
      metValue: (json['met_value'] as num?)?.toDouble() ?? 0.0,
      measurementUnit: json['measurement_unit'] ?? '',
      recommendedMinValue: (json['recommended_min_value'] as num?)?.toDouble() ?? 0.0,
      reason: json['reason'] ?? '',
      recommendedDurationMinutes: (json['recommended_duration_minutes'] as num?)?.toDouble() ?? 0.0,
      recommendedIntensity: json['recommended_intensity'] ?? '',
      safetyNote: json['safety_note'] ?? '',
      bestTime: json['best_time'] ?? '',
      rank: json['rank'] ?? 0,
    );
  }
}

class FoodRecommendationModel extends FoodRecommendationEntity {
  const FoodRecommendationModel({
    required super.foodId,
    required super.foodName,
    required super.description,
    required super.price,
    required super.currency,
    required super.calories,
    required super.carbsGrams,
    required super.proteinGrams,
    required super.fatGrams,
    required super.reason,
    required super.nutritionHighlight,
    required super.portionSuggestion,
    required super.rank,
  });

  factory FoodRecommendationModel.fromJson(Map<String, dynamic> json) {
    return FoodRecommendationModel(
      foodId: json['food_id'] ?? '',
      foodName: json['food_name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] ?? '',
      calories: (json['calories'] as num?)?.toDouble() ?? 0.0,
      carbsGrams: (json['carbs_grams'] as num?)?.toDouble() ?? 0.0,
      proteinGrams: (json['protein_grams'] as num?)?.toDouble() ?? 0.0,
      fatGrams: (json['fat_grams'] as num?)?.toDouble() ?? 0.0,
      reason: json['reason'] ?? '',
      nutritionHighlight: json['nutrition_highlight'] ?? '',
      portionSuggestion: json['portion_suggestion'] ?? '',
      rank: json['rank'] ?? 0,
    );
  }
}
