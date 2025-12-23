import 'package:dartz/dartz.dart' hide Order;
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/features/orders/domain/entities/order.dart';
import 'package:glupulse/features/orders/domain/repositories/order_repository.dart';

class GetOrderHistoryUseCase {
  final OrderRepository repository;

  GetOrderHistoryUseCase(this.repository);

  Future<Either<Failure, List<Order>>> call({int limit = 10, int offset = 0}) async {
    return await repository.getOrderHistory(limit: limit, offset: offset);
  }
}
