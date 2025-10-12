part of 'healthdata_bloc.dart';

abstract class HealthdataState extends Equatable {
  const HealthdataState();  

  @override
  List<Object> get props => [];
}
class HealthdataInitial extends HealthdataState {}
