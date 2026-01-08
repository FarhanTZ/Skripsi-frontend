import 'package:bloc/bloc.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/features/Food/domain/usecases/checkout_usecase.dart';
import 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final CheckoutUseCase checkoutUseCase;

  CheckoutCubit({required this.checkoutUseCase}) : super(CheckoutInitial());

  Future<void> submitCheckout({
    required String addressId,
    required String paymentMethod,
  }) async {
    emit(CheckoutLoading());
    final result = await checkoutUseCase(CheckoutParams(
      addressId: addressId,
      paymentMethod: paymentMethod,
    ));

    result.fold(
      (failure) => emit(CheckoutError(message: _mapFailureToMessage(failure))),
      (orderId) => emit(CheckoutSuccess(orderId: orderId)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    }
    return 'Unexpected Error';
  }
}
