import 'package:bloc/bloc.dart';
import 'package:glupulse/features/Address/domain/usecases/add_address_usecase.dart';
import 'package:glupulse/features/Address/domain/usecases/delete_address_usecase.dart';
import 'package:glupulse/features/Address/domain/usecases/set_default_address_usecase.dart';
import 'package:glupulse/features/Address/domain/usecases/update_address_usecase.dart';
import 'package:glupulse/features/Address/presentation/cubit/address_state.dart';
import 'package:glupulse/core/error/failures.dart';

class AddressCubit extends Cubit<AddressState> {
  final AddAddressUseCase addAddressUseCase;
  final UpdateAddressUseCase updateAddressUseCase;
  final DeleteAddressUseCase deleteAddressUseCase;
  final SetDefaultAddressUseCase setDefaultAddressUseCase;

  AddressCubit(
      {required this.addAddressUseCase,
      required this.updateAddressUseCase,
      required this.deleteAddressUseCase,
      required this.setDefaultAddressUseCase})
      : super(AddressInitial());

  Future<void> addAddress(AddAddressParams params) async {
    emit(AddressLoading());
    final result = await addAddressUseCase(params);

    result.fold(
      (failure) {
        emit(AddressError(_mapFailureToMessage(failure)));
      },
      (_) {
        emit(AddressActionSuccess());
      },
    );
  }

  Future<void> updateAddress(UpdateAddressParams params) async {
    emit(AddressLoading());

    // Pertama, selalu update data alamat (label, penerima, dll)
    final updateResult = await updateAddressUseCase(params);

    // Jika update data gagal, hentikan proses dan tampilkan error
    final failure = updateResult.fold((failure) => failure, (_) => null);
    if (failure != null) {
      emit(AddressError(_mapFailureToMessage(failure)));
      return;
    }

    // Kedua, jika user juga menandainya sebagai default, panggil use case set-default
    if (params.isDefault) {
      final setDefaultResult = await setDefaultAddressUseCase(params.addressId);
      setDefaultResult.fold(
        (failure) => emit(AddressError(_mapFailureToMessage(failure))),
        (_) => emit(AddressActionSuccess()),
      );
    } else {
      // Jika tidak ada perubahan status default, anggap aksi update sudah berhasil
      emit(AddressActionSuccess());
    }
  }

  Future<void> deleteAddress(String addressId) async {
    emit(AddressLoading());
    final result = await deleteAddressUseCase(addressId);
    result.fold(
      (failure) => emit(AddressError(_mapFailureToMessage(failure))),
      (_) => emit(AddressActionSuccess()),
    );
  }

  Future<void> setDefaultAddress(String addressId) async {
    emit(AddressLoading());
    final result = await setDefaultAddressUseCase(addressId);
    result.fold(
      (failure) => emit(AddressError(_mapFailureToMessage(failure))),
      (_) => emit(AddressActionSuccess()),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    }
    return 'Terjadi kesalahan yang tidak terduga.';
  }
}