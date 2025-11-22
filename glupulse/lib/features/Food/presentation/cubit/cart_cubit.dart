import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/Food/data/repositories/add_to_cart_usecase.dart';
import 'package:glupulse/features/Food/domain/entities/cart.dart';
import 'package:glupulse/features/Food/domain/usecases/get_cart_usecase.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final GetCartUseCase getCartUseCase;
  final AddToCartUseCase addToCartUseCase;

  CartCubit({required this.getCartUseCase, required this.addToCartUseCase})
      : super(CartInitial());

  Future<void> fetchCart() async {
    emit(CartLoading());
    final failureOrCart = await getCartUseCase(NoParams());
    failureOrCart.fold(
      (failure) => emit(CartError(message: _mapFailureToMessage(failure))),
      (cart) => emit(CartLoaded(cart: cart)),
    );
  }

  Future<void> addItemToCart(String foodId, int quantity) async {
    emit(CartLoadingAction());
    final failureOrSuccess =
        await addToCartUseCase(AddToCartParams(foodId: foodId, quantity: quantity));

    failureOrSuccess.fold(
      (failure) => emit(CartError(message: _mapFailureToMessage(failure))),
      (_) => emit(CartActionSuccess()),
    );
  }

  String _mapFailureToMessage(dynamic failure) {
    // Anda bisa menambahkan logika yang lebih kompleks di sini
    return failure.message ?? 'An unexpected error occurred';
  }
}