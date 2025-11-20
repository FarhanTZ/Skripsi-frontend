import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/Address/domain/repositories/address_repository.dart';

class UpdateAddressUseCase implements UseCase<void, UpdateAddressParams> {
  final AddressRepository repository;

  UpdateAddressUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateAddressParams params) async {
    return await repository.updateAddress(params);
  }
}

class UpdateAddressParams extends Equatable {
  final String addressId;
  final String addressLabel;
  final bool isDefault;
  final String recipientName;
  final String recipientPhone;
  final String addressLine1;
  final String? addressLine2;
  final String addressCity;
  final String addressPostalcode;
  final String addressDistrict;
  final String addressProvince;
  final String? deliveryNotes;

  const UpdateAddressParams({
    required this.addressId,
    required this.addressLabel,
    required this.isDefault,
    required this.recipientName,
    required this.recipientPhone,
    required this.addressLine1,
    this.addressLine2,
    required this.addressCity,
    required this.addressPostalcode,
    required this.addressDistrict,
    required this.addressProvince,
    this.deliveryNotes,
  });

  @override
  List<Object?> get props => [addressId, addressLabel, isDefault, recipientName, recipientPhone, addressLine1, addressLine2, addressCity, addressPostalcode, addressDistrict, addressProvince, deliveryNotes];

  // Method toJson tidak diperlukan di sini karena akan ditangani di data source,
  // tapi bisa ditambahkan untuk konsistensi jika diinginkan.
}