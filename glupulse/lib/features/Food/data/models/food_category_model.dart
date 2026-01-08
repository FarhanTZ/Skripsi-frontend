import 'package:glupulse/features/Food/domain/entities/food_category.dart';

class FoodCategoryModel extends FoodCategory {
  const FoodCategoryModel({
    required super.categoryId,
    required super.categoryCode,
    required super.displayName,
    super.description,
  });

  factory FoodCategoryModel.fromJson(Map<String, dynamic> json) {
    return FoodCategoryModel(
      categoryId: json['category_id'],
      categoryCode: json['category_code'],
      displayName: json['display_name'],
      description: json['description'],
    );
  }
}
