import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glupulse/features/orders/domain/usecases/get_order_history_usecase.dart';
import 'package:glupulse/features/orders/presentation/cubit/order_history_state.dart';

class OrderHistoryCubit extends Cubit<OrderHistoryState> {
  final GetOrderHistoryUseCase getOrderHistoryUseCase;

  OrderHistoryCubit({required this.getOrderHistoryUseCase}) : super(OrderHistoryInitial());

  Future<void> fetchOrderHistory({int limit = 10, int offset = 0}) async {
    emit(OrderHistoryLoading());
    final result = await getOrderHistoryUseCase(limit: limit, offset: offset);
    result.fold(
      (failure) => emit(OrderHistoryError(failure.message)),
      (orders) {
        if (orders.isEmpty) {
          emit(OrderHistoryEmpty());
        } else {
          emit(OrderHistoryLoaded(orders: orders));
        }
      },
    );
  }
}
