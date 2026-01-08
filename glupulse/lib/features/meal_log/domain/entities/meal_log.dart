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
  final num? saturatedFatGrams;
  final num? monounsaturatedFatGrams;
  final num? polyunsaturatedFatGrams;
  final num? cholesterolMg;

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
    this.saturatedFatGrams,
    this.monounsaturatedFatGrams,
    this.polyunsaturatedFatGrams,
    this.cholesterolMg,
  });

  MealItem copyWith({
    String? itemId,
    String? mealId,
    String? foodName,
    String? foodId,
    String? seller,
    String? servingSize,
    num? servingSizeGrams,
    num? quantity,
    num? calories,
    num? carbsGrams,
    num? fiberGrams,
    num? proteinGrams,
    num? fatGrams,
    num? sugarGrams,
    num? sodiumMg,
    num? glycemicIndex,
    num? glycemicLoad,
    String? foodCategory,
    DateTime? createdAt,
    num? saturatedFatGrams,
    num? monounsaturatedFatGrams,
    num? polyunsaturatedFatGrams,
    num? cholesterolMg,
  }) {
    return MealItem(
      itemId: itemId ?? this.itemId,
      mealId: mealId ?? this.mealId,
      foodName: foodName ?? this.foodName,
      foodId: foodId ?? this.foodId,
      seller: seller ?? this.seller,
      servingSize: servingSize ?? this.servingSize,
      servingSizeGrams: servingSizeGrams ?? this.servingSizeGrams,
      quantity: quantity ?? this.quantity,
      calories: calories ?? this.calories,
      carbsGrams: carbsGrams ?? this.carbsGrams,
      fiberGrams: fiberGrams ?? this.fiberGrams,
      proteinGrams: proteinGrams ?? this.proteinGrams,
      fatGrams: fatGrams ?? this.fatGrams,
      sugarGrams: sugarGrams ?? this.sugarGrams,
      sodiumMg: sodiumMg ?? this.sodiumMg,
      glycemicIndex: glycemicIndex ?? this.glycemicIndex,
      glycemicLoad: glycemicLoad ?? this.glycemicLoad,
      foodCategory: foodCategory ?? this.foodCategory,
      createdAt: createdAt ?? this.createdAt,
      saturatedFatGrams: saturatedFatGrams ?? this.saturatedFatGrams,
      monounsaturatedFatGrams: monounsaturatedFatGrams ?? this.monounsaturatedFatGrams,
      polyunsaturatedFatGrams: polyunsaturatedFatGrams ?? this.polyunsaturatedFatGrams,
      cholesterolMg: cholesterolMg ?? this.cholesterolMg,
    );
  }

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
        saturatedFatGrams,
        monounsaturatedFatGrams,
        polyunsaturatedFatGrams,
        cholesterolMg,
      ];
}
