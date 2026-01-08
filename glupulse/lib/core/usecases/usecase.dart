import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:glupulse/core/error/failures.dart';

/// Kontrak abstrak untuk Use Case.
/// [Type] adalah tipe data yang akan dikembalikan jika sukses.
/// [Params] adalah parameter yang dibutuhkan untuk menjalankan use case.
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Digunakan ketika sebuah use case tidak memerlukan parameter apa pun.
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}