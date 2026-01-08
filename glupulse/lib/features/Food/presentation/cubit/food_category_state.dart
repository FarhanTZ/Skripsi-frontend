import 'package:equatable/equatable.dart';
import 'package:glupulse/features/Food/domain/entities/food_category.dart';

abstract class FoodCategoryState extends Equatable {
  const FoodCategoryState();

  @override
  List<Object> get props => [];
}

class FoodCategoryInitial extends FoodCategoryState {}

class FoodCategoryLoading extends FoodCategoryState {}

class FoodCategoryLoaded extends FoodCategoryState {
  final List<FoodCategory> categories;

  const FoodCategoryLoaded({required this.categories});

  @override
  List<Object> get props => [categories];
}

class FoodCategoryError extends FoodCategoryState {
  final String message;

  const FoodCategoryError({required this.message});

  @override
  List<Object> get props => [message];
}
