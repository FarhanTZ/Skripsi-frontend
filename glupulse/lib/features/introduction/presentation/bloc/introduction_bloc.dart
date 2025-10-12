import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'introduction_event.dart';
part 'introduction_state.dart';

class IntroductionBloc extends Bloc<IntroductionEvent, IntroductionState> {
  IntroductionBloc() : super(IntroductionInitial()) {
    on<IntroductionEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
