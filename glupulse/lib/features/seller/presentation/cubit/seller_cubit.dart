import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/features/seller/domain/usecases/get_seller_by_id.dart';
import 'package:glupulse/features/seller/presentation/cubit/seller_state.dart';

class SellerCubit extends Cubit<SellerState> {
  final GetSellerById getSellerById;

  SellerCubit({required this.getSellerById}) : super(SellerInitial());

  Future<void> fetchSeller(String sellerId) async {
    emit(SellerLoading());
    final result = await getSellerById(sellerId);
    result.fold(
      (failure) => emit(SellerError(message: _mapFailureToMessage(failure))),
      (seller) => emit(SellerLoaded(seller: seller)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    }
    return 'Unexpected Error';
  }
}
