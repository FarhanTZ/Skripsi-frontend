import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/features/Food/domain/entities/cart.dart';
import 'package:glupulse/features/Food/domain/entities/food.dart';

abstract class FoodRepository {
  Future<Either<Failure, List<Food>>> getFoods();
  Future<Either<Failure, Cart>> getCart();
  Future<Either<Failure, void>> addToCart(String foodId, int quantity);
  Future<Either<Failure, void>> updateCartItem(String foodId, int quantity);
  Future<Either<Failure, void>> removeCartItem(String foodId);
  Future<Either<Failure, void>> checkout(String addressId, String paymentMethod);
}