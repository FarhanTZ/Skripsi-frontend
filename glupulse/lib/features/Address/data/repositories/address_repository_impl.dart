import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/exceptions.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/features/Address/data/datasources/address_remote_data_source.dart';
import 'package:glupulse/features/Address/domain/repositories/address_repository.dart';
import 'package:glupulse/features/Address/domain/usecases/add_address_usecase.dart';
import 'package:glupulse/features/Address/domain/usecases/update_address_usecase.dart';

class AddressRepositoryImpl implements AddressRepository {
  final AddressRemoteDataSource remoteDataSource;

  AddressRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> addAddress(AddAddressParams params) async {
    try {
      // Panggil metode dari remote data source
      await remoteDataSource.addAddress(params);
      // Jika berhasil, kembalikan Right(unit) yang menandakan void/sukses
      return const Right(null);
    } on ServerException catch (e) {
      // Jika terjadi ServerException, kembalikan ServerFailure
      return Left(ServerFailure(e.message));
    } catch (e) {
      // Untuk error lainnya, kembalikan ServerFailure umum
      return Left(ServerFailure('Terjadi kesalahan tidak terduga.'));
    }
  }

  @override
  Future<Either<Failure, void>> updateAddress(UpdateAddressParams params) async {
    try {
      await remoteDataSource.updateAddress(params);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Terjadi kesalahan tidak terduga.'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAddress(String addressId) async {
    try {
      await remoteDataSource.deleteAddress(addressId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Terjadi kesalahan tidak terduga.'));
    }
  }

  @override
  Future<Either<Failure, void>> setDefaultAddress(String addressId) async {
    try {
      await remoteDataSource.setDefaultAddress(addressId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Terjadi kesalahan tidak terduga.'));
    }
  }
}