import 'package:dartz/dartz.dart' hide Order; // Hide Order from dartz
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/features/orders/domain/entities/order.dart';

abstract class OrderRepository {
      Future<Either<Failure, List<Order>>> getTrackOrders();
      Future<Either<Failure, List<Order>>> getOrderHistory({int limit = 10, int offset = 0});
    }
    