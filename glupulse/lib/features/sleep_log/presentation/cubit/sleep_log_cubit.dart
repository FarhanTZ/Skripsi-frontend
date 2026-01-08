import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/sleep_log/domain/entities/sleep_log.dart';
import 'package:glupulse/features/sleep_log/domain/usecases/add_sleep_log.dart';
import 'package:glupulse/features/sleep_log/domain/usecases/delete_sleep_log.dart';
import 'package:glupulse/features/sleep_log/domain/usecases/get_sleep_log.dart';
import 'package:glupulse/features/sleep_log/domain/usecases/get_sleep_logs.dart';
import 'package:glupulse/features/sleep_log/domain/usecases/update_sleep_log.dart';

part 'sleep_log_state.dart';

class SleepLogCubit extends Cubit<SleepLogState> {
  final GetSleepLogs getSleepLogsUseCase;
  final GetSleepLog getSleepLogUseCase;
  final AddSleepLog addSleepLogUseCase;
  final UpdateSleepLog updateSleepLogUseCase;
  final DeleteSleepLog deleteSleepLogUseCase;

  SleepLogCubit({
    required this.getSleepLogsUseCase,
    required this.getSleepLogUseCase,
    required this.addSleepLogUseCase,
    required this.updateSleepLogUseCase,
    required this.deleteSleepLogUseCase,
  }) : super(SleepLogInitial());

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return (failure as ServerFailure).message;
      default:
        return 'Unexpected error';
    }
  }

  Future<void> getSleepLogs() async {
    emit(SleepLogLoading());
    final failureOrSleepLogs = await getSleepLogsUseCase(NoParams());
    emit(
      failureOrSleepLogs.fold(
        (failure) => SleepLogError(message: _mapFailureToMessage(failure)),
        (sleepLogs) => SleepLogLoaded(sleepLogs: sleepLogs),
      ),
    );
  }

  Future<void> getSleepLog(String id) async {
    emit(SleepLogLoading());
    final failureOrSleepLog =
        await getSleepLogUseCase(GetSleepLogParams(id: id));
    emit(
      failureOrSleepLog.fold(
        (failure) => SleepLogError(message: _mapFailureToMessage(failure)),
        (sleepLog) => SleepLogDetailLoaded(sleepLog: sleepLog),
      ),
    );
  }

  Future<void> addSleepLog(SleepLog sleepLog) async {
    emit(SleepLogLoading());
    final failureOrSuccess = await addSleepLogUseCase(AddSleepLogParams(sleepLog: sleepLog));
    emit(
      failureOrSuccess.fold(
        (failure) => SleepLogError(message: _mapFailureToMessage(failure)),
        (_) => SleepLogAdded(),
      ),
    );
  }

  Future<void> updateSleepLog(SleepLog sleepLog) async {
    emit(SleepLogLoading());
    final failureOrSuccess =
        await updateSleepLogUseCase(UpdateSleepLogParams(sleepLog: sleepLog));
    emit(
      failureOrSuccess.fold(
        (failure) => SleepLogError(message: _mapFailureToMessage(failure)),
        (_) => SleepLogUpdated(),
      ),
    );
  }

  Future<void> deleteSleepLog(String id) async {
    emit(SleepLogLoading());
    final failureOrSuccess =
        await deleteSleepLogUseCase(DeleteSleepLogParams(id: id));
    emit(
      failureOrSuccess.fold(
        (failure) => SleepLogError(message: _mapFailureToMessage(failure)),
        (_) => SleepLogDeleted(),
      ),
    );
  }
}
