import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/Food/domain/entities/cart.dart';
import 'package:glupulse/features/Food/domain/repositories/cart_repository.dart';


class GetCartUseCase implements UseCase<Cart, NoParams> {
  final CartRepository repository;

  GetCartUseCase(this.repository);

  @override
  Future<Either<Failure, Cart>> call(NoParams params) async {
    return await repository.getCart();
  }
}