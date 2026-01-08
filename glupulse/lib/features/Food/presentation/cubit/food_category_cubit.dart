import 'package:bloc/bloc.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/Food/domain/usecases/get_food_categories.dart';
import 'package:glupulse/features/Food/presentation/cubit/food_category_state.dart';

class FoodCategoryCubit extends Cubit<FoodCategoryState> {
  final GetFoodCategories getFoodCategoriesUseCase;

  FoodCategoryCubit({required this.getFoodCategoriesUseCase}) : super(FoodCategoryInitial());

  Future<void> fetchFoodCategories() async {
    emit(FoodCategoryLoading());
    final failureOrCategories = await getFoodCategoriesUseCase(NoParams());
    failureOrCategories.fold(
      (failure) => emit(FoodCategoryError(message: _mapFailureToMessage(failure))),
      (categories) => emit(FoodCategoryLoaded(categories: categories)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    }
    return 'Gagal memuat kategori. Periksa koneksi internet Anda.';
  }
}
