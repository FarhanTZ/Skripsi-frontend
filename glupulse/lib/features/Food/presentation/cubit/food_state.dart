part of 'food_cubit.dart';

abstract class FoodState extends Equatable {
  const FoodState();

  @override
  List<Object> get props => [];
}

class FoodInitial extends FoodState {}

class FoodLoading extends FoodState {}

class FoodLoaded extends FoodState {
  final List<Food> foods;

  const FoodLoaded({required this.foods});

  @override
  List<Object> get props => [foods];
}

class FoodError extends FoodState {
  final String message;

  const FoodError({required this.message});

  @override
  List<Object> get props => [message];
}