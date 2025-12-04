import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/exceptions.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/network/network_info.dart';
import 'package:glupulse/features/auth/data/datasources/auth_local_data_source.dart';
import '../../domain/entities/recommendation_entity.dart';
import '../../domain/repositories/recommendation_repository.dart';
import '../datasources/recommendation_remote_data_source.dart';

class RecommendationRepositoryImpl implements RecommendationRepository {
  final RecommendationRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  RecommendationRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, RecommendationEntity>> postRecommendation(
      Map<String, dynamic> requestData) async {
    if (await networkInfo.isConnected) {
      try {
        final token = await localDataSource.getLastToken();
        final recommendation =
            await remoteDataSource.postRecommendation(requestData, token);
        return Right(recommendation);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
