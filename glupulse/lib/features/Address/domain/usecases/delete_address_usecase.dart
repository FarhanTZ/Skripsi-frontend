import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/Address/domain/repositories/address_repository.dart';

class DeleteAddressUseCase implements UseCase<void, String> {
  final AddressRepository repository;

  DeleteAddressUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String addressId) async {
    return await repository.deleteAddress(addressId);
  }
}