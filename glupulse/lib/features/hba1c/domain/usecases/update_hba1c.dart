import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/hba1c/domain/entities/hba1c.dart';
import 'package:glupulse/features/hba1c/domain/repositories/hba1c_repository.dart';

class UpdateHba1c implements UseCase<Unit, UpdateHba1cParams> {
  final Hba1cRepository repository;

  UpdateHba1c(this.repository);

  @override
  Future<Either<Failure, Unit>> call(UpdateHba1cParams params) async {
    return await repository.updateHba1cRecord(params.hba1c);
  }
}

class UpdateHba1cParams extends Equatable {
  final Hba1c hba1c;

  const UpdateHba1cParams({required this.hba1c});

  @override
  List<Object?> get props => [hba1c];
}
