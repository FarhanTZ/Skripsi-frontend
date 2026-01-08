import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/hba1c/domain/repositories/hba1c_repository.dart';

class DeleteHba1c implements UseCase<Unit, DeleteHba1cParams> {
  final Hba1cRepository repository;

  DeleteHba1c(this.repository);

  @override
  Future<Either<Failure, Unit>> call(DeleteHba1cParams params) async {
    return await repository.deleteHba1cRecord(params.id);
  }
}

class DeleteHba1cParams extends Equatable {
  final String id;

  const DeleteHba1cParams({required this.id});

  @override
  List<Object?> get props => [id];
}
