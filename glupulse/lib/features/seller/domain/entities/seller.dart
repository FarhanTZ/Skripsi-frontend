import 'package:equatable/equatable.dart';

class Seller extends Equatable {
  final String sellerId;
  final String storeName;
  final String? storeDescription;
  final String? storePhoneNumber;
  final bool isOpen;
  final String? addressLine1;
  final String? city;
  final String? province;
  final double? latitude;
  final double? longitude;
  final double averageRating;
  final int reviewCount;
  final String? logoUrl;
  final String? bannerUrl;
  final List<String> cuisineType;

  const Seller({
    required this.sellerId,
    required this.storeName,
    this.storeDescription,
    this.storePhoneNumber,
    required this.isOpen,
    this.addressLine1,
    this.city,
    this.province,
    this.latitude,
    this.longitude,
    required this.averageRating,
    required this.reviewCount,
    this.logoUrl,
    this.bannerUrl,
    required this.cuisineType,
  });

  @override
  List<Object?> get props => [
        sellerId,
        storeName,
        storeDescription,
        storePhoneNumber,
        isOpen,
        addressLine1,
        city,
        province,
        latitude,
        longitude,
        averageRating,
        reviewCount,
        logoUrl,
        bannerUrl,
        cuisineType,
      ];
}
