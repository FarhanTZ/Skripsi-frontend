import 'package:equatable/equatable.dart';

class MealLog extends Equatable {
  final String? mealId;
  final String? userId;
  final DateTime mealTimestamp;
  final int mealTypeId;
  final String? description;
  final num? totalCalories;
  final num? totalCarbsGrams;
  final num? totalProteinGrams;
  final num? totalFatGrams;
  final num? totalFiberGrams;
  final num? totalSugarGrams;
  final List<String>? tags;
  final List<MealItem>? items;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const MealLog({
    this.mealId,
    this.userId,
    required this.mealTimestamp,
    required this.mealTypeId,
    this.description,
    this.totalCalories,
    this.totalCarbsGrams,
    this.totalProteinGrams,
    this.totalFatGrams,
    this.totalFiberGrams,
    this.totalSugarGrams,
    this.tags,
    this.items,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        mealId,
        userId,
        mealTimestamp,
        mealTypeId,
        description,
        totalCalories,
        totalCarbsGrams,
        totalProteinGrams,
        totalFatGrams,
        totalFiberGrams,
        totalSugarGrams,
        tags,
        items,
        createdAt,
        updatedAt,
      ];
}

class MealItem extends Equatable {
  final String? itemId;
  final String? mealId;
  final String foodName;
  final String? foodId;
  final String? seller;
  final String? servingSize;
  final num? servingSizeGrams;
  final num quantity;
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
  final DateTime? createdAt;

  const MealItem({
    this.itemId,
    this.mealId,
    required this.foodName,
    this.foodId,
    this.seller,
    this.servingSize,
    this.servingSizeGrams,
    required this.quantity,
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
    this.createdAt,
  });

  @override
  List<Object?> get props => [
        itemId,
        mealId,
        foodName,
        foodId,
        seller,
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
        createdAt,
      ];
}
