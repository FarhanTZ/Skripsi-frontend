import 'package:flutter/foundation.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/meal_log/domain/entities/meal_log.dart';
import 'package:glupulse/features/meal_log/domain/usecases/add_meal_log.dart';
import 'package:glupulse/features/meal_log/domain/usecases/delete_meal_log.dart';
import 'package:glupulse/features/meal_log/domain/usecases/get_meal_log.dart';
import 'package:glupulse/features/meal_log/domain/usecases/get_meal_logs.dart';
import 'package:glupulse/features/meal_log/domain/usecases/update_meal_log.dart';

part 'meal_log_state.dart';

class MealLogCubit extends Cubit<MealLogState> {
  final GetMealLogs getMealLogsUseCase;
  final GetMealLog getMealLogUseCase;
  final AddMealLog addMealLogUseCase;
  final UpdateMealLog updateMealLogUseCase;
  final DeleteMealLog deleteMealLogUseCase;

  MealLogCubit({
    required this.getMealLogsUseCase,
    required this.getMealLogUseCase,
    required this.addMealLogUseCase,
    required this.updateMealLogUseCase,
    required this.deleteMealLogUseCase,
  }) : super(MealLogInitial());

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return (failure as ServerFailure).message;
      default:
        return 'Unexpected error';
    }
  }

  Future<void> getMealLogs() async {
    emit(MealLogLoading());
    final failureOrMealLogs = await getMealLogsUseCase(NoParams());
    emit(
      failureOrMealLogs.fold(
        (failure) => MealLogError(message: _mapFailureToMessage(failure)),
        (mealLogs) => MealLogLoaded(mealLogs: mealLogs),
      ),
    );
  }

  Future<void> getMealLog(String id) async {
    emit(MealLogLoading());
    final failureOrMealLog = await getMealLogUseCase(GetMealLogParams(id: id));
    emit(
      failureOrMealLog.fold(
        (failure) => MealLogError(message: _mapFailureToMessage(failure)),
        (mealLog) => MealLogDetailLoaded(mealLog: mealLog),
      ),
    );
  }

  Future<void> addMealLog(MealLog mealLog) async {
    emit(MealLogLoading());
    final failureOrSuccess =
        await addMealLogUseCase(AddMealLogParams(mealLog: mealLog));
    emit(
      failureOrSuccess.fold(
        (failure) => MealLogError(message: _mapFailureToMessage(failure)),
        (createdLog) => MealLogAdded(mealLog: createdLog),
      ),
    );
  }

  Future<void> updateMealLog(MealLog mealLog) async {
    debugPrint('CUBIT: updateMealLog called');
    emit(MealLogLoading());
    final failureOrSuccess =
        await updateMealLogUseCase(UpdateMealLogParams(mealLog: mealLog));
    debugPrint('CUBIT: updateMealLog result received');
    emit(
      failureOrSuccess.fold(
        (failure) {
          debugPrint('CUBIT: updateMealLog failed: ${_mapFailureToMessage(failure)}');
          return MealLogError(message: _mapFailureToMessage(failure));
        },
        (updatedLog) {
          debugPrint('CUBIT: updateMealLog success');
          return MealLogUpdated();
        },
      ),
    );
  }

  Future<void> deleteMealLog(String id) async {
    emit(MealLogLoading());
    final failureOrSuccess =
        await deleteMealLogUseCase(DeleteMealLogParams(id: id));
    emit(
      failureOrSuccess.fold(
        (failure) => MealLogError(message: _mapFailureToMessage(failure)),
        (_) => MealLogDeleted(),
      ),
    );
  }
}
