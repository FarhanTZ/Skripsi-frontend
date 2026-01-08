import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/Food/domain/entities/cart.dart';
import 'package:glupulse/features/Food/domain/usecases/add_to_cart_usecase.dart';
import 'package:glupulse/features/Food/domain/usecases/get_cart_usecase.dart';
import 'package:glupulse/features/Food/domain/usecases/remove_cart_item_usecase.dart';
import 'package:glupulse/features/Food/domain/usecases/update_cart_item_usecase.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final GetCartUseCase getCartUseCase;
  final AddToCartUseCase addToCartUseCase;
  final UpdateCartItemUseCase updateCartItemUseCase;
  final RemoveCartItemUseCase removeCartItemUseCase;

  CartCubit({
    required this.getCartUseCase,
    required this.addToCartUseCase,
    required this.updateCartItemUseCase,
    required this.removeCartItemUseCase,
  }) : super(CartInitial());

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

  Future<void> updateItemQuantity(String foodId, int quantity) async {
    // Tidak emit loading agar UI tidak berkedip, listener di page akan handle refresh
    final failureOrSuccess = await updateCartItemUseCase(
        UpdateCartItemParams(foodId: foodId, quantity: quantity));

    failureOrSuccess.fold(
      (failure) => emit(CartError(message: _mapFailureToMessage(failure))),
      (_) => fetchCart(), // Panggil fetchCart lagi untuk refresh data
    );
  }

  Future<void> removeItemFromCart(String foodId) async {
    // Tidak emit loading agar UI tidak berkedip
    final failureOrSuccess =
        await removeCartItemUseCase(RemoveCartItemParams(foodId: foodId));

    failureOrSuccess.fold(
      (failure) => emit(CartError(message: _mapFailureToMessage(failure))),
      (_) => fetchCart(), // Panggil fetchCart lagi untuk refresh data
    );
  }

  String _mapFailureToMessage(Failure failure) {
    // Anda bisa menambahkan logika yang lebih kompleks di sini
    switch (failure.runtimeType) {
      case ServerFailure:
        // Lakukan cast ke ServerFailure untuk bisa mengakses properti 'message'.
        return (failure as ServerFailure).message;
      case CacheFailure:
        return 'Gagal memuat data dari cache.';
      default:
        return 'Terjadi kesalahan yang tidak terduga.';
    }
  }
}