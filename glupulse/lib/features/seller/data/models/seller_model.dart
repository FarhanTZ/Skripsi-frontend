import 'package:glupulse/features/seller/domain/entities/seller.dart';

class SellerModel extends Seller {
  const SellerModel({
    required super.sellerId,
    required super.storeName,
    super.storeDescription,
    super.storePhoneNumber,
    required super.isOpen,
    super.addressLine1,
    super.city,
    super.province,
    super.latitude,
    super.longitude,
    required super.averageRating,
    required super.reviewCount,
    super.logoUrl,
    super.bannerUrl,
    required super.cuisineType,
  });

  factory SellerModel.fromJson(Map<String, dynamic> json) {
    num? parseNum(dynamic value) {
      if (value == null) return null;
      if (value is num) return value;
      if (value is String) return num.tryParse(value);
      return null;
    }

    return SellerModel(
      sellerId: json['seller_id']?.toString() ?? '',
      storeName: json['store_name']?.toString() ?? '',
      storeDescription: json['store_description']?.toString(),
      storePhoneNumber: json['store_phone_number']?.toString(),
      isOpen: json['is_open'] ?? false,
      addressLine1: json['address_line1']?.toString(),
      city: json['city']?.toString(),
      province: json['province']?.toString(),
      latitude: parseNum(json['latitude'])?.toDouble(),
      longitude: parseNum(json['longitude'])?.toDouble(),
      averageRating: parseNum(json['average_rating'])?.toDouble() ?? 0.0,
      reviewCount: parseNum(json['review_count'])?.toInt() ?? 0,
      logoUrl: json['logo_url']?.toString(),
      bannerUrl: json['banner_url']?.toString(),
      cuisineType: json['cuisine_type'] != null
          ? List<String>.from(json['cuisine_type'].map((x) => x.toString()))
          : [],
    );
  }
}
