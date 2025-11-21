import 'package:equatable/equatable.dart';

class Food extends Equatable {
  final String foodId;
  final String sellerId;
  final String foodName;
  final String description;
  final int price;
  final String currency;
  final String? photoUrl;
  final String? thumbnailUrl;
  final bool isAvailable;
  final int? stockCount;
  final List<String>? tags;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? servingSizeG;
  final int? calories;
  final double? proteinG;
  final double? fatG;
  final double? carbohydrateG;
  final double? sodiumMg;

  const Food({
    required this.foodId,
    required this.sellerId,
    required this.foodName,
    required this.description,
    required this.price,
    required this.currency,
    this.photoUrl,
    this.thumbnailUrl,
    required this.isAvailable,
    this.stockCount,
    this.tags,
    required this.createdAt,
    required this.updatedAt,
    this.servingSizeG,
    this.calories,
    this.proteinG,
    this.fatG,
    this.carbohydrateG,
    this.sodiumMg,
  });

  @override
  List<Object?> get props => [
        foodId,
        sellerId,
        foodName,
        description,
        price,
        currency,
        photoUrl,
        thumbnailUrl,
        isAvailable,
        stockCount,
        tags,
        createdAt,
        updatedAt,
        servingSizeG,
        calories,
        proteinG,
        fatG,
        carbohydrateG,
        sodiumMg,
      ];
}