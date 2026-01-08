import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/features/seller/domain/entities/seller.dart';

abstract class SellerRepository {
  Future<Either<Failure, Seller>> getSellerById(String sellerId);
}
