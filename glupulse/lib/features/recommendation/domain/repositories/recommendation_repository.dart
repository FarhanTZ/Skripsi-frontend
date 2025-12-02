import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/failures.dart';
import '../entities/recommendation_entity.dart';

abstract class RecommendationRepository {
  Future<Either<Failure, RecommendationEntity>> getRecommendation(Map<String, dynamic> requestData);
}
