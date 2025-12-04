import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/failures.dart';
import '../entities/recommendation_entity.dart';
import '../repositories/recommendation_repository.dart';

class PostRecommendation {
  final RecommendationRepository repository;

  PostRecommendation(this.repository);

  Future<Either<Failure, RecommendationEntity>> call(Map<String, dynamic> requestData) async {
    return await repository.postRecommendation(requestData);
  }
}
