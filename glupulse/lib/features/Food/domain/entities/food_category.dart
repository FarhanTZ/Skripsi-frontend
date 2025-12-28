import 'package:equatable/equatable.dart';

class FoodCategory extends Equatable {
  final int categoryId;
  final String categoryCode;
  final String displayName;
  final String? description;

  const FoodCategory({
    required this.categoryId,
    required this.categoryCode,
    required this.displayName,
    this.description,
  });

  @override
  List<Object?> get props => [categoryId, categoryCode, displayName, description];
}
