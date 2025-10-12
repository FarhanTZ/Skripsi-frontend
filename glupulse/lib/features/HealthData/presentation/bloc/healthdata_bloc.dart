import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'healthdata_event.dart';
part 'healthdata_state.dart';

class HealthdataBloc extends Bloc<HealthdataEvent, HealthdataState> {
  HealthdataBloc() : super(HealthdataInitial()) {
    on<HealthdataEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
