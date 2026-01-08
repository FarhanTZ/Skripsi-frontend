import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/features/Address/domain/usecases/add_address_usecase.dart';
import 'package:glupulse/features/Address/domain/usecases/update_address_usecase.dart';

abstract class AddressRepository {
  Future<Either<Failure, void>> addAddress(AddAddressParams params);
  Future<Either<Failure, void>> updateAddress(UpdateAddressParams params);
  Future<Either<Failure, void>> deleteAddress(String addressId);
  Future<Either<Failure, void>> setDefaultAddress(String addressId);
}