import 'package:glupulse/features/orders/domain/entities/order_address.dart';

class OrderAddressModel extends OrderAddress {
  const OrderAddressModel({
    super.addressLabel,
    super.addressLine1,
    super.addressLine2,
    super.deliveryNotes,
    super.recipientName,
    super.recipientPhone,
    super.addressLatitude,
    super.addressLongitude,
  });

  factory OrderAddressModel.fromJson(Map<String, dynamic> json) {
    num? parseNum(dynamic value) {
      if (value == null) return null;
      if (value is num) return value;
      if (value is String) return num.tryParse(value);
      return null;
    }

    return OrderAddressModel(
      addressLabel: json['address_label']?.toString(),
      addressLine1: json['address_line1']?.toString(),
      addressLine2: json['address_line2']?.toString(),
      deliveryNotes: json['delivery_notes']?.toString(),
      recipientName: json['recipient_name']?.toString(),
      recipientPhone: json['recipient_phone']?.toString(),
      addressLatitude: parseNum(json['address_latitude'])?.toDouble(),
      addressLongitude: parseNum(json['address_longitude'])?.toDouble(),
    );
  }
}
