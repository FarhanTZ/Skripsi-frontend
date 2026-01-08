import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/exceptions.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/network/network_info.dart';
import 'package:glupulse/features/seller/data/datasources/seller_remote_data_source.dart';
import 'package:glupulse/features/seller/domain/entities/seller.dart';
import 'package:glupulse/features/seller/domain/repositories/seller_repository.dart';

class SellerRepositoryImpl implements SellerRepository {
  final SellerRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  SellerRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Seller>> getSellerById(String sellerId) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteSeller = await remoteDataSource.getSellerById(sellerId);
        return Right(remoteSeller);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ConnectionFailure('No internet connection'));
    }
  }
}
