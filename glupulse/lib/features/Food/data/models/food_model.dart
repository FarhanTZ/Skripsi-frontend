import 'package:glupulse/features/Food/domain/entities/food.dart';

class FoodModel extends Food {
  const FoodModel({
    required super.foodId,
    required super.sellerId,
    required super.foodName,
    required super.description,
    required super.price,
    required super.currency,
    super.photoUrl,
    super.thumbnailUrl,
    required super.isAvailable,
    super.stockCount,
    super.tags,
    required super.createdAt,
    required super.updatedAt,
    super.servingSize,
    super.servingSizeGrams,
    super.quantity,
    super.calories,
    super.carbsGrams,
    super.fiberGrams,
    super.proteinGrams,
    super.fatGrams,
    super.sugarGrams,
    super.sodiumMg,
    super.glycemicIndex,
    super.glycemicLoad,
    super.foodCategory,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    // Helper function for safe numeric parsing
    num? parseNum(dynamic value) {
      if (value == null) return null;
      if (value is num) return value;
      if (value is String) return num.tryParse(value);
      return null;
    }

    // Helper function for safe string parsing
    String? parseString(dynamic value) {
      if (value == null) return null;
      if (value is String) return value;
      return value.toString(); // Convert other types (like List or int) to String safely
    }

    // Helper specifically for non-nullable strings to avoid "null" string
    String parseStringReq(dynamic value) {
      if (value == null) return '';
      if (value is String) return value;
      return value.toString();
    }

    return FoodModel(
      foodId: parseStringReq(json['food_id']),
      sellerId: parseStringReq(json['seller_id']),
      foodName: parseStringReq(json['food_name']),
      description: parseStringReq(json['description']),
      price: parseNum(json['price'])?.toInt() ?? 0,
      currency: parseStringReq(json['currency']),
      photoUrl: parseString(json['photo_url']),
      thumbnailUrl: parseString(json['thumbnail_url']),
      isAvailable: json['is_available'] == true, // Safe boolean check
      stockCount: parseNum(json['stock_count'])?.toInt(),
      tags: json['tags'] != null 
          ? (json['tags'] as List).map((e) => e.toString()).toList() 
          : null,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? '') ?? DateTime.now(),
      servingSize: parseString(json['serving_size']),
      servingSizeGrams: parseNum(json['serving_size_grams']),
      quantity: parseNum(json['quantity']),
      calories: parseNum(json['calories']),
      carbsGrams: parseNum(json['carbs_grams']),
      fiberGrams: parseNum(json['fiber_grams']),
      proteinGrams: parseNum(json['protein_grams']),
      fatGrams: parseNum(json['fat_grams']),
      sugarGrams: parseNum(json['sugar_grams']),
      sodiumMg: parseNum(json['sodium_mg']),
      glycemicIndex: parseNum(json['glycemic_index']),
      glycemicLoad: parseNum(json['glycemic_load']),
      foodCategory: parseString(json['food_category']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'food_id': foodId,
      'seller_id': sellerId,
      'food_name': foodName,
      'description': description,
      'price': price,
      'currency': currency,
      'photo_url': photoUrl,
      'thumbnail_url': thumbnailUrl,
      'is_available': isAvailable,
      'stock_count': stockCount,
      'tags': tags,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
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
    };
  }
}
