import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glupulse/features/orders/domain/usecases/get_track_orders_usecase.dart';
import 'package:glupulse/features/orders/presentation/cubit/order_track_state.dart';

class OrderTrackCubit extends Cubit<OrderTrackState> {
  final GetTrackOrdersUseCase getTrackOrdersUseCase;

  OrderTrackCubit({required this.getTrackOrdersUseCase}) : super(OrderTrackInitial());

  Future<void> fetchActiveOrders() async {
    emit(OrderTrackLoading());
    final result = await getTrackOrdersUseCase();
    result.fold(
      (failure) => emit(OrderTrackError(failure.message)),
      (orders) {
        if (orders.isEmpty) {
          emit(OrderTrackEmpty());
        } else {
          emit(OrderTrackLoaded(orders));
        }
      },
    );
  }
}
