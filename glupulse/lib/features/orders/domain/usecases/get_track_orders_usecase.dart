import 'package:dartz/dartz.dart' hide Order; // Hide Order from dartz
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/features/orders/domain/entities/order.dart';
import 'package:glupulse/features/orders/domain/repositories/order_repository.dart';

class GetTrackOrdersUseCase {
  final OrderRepository repository;

  GetTrackOrdersUseCase(this.repository);

  Future<Either<Failure, List<Order>>> call() async {
    return await repository.getTrackOrders();
  }
}