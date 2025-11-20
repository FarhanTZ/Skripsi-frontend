import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/Address/domain/repositories/address_repository.dart';


class AddAddressUseCase implements UseCase<void, AddAddressParams> {
  final AddressRepository repository;

  AddAddressUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(AddAddressParams params) async {
    return await repository.addAddress(params);
  }
}

class AddAddressParams extends Equatable {
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
  final double addressLatitude;
  final double addressLongitude;

  const AddAddressParams({
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
    required this.addressLatitude,
    required this.addressLongitude,
  });

  @override
  List<Object?> get props => [addressLabel, isDefault, recipientName, recipientPhone, addressLine1, addressLine2, addressCity, addressPostalcode, addressDistrict, addressProvince, deliveryNotes, addressLatitude, addressLongitude];

  Map<String, dynamic> toJson() => {
        "address_label": addressLabel,
        "is_default": isDefault,
        "recipient_name": recipientName,
        "recipient_phone": recipientPhone,
        "address_line1": addressLine1,
        "address_line2": addressLine2,
        "address_city": addressCity,
        "address_postalcode": addressPostalcode,
        "address_district": addressDistrict,
        "address_province": addressProvince,
        "delivery_notes": deliveryNotes,
        "address_latitude": addressLatitude,
        "address_longitude": addressLongitude,
      };
}