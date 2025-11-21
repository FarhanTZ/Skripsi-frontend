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
    super.servingSizeG,
    super.calories,
    super.proteinG,
    super.fatG,
    super.carbohydrateG,
    super.sodiumMg,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      foodId: json['food_id'],
      sellerId: json['seller_id'],
      foodName: json['food_name'],
      description: json['description'],
      price: (json['price'] as num).toInt(),
      currency: json['currency'],
      photoUrl: json['photo_url'],
      thumbnailUrl: json['thumbnail_url'],
      isAvailable: json['is_available'],
      stockCount: (json['stock_count'] as num?)?.toInt(),
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      servingSizeG: (json['serving_size_g'] as num?)?.toInt(),
      calories: (json['calories'] as num?)?.toInt(),
      proteinG: (json['protein_g'] as num?)?.toDouble(),
      fatG: (json['fat_g'] as num?)?.toDouble(),
      carbohydrateG: (json['carbohydrate_g'] as num?)?.toDouble(),
      sodiumMg: (json['sodium_mg'] as num?)?.toDouble(),
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
      'serving_size_g': servingSizeG,
      'calories': calories,
      'protein_g': proteinG,
      'fat_g': fatG,
      'carbohydrate_g': carbohydrateG,
      'sodium_mg': sodiumMg,
    };
  }
}