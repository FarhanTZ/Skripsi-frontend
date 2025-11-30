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
  
  // Nutrition & Detail Fields
  final String? servingSize;
  final num? servingSizeGrams;
  final num? quantity;
  final num? calories;
  final num? carbsGrams;
  final num? fiberGrams;
  final num? proteinGrams;
  final num? fatGrams;
  final num? sugarGrams;
  final num? sodiumMg;
  final num? glycemicIndex;
  final num? glycemicLoad;
  final String? foodCategory;

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
    this.servingSize,
    this.servingSizeGrams,
    this.quantity,
    this.calories,
    this.carbsGrams,
    this.fiberGrams,
    this.proteinGrams,
    this.fatGrams,
    this.sugarGrams,
    this.sodiumMg,
    this.glycemicIndex,
    this.glycemicLoad,
    this.foodCategory,
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
        servingSize,
        servingSizeGrams,
        quantity,
        calories,
        carbsGrams,
        fiberGrams,
        proteinGrams,
        fatGrams,
        sugarGrams,
        sodiumMg,
        glycemicIndex,
        glycemicLoad,
        foodCategory,
      ];
}
