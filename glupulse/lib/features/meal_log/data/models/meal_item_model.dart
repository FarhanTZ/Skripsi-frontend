import 'package:glupulse/features/meal_log/domain/entities/meal_log.dart';

class MealItemModel extends MealItem {
  const MealItemModel({
    String? itemId,
    String? mealId,
    required String foodName,
    String? foodId,
    String? seller,
    String? servingSize,
    num? servingSizeGrams,
    required num quantity,
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
  }) : super(
          itemId: itemId,
          mealId: mealId,
          foodName: foodName,
          foodId: foodId,
          seller: seller,
          servingSize: servingSize,
          servingSizeGrams: servingSizeGrams,
          quantity: quantity,
          calories: calories,
          carbsGrams: carbsGrams,
          fiberGrams: fiberGrams,
          proteinGrams: proteinGrams,
          fatGrams: fatGrams,
          sugarGrams: sugarGrams,
          sodiumMg: sodiumMg,
          glycemicIndex: glycemicIndex,
          glycemicLoad: glycemicLoad,
          foodCategory: foodCategory,
          createdAt: createdAt,
        );

  factory MealItemModel.fromJson(Map<String, dynamic> json) {
    return MealItemModel(
      itemId: json['item_id'],
      mealId: json['meal_id'],
      foodName: json['food_name'],
      foodId: json['food_id'],
      seller: json['seller'],
      servingSize: json['serving_size'],
      servingSizeGrams: json['serving_size_grams'],
      quantity: json['quantity'],
      calories: json['calories'],
      carbsGrams: json['carbs_grams'],
      fiberGrams: json['fiber_grams'],
      proteinGrams: json['protein_grams'],
      fatGrams: json['fat_grams'],
      sugarGrams: json['sugar_grams'],
      sodiumMg: json['sodium_mg'],
      glycemicIndex: json['glycemic_index'],
      glycemicLoad: json['glycemic_load'],
      foodCategory: json['food_category'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_id': itemId,
      'meal_id': mealId,
      'food_name': foodName,
      'food_id': foodId,
      'seller': seller,
      'serving_size': servingSize,
      'serving_size_grams': servingSizeGrams,
      'quantity': quantity,
      'calories': calories,
      'carbs_grams': carbsGrams,
      'fiber_grams': fiberGrams,
      'protein_grams': proteinGrams,
      'fat_grams': fatGrams,
      'sugar_grams': sugarGrams,
      'sodium_mg': sodiumMg,
      'glycemic_index': glycemicIndex,
      'glycemic_load': glycemicLoad,
      'food_category': foodCategory,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
