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

    // **LOGIKA BARU**
    // Jika kita mencoba menjadikan alamat ini sebagai default, gunakan use case khusus.
    // Ini kemungkinan besar akan menangani logika di backend untuk menonaktifkan
    // default lama secara otomatis.
    if (params.isDefault) {
      final result = await setDefaultAddressUseCase(params.addressId);
      result.fold(
        (failure) => emit(AddressError(_mapFailureToMessage(failure))),
        (_) => emit(AddressActionSuccess()),
      );
    } else {
      // Jika kita hanya mengupdate field lain (atau menonaktifkan default),
      // gunakan use case update biasa.
      final result = await updateAddressUseCase(params);
      result.fold(
        (failure) => emit(AddressError(_mapFailureToMessage(failure))),
        (_) => emit(AddressActionSuccess()),
      );
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