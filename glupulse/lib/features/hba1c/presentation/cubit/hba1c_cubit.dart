import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/hba1c/domain/entities/hba1c.dart';
import 'package:glupulse/features/hba1c/domain/usecases/add_hba1c.dart';
import 'package:glupulse/features/hba1c/domain/usecases/delete_hba1c.dart';
import 'package:glupulse/features/hba1c/domain/usecases/get_hba1c_record.dart';
import 'package:glupulse/features/hba1c/domain/usecases/get_hba1c_records.dart';
import 'package:glupulse/features/hba1c/domain/usecases/update_hba1c.dart';

part 'hba1c_state.dart';

class Hba1cCubit extends Cubit<Hba1cState> {
  final GetHba1cRecords getHba1cRecordsUseCase;
  final GetHba1cRecord getHba1cRecordUseCase;
  final AddHba1c addHba1cUseCase;
  final UpdateHba1c updateHba1cUseCase;
  final DeleteHba1c deleteHba1cUseCase;

  Hba1cCubit({
    required this.getHba1cRecordsUseCase,
    required this.getHba1cRecordUseCase,
    required this.addHba1cUseCase,
    required this.updateHba1cUseCase,
    required this.deleteHba1cUseCase,
  }) : super(Hba1cInitial());

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return (failure as ServerFailure).message;
      default:
        return 'Unexpected error';
    }
  }

  Future<void> getHba1cRecords() async {
    emit(Hba1cLoading());
    final failureOrHba1cRecords = await getHba1cRecordsUseCase(NoParams());
    emit(
      failureOrHba1cRecords.fold(
        (failure) => Hba1cError(message: _mapFailureToMessage(failure)),
        (hba1cRecords) => Hba1cLoaded(hba1cRecords: hba1cRecords),
      ),
    );
  }

  Future<void> getHba1cRecord(String id) async {
    emit(Hba1cLoading());
    final failureOrHba1cRecord =
        await getHba1cRecordUseCase(GetHba1cRecordParams(id: id));
    emit(
      failureOrHba1cRecord.fold(
        (failure) => Hba1cError(message: _mapFailureToMessage(failure)),
        (hba1cRecord) => Hba1cDetailLoaded(hba1cRecord: hba1cRecord),
      ),
    );
  }

  Future<void> addHba1c(Hba1c hba1c) async {
    emit(Hba1cLoading());
    final failureOrSuccess = await addHba1cUseCase(AddHba1cParams(hba1c: hba1c));
    emit(
      failureOrSuccess.fold(
        (failure) => Hba1cError(message: _mapFailureToMessage(failure)),
        (_) => Hba1cAdded(),
      ),
    );
  }

  Future<void> updateHba1c(Hba1c hba1c) async {
    emit(Hba1cLoading());
    final failureOrSuccess =
        await updateHba1cUseCase(UpdateHba1cParams(hba1c: hba1c));
    emit(
      failureOrSuccess.fold(
        (failure) => Hba1cError(message: _mapFailureToMessage(failure)),
        (_) => Hba1cUpdated(),
      ),
    );
  }

  Future<void> deleteHba1c(String id) async {
    emit(Hba1cLoading());
    final failureOrSuccess =
        await deleteHba1cUseCase(DeleteHba1cParams(id: id));
    emit(
      failureOrSuccess.fold(
        (failure) => Hba1cError(message: _mapFailureToMessage(failure)),
        (_) => Hba1cDeleted(),
      ),
    );
  }
}
