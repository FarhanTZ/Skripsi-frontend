import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/Food/domain/entities/food.dart';
import 'package:glupulse/features/Food/domain/usecases/get_foods.dart';

part 'food_state.dart';

class FoodCubit extends Cubit<FoodState> {
  final GetFoods getFoodsUseCase;

  FoodCubit({required this.getFoodsUseCase}) : super(FoodInitial());

  Future<void> fetchFoods() async {
    emit(FoodLoading());
    final failureOrFoods = await getFoodsUseCase(NoParams());
    failureOrFoods.fold(
      (failure) => emit(FoodError(message: _mapFailureToMessage(failure))),
      (foods) => emit(FoodLoaded(foods: foods)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    // Anda bisa menambahkan logika untuk pesan error yang lebih spesifik
    return 'Gagal memuat data. Periksa koneksi internet Anda.';
  }
}