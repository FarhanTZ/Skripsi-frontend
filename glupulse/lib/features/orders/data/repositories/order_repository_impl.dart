import 'package:dartz/dartz.dart' hide Order; // Hide Order from dartz
import 'package:glupulse/core/error/exceptions.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/network/network_info.dart';
import 'package:glupulse/features/orders/data/datasources/order_remote_data_source.dart';
import 'package:glupulse/features/orders/domain/entities/order.dart';
import 'package:glupulse/features/orders/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  OrderRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Order>>> getTrackOrders() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteOrders = await remoteDataSource.getTrackOrders();
        return Right(remoteOrders);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(ConnectionFailure('No internet connection'));
    }
  }

      @override

      Future<Either<Failure, List<Order>>> getOrderHistory({int limit = 10, int offset = 0}) async {

        if (await networkInfo.isConnected) {

          try {

            final remoteOrders = await remoteDataSource.getOrderHistory(limit: limit, offset: offset);

            return Right(remoteOrders);

          } on ServerException catch (e) {

            return Left(ServerFailure(e.message));

          }

        } else {

          return const Left(ConnectionFailure('No internet connection'));

        }

      }

    }

    

  