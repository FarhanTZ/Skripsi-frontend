import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/exceptions.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/network/network_info.dart';
import 'package:glupulse/features/Food/data/datasources/food_remote_data_source.dart';
import 'package:glupulse/features/Food/domain/entities/cart.dart';
import 'package:glupulse/features/Food/domain/entities/food.dart';
import 'package:glupulse/features/Food/domain/repositories/food_repository.dart';

class FoodRepositoryImpl implements FoodRepository {
  final FoodRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  FoodRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Food>>> getFoods() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteFoods = await remoteDataSource.getFoods();
        return Right(remoteFoods);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Cart>> getCart() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteCart = await remoteDataSource.getCart();
        return Right(remoteCart);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addToCart(String foodId, int quantity) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.addToCart(foodId, quantity);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateCartItem(
      String foodId, int quantity) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updateCartItem(foodId, quantity);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, void>> removeCartItem(String foodId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.removeCartItem(foodId);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}