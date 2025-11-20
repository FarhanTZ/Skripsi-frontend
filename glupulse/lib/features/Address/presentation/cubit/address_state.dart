import 'package:equatable/equatable.dart';

abstract class AddressState extends Equatable {
  const AddressState();

  @override
  List<Object> get props => [];
}

class AddressInitial extends AddressState {}

class AddressLoading extends AddressState {}

// State ini menandakan aksi (tambah, update, hapus, set default) berhasil.
// UI bisa listen ke state ini untuk refresh data atau kembali ke halaman sebelumnya.
class AddressActionSuccess extends AddressState {}

class AddressError extends AddressState {
  final String message;
  const AddressError(this.message);
}