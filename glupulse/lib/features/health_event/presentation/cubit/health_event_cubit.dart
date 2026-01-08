import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/health_event/domain/entities/health_event.dart';
import 'package:glupulse/features/health_event/domain/usecases/add_health_event.dart';
import 'package:glupulse/features/health_event/domain/usecases/delete_health_event.dart';
import 'package:glupulse/features/health_event/domain/usecases/get_health_event_record.dart';
import 'package:glupulse/features/health_event/domain/usecases/get_health_event_records.dart';
import 'package:glupulse/features/health_event/domain/usecases/update_health_event.dart';

part 'health_event_state.dart';

class HealthEventCubit extends Cubit<HealthEventState> {
  final GetHealthEventRecords getHealthEventRecordsUseCase;
  final GetHealthEventRecord getHealthEventRecordUseCase;
  final AddHealthEvent addHealthEventUseCase;
  final UpdateHealthEvent updateHealthEventUseCase;
  final DeleteHealthEvent deleteHealthEventUseCase;

  HealthEventCubit({
    required this.getHealthEventRecordsUseCase,
    required this.getHealthEventRecordUseCase,
    required this.addHealthEventUseCase,
    required this.updateHealthEventUseCase,
    required this.deleteHealthEventUseCase,
  }) : super(HealthEventInitial());

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return (failure as ServerFailure).message;
      default:
        return 'Unexpected error';
    }
  }

  Future<void> getHealthEventRecords() async {
    emit(HealthEventLoading());
    final failureOrHealthEventRecords =
        await getHealthEventRecordsUseCase(NoParams());
    emit(
      failureOrHealthEventRecords.fold(
        (failure) => HealthEventError(message: _mapFailureToMessage(failure)),
        (healthEventRecords) =>
            HealthEventLoaded(healthEventRecords: healthEventRecords),
      ),
    );
  }

  Future<void> getHealthEventRecord(String id) async {
    emit(HealthEventLoading());
    final failureOrHealthEventRecord =
        await getHealthEventRecordUseCase(GetHealthEventRecordParams(id: id));
    emit(
      failureOrHealthEventRecord.fold(
        (failure) => HealthEventError(message: _mapFailureToMessage(failure)),
        (healthEventRecord) =>
            HealthEventDetailLoaded(healthEventRecord: healthEventRecord),
      ),
    );
  }

  Future<void> addHealthEvent(HealthEvent healthEvent) async {
    emit(HealthEventLoading());
    final failureOrSuccess =
        await addHealthEventUseCase(AddHealthEventParams(healthEvent: healthEvent));
    emit(
      failureOrSuccess.fold(
        (failure) => HealthEventError(message: _mapFailureToMessage(failure)),
        (_) => HealthEventAdded(),
      ),
    );
  }

  Future<void> updateHealthEvent(HealthEvent healthEvent) async {
    emit(HealthEventLoading());
    final failureOrSuccess =
        await updateHealthEventUseCase(UpdateHealthEventParams(healthEvent: healthEvent));
    emit(
      failureOrSuccess.fold(
        (failure) => HealthEventError(message: _mapFailureToMessage(failure)),
        (_) => HealthEventUpdated(),
      ),
    );
  }

  Future<void> deleteHealthEvent(String id) async {
    emit(HealthEventLoading());
    final failureOrSuccess =
        await deleteHealthEventUseCase(DeleteHealthEventParams(id: id));
    emit(
      failureOrSuccess.fold(
        (failure) => HealthEventError(message: _mapFailureToMessage(failure)),
        (_) => HealthEventDeleted(),
      ),
    );
  }
}
