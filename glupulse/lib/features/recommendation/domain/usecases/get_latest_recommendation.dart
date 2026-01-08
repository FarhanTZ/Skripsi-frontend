import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/failures.dart';
import '../entities/recommendation_entity.dart';
import '../repositories/recommendation_repository.dart';

class GetLatestRecommendation {
  final RecommendationRepository repository;

  GetLatestRecommendation(this.repository);

  Future<Either<Failure, RecommendationEntity>> call() async {
    return await repository.getLatestRecommendation();
  }
}
