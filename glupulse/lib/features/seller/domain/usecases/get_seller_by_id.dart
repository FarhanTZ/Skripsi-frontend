import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/seller/domain/entities/seller.dart';
import 'package:glupulse/features/seller/domain/repositories/seller_repository.dart';

class GetSellerById implements UseCase<Seller, String> {
  final SellerRepository repository;

  GetSellerById(this.repository);

  @override
  Future<Either<Failure, Seller>> call(String sellerId) async {
    return await repository.getSellerById(sellerId);
  }
}
