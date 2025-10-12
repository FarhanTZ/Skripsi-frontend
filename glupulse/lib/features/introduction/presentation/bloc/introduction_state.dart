part of 'introduction_bloc.dart';

abstract class IntroductionState extends Equatable {
  const IntroductionState();  

  @override
  List<Object> get props => [];
}
class IntroductionInitial extends IntroductionState {}
