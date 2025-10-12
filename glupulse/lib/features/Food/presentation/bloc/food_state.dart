part of 'food_bloc.dart';

abstract class FoodState extends Equatable {
  const FoodState();  

  @override
  List<Object> get props => [];
}
class FoodInitial extends FoodState {}
