import 'package:equatable/equatable.dart';

class OrderAddress extends Equatable {
  final String? addressLabel;
  final String? addressLine1;
  final String? addressLine2;
  final String? deliveryNotes;
  final String? recipientName;
  final String? recipientPhone;
  final double? addressLatitude;
  final double? addressLongitude;

  const OrderAddress({
    this.addressLabel,
    this.addressLine1,
    this.addressLine2,
    this.deliveryNotes,
    this.recipientName,
    this.recipientPhone,
    this.addressLatitude,
    this.addressLongitude,
  });

  @override
  List<Object?> get props => [
        addressLabel,
        addressLine1,
        addressLine2,
        deliveryNotes,
        recipientName,
        recipientPhone,
        addressLatitude,
        addressLongitude,
      ];
}
