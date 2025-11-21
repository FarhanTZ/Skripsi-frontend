import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/exceptions.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/features/Food/data/datasources/food_remote_data_source.dart';
import 'package:glupulse/features/Food/domain/entities/food.dart';
import 'package:glupulse/features/Food/domain/repositories/food_repository.dart';

class FoodRepositoryImpl implements FoodRepository {
  final FoodRemoteDataSource remoteDataSource;

  FoodRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Food>>> getFoods() async {
    try {
      final remoteFoods = await remoteDataSource.getFoods();
      return Right(remoteFoods);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}