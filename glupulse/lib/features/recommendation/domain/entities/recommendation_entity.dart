import 'package:equatable/equatable.dart';

class RecommendationEntity extends Equatable {
  final String sessionId;
  final String analysisSummary;
  final String insightsResponse;
  final List<ActivityRecommendationEntity> activityRecommendations;
  // foodRecommendations is empty in example, but we can structure it if needed. 
  // For now keeping it dynamic or list of strings to avoid complexity if structure is unknown.
  final List<dynamic> foodRecommendations; 

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
  final int metValue;
  final String measurementUnit;
  final int recommendedMinValue;
  final String reason;
  final int recommendedDurationMinutes;
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
