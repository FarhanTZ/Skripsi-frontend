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
    num? saturatedFatGrams,
    num? monounsaturatedFatGrams,
    num? polyunsaturatedFatGrams,
    num? cholesterolMg,
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
          saturatedFatGrams: saturatedFatGrams,
          monounsaturatedFatGrams: monounsaturatedFatGrams,
          polyunsaturatedFatGrams: polyunsaturatedFatGrams,
          cholesterolMg: cholesterolMg,
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
      saturatedFatGrams: json['saturated_fat_grams'],
      monounsaturatedFatGrams: json['monounsaturated_fat_grams'],
      polyunsaturatedFatGrams: json['polyunsaturated_fat_grams'],
      cholesterolMg: json['cholesterol_mg'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_id': itemId, // Keep this nullable or remove if create only
      'meal_id': mealId, // Keep this nullable or remove if create only
      'food_name': foodName,
      'food_id': foodId ?? "", // Empty string if null (manual input)
      'seller': seller ?? "", // Empty string if null
      'serving_size': servingSize ?? "", // Empty string if null
      'serving_size_grams': servingSizeGrams ?? 0, // Default to 0 if null
      'quantity': quantity,
      'calories': calories ?? 0,
      'carbs_grams': carbsGrams ?? 0,
      'protein_grams': proteinGrams ?? 0,
      'fat_grams': fatGrams ?? 0,
      'fiber_grams': fiberGrams ?? 0,
      'sugar_grams': sugarGrams ?? 0,
      'sodium_mg': sodiumMg ?? 0,
      'glycemic_index': glycemicIndex ?? 0,
      'glycemic_load': glycemicLoad ?? 0,
      'food_category': foodCategory ?? "", // Empty string if null
      'saturated_fat_grams': saturatedFatGrams ?? 0,
      'monounsaturated_fat_grams': monounsaturatedFatGrams ?? 0,
      'polyunsaturated_fat_grams': polyunsaturatedFatGrams ?? 0,
      'cholesterol_mg': cholesterolMg ?? 0,
      // created_at is usually server-generated, can be omitted or kept if needed
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }
}