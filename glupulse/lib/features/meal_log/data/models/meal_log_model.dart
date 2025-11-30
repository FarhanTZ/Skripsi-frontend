import 'package:glupulse/features/meal_log/data/models/meal_item_model.dart';
import 'package:glupulse/features/meal_log/domain/entities/meal_log.dart';

class MealLogModel extends MealLog {
  const MealLogModel({
    String? mealId,
    String? userId,
    required DateTime mealTimestamp,
    required int mealTypeId,
    String? description,
    num? totalCalories,
    num? totalCarbsGrams,
    num? totalProteinGrams,
    num? totalFatGrams,
    num? totalFiberGrams,
    num? totalSugarGrams,
    List<String>? tags,
    List<MealItemModel>? items,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(
          mealId: mealId,
          userId: userId,
          mealTimestamp: mealTimestamp,
          mealTypeId: mealTypeId,
          description: description,
          totalCalories: totalCalories,
          totalCarbsGrams: totalCarbsGrams,
          totalProteinGrams: totalProteinGrams,
          totalFatGrams: totalFatGrams,
          totalFiberGrams: totalFiberGrams,
          totalSugarGrams: totalSugarGrams,
          tags: tags,
          items: items,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory MealLogModel.fromJson(Map<String, dynamic> json) {
    return MealLogModel(
      mealId: json['meal_id'],
      userId: json['user_id'],
      mealTimestamp: DateTime.parse(json['meal_timestamp']),
      mealTypeId: json['meal_type_id'],
      description: json['description'],
      totalCalories: json['total_calories'],
      totalCarbsGrams: json['total_carbs_grams'],
      totalProteinGrams: json['total_protein_grams'],
      totalFatGrams: json['total_fat_grams'],
      totalFiberGrams: json['total_fiber_grams'],
      totalSugarGrams: json['total_sugar_grams'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      items: json['items'] != null
          ? (json['items'] as List)
              .map((item) => MealItemModel.fromJson(item))
              .toList()
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'meal_timestamp': mealTimestamp.toUtc().toIso8601String(),
      'meal_type_id': mealTypeId,
    };

    if (mealId != null) data['meal_id'] = mealId;
    if (userId != null) data['user_id'] = userId;
    if (description != null) data['description'] = description;
    if (totalCalories != null) data['total_calories'] = totalCalories;
    if (totalCarbsGrams != null) data['total_carbs_grams'] = totalCarbsGrams;
    if (totalProteinGrams != null) data['total_protein_grams'] = totalProteinGrams;
    if (totalFatGrams != null) data['total_fat_grams'] = totalFatGrams;
    if (totalFiberGrams != null) data['total_fiber_grams'] = totalFiberGrams;
    if (totalSugarGrams != null) data['total_sugar_grams'] = totalSugarGrams;
    if (tags != null) data['tags'] = tags;
    if (items != null) {
      data['items'] = items!.map((item) => (item as MealItemModel).toJson()).toList();
    }
    // created_at and updated_at are typically read-only, avoid sending unless necessary
    if (createdAt != null) data['created_at'] = createdAt!.toIso8601String();
    if (updatedAt != null) data['updated_at'] = updatedAt!.toIso8601String();

    return data;
  }

  factory MealLogModel.fromEntity(MealLog entity) {
    return MealLogModel(
      mealId: entity.mealId,
      userId: entity.userId,
      mealTimestamp: entity.mealTimestamp,
      mealTypeId: entity.mealTypeId,
      description: entity.description,
      totalCalories: entity.totalCalories,
      totalCarbsGrams: entity.totalCarbsGrams,
      totalProteinGrams: entity.totalProteinGrams,
      totalFatGrams: entity.totalFatGrams,
      totalFiberGrams: entity.totalFiberGrams,
      totalSugarGrams: entity.totalSugarGrams,
      tags: entity.tags,
      items: entity.items
          ?.map((item) => MealItemModel(
                itemId: item.itemId,
                mealId: item.mealId,
                foodName: item.foodName,
                foodId: item.foodId,
                seller: item.seller,
                servingSize: item.servingSize,
                servingSizeGrams: item.servingSizeGrams,
                quantity: item.quantity,
                calories: item.calories,
                carbsGrams: item.carbsGrams,
                fiberGrams: item.fiberGrams,
                proteinGrams: item.proteinGrams,
                fatGrams: item.fatGrams,
                sugarGrams: item.sugarGrams,
                sodiumMg: item.sodiumMg,
                glycemicIndex: item.glycemicIndex,
                glycemicLoad: item.glycemicLoad,
                foodCategory: item.foodCategory,
                createdAt: item.createdAt,
                saturatedFatGrams: item.saturatedFatGrams,
                monounsaturatedFatGrams: item.monounsaturatedFatGrams,
                polyunsaturatedFatGrams: item.polyunsaturatedFatGrams,
                cholesterolMg: item.cholesterolMg,
              ))
          .toList(),
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
