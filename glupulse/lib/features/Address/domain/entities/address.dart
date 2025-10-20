import 'package:equatable/equatable.dart';

class Address extends Equatable {
  final String label;
  final String addressDetail;
  final double latitude;
  final double longitude;

  const Address({
    required this.label,
    required this.addressDetail,
    required this.latitude,
    required this.longitude,
  });

  // Helper untuk membuat objek dari Map, dengan nilai default yang aman
  factory Address.fromMap(Map<String, String> map) {
    return Address(
      label: map['label'] ?? 'Lokasi',
      addressDetail: map['address'] ?? 'Alamat tidak tersedia',
      latitude: double.tryParse(map['latitude'] ?? '-6.9740') ?? -6.9740,
      longitude: double.tryParse(map['longitude'] ?? '107.6304') ?? 107.6304,
    );
  }

  // Helper untuk mengubah objek Address menjadi Map
  Map<String, String> toMap() {
    return {
      'label': label,
      'address': addressDetail,
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
    };
  }

  // Method untuk membuat salinan objek Address dengan nilai yang diperbarui
  Address copyWith({
    String? label,
    String? addressDetail,
    double? latitude,
    double? longitude,
  }) {
    return Address(
      label: label ?? this.label,
      addressDetail: addressDetail ?? this.addressDetail,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  List<Object?> get props => [label, addressDetail, latitude, longitude];
}