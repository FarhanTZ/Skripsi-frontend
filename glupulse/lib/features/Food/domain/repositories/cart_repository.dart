import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/failures.dart';

import 'package:glupulse/features/Food/domain/entities/cart.dart';

abstract class CartRepository {
  Future<Either<Failure, Cart>> getCart();
  Future<Either<Failure, void>> addToCart(String foodId, int quantity);
}