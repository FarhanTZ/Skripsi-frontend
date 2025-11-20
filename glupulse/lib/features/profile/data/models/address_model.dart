import 'package:equatable/equatable.dart';

class AddressModel extends Equatable {
  final String addressId;
  final String userId;
  final String? addressLine1;
  final String? addressLine2;
  final String? addressCity;
  final String? addressProvince;
  final String? addressDistrict;
  final String? addressPostalcode;
  final double? addressLatitude;
  final double? addressLongitude;
  final String? addressLabel;
  final String? recipientName;
  final String? recipientPhone;
  final String? deliveryNotes;
  final bool isDefault;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AddressModel({
    required this.addressId,
    required this.userId,
    this.addressLine1,
    this.addressLine2,
    this.addressCity,
    this.addressProvince,
    this.addressDistrict,
    this.addressPostalcode,
    this.addressLatitude,
    this.addressLongitude,
    this.addressLabel,
    this.recipientName,
    this.recipientPhone,
    this.deliveryNotes,
    required this.isDefault,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [addressId, userId, addressDistrict];

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      addressId: json['address_id'] as String,
      userId: json['user_id'] as String,
      addressLine1: json['address_line1'] as String?,
      addressLine2: json['address_line2'] as String?,
      addressCity: json['address_city'] as String?,
      addressDistrict: json['address_district'] as String?,
      addressProvince: json['address_province'] as String?,
      addressPostalcode: json['address_postalcode'] as String?,
      addressLatitude: (json['address_latitude'] as num?)?.toDouble(),
      addressLongitude: (json['address_longitude'] as num?)?.toDouble(),
      addressLabel: json['address_label'] as String?,
      recipientName: json['recipient_name'] as String?,
      recipientPhone: json['recipient_phone'] as String?,
      deliveryNotes: json['delivery_notes'] as String?,
      isDefault: json['is_default'] ?? false,
      isActive: json['is_active'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  AddressModel copyWith({
    String? addressId,
    String? userId,
    String? addressLine1,
    String? addressLine2,
    String? addressCity,
    String? addressProvince,
    String? addressDistrict,
    String? addressPostalcode,
    double? addressLatitude,
    double? addressLongitude,
    String? addressLabel,
    String? recipientName,
    String? recipientPhone,
    String? deliveryNotes,
    bool? isDefault,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AddressModel(
      addressId: addressId ?? this.addressId,
      userId: userId ?? this.userId,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      addressCity: addressCity ?? this.addressCity,
      addressDistrict: addressDistrict ?? this.addressDistrict,
      addressProvince: addressProvince ?? this.addressProvince,
      addressPostalcode: addressPostalcode ?? this.addressPostalcode,
      addressLatitude: addressLatitude ?? this.addressLatitude,
      addressLongitude: addressLongitude ?? this.addressLongitude,
      addressLabel: addressLabel ?? this.addressLabel,
      recipientName: recipientName ?? this.recipientName,
      recipientPhone: recipientPhone ?? this.recipientPhone,
      deliveryNotes: deliveryNotes ?? this.deliveryNotes,
      isDefault: isDefault ?? this.isDefault,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}