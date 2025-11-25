import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/glucose/domain/entities/glucose.dart';
import 'package:glupulse/features/glucose/domain/usecases/add_glucose_record.dart';
import 'package:glupulse/features/glucose/domain/usecases/delete_glucose_record.dart';
import 'package:glupulse/features/glucose/domain/usecases/get_glucose_record.dart';
import 'package:glupulse/features/glucose/domain/usecases/get_glucose_records.dart';
import 'package:glupulse/features/glucose/domain/usecases/update_glucose_record.dart';

part 'glucose_state.dart';

class GlucoseCubit extends Cubit<GlucoseState> {
  final GetGlucoseRecords getGlucoseRecordsUseCase;
  final GetGlucoseRecord getGlucoseRecordUseCase;
  final AddGlucoseRecord addGlucoseRecordUseCase;
  final UpdateGlucoseRecord updateGlucoseRecordUseCase;
  final DeleteGlucoseRecord deleteGlucoseRecordUseCase;

  GlucoseCubit({
    required this.getGlucoseRecordsUseCase,
    required this.getGlucoseRecordUseCase,
    required this.addGlucoseRecordUseCase,
    required this.updateGlucoseRecordUseCase,
    required this.deleteGlucoseRecordUseCase,
  }) : super(GlucoseInitial());

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return (failure as ServerFailure).message;
      default:
        return 'Unexpected error';
    }
  }

  Future<void> getGlucoseRecords() async {
    emit(GlucoseLoading());
    final failureOrGlucoseRecords = await getGlucoseRecordsUseCase(NoParams());
    emit(
      failureOrGlucoseRecords.fold(
        (failure) => GlucoseError(message: _mapFailureToMessage(failure)),
        (glucoseRecords) => GlucoseLoaded(glucoseRecords: glucoseRecords),
      ),
    );
  }

  Future<void> getGlucoseRecord(String id) async {
    emit(GlucoseLoading());
    final failureOrGlucoseRecord =
        await getGlucoseRecordUseCase(GetGlucoseRecordParams(id: id));
    emit(
      failureOrGlucoseRecord.fold(
        (failure) => GlucoseError(message: _mapFailureToMessage(failure)),
        (glucoseRecord) => GlucoseDetailLoaded(glucoseRecord: glucoseRecord),
      ),
    );
  }

  Future<void> addGlucose(Glucose glucose) async {
    emit(GlucoseLoading());
    final failureOrSuccess = await addGlucoseRecordUseCase(AddGlucoseParams(glucose: glucose));
    emit(
      failureOrSuccess.fold(
        (failure) => GlucoseError(message: _mapFailureToMessage(failure)),
        (_) => GlucoseAdded(),
      ),
    );
  }

  Future<void> updateGlucose(Glucose glucose) async {
    emit(GlucoseLoading());
    final failureOrSuccess =
        await updateGlucoseRecordUseCase(UpdateGlucoseParams(glucose: glucose));
    emit(
      failureOrSuccess.fold(
        (failure) => GlucoseError(message: _mapFailureToMessage(failure)),
        (_) => GlucoseUpdated(),
      ),
    );
  }

  Future<void> deleteGlucose(String id) async {
    emit(GlucoseLoading());
    final failureOrSuccess =
        await deleteGlucoseRecordUseCase(DeleteGlucoseParams(id: id));
    emit(
      failureOrSuccess.fold(
        (failure) => GlucoseError(message: _mapFailureToMessage(failure)),
        (_) => GlucoseDeleted(),
      ),
    );
  }
}
