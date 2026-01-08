import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/hba1c/domain/entities/hba1c.dart';
import 'package:glupulse/features/hba1c/domain/repositories/hba1c_repository.dart';

class AddHba1c implements UseCase<Unit, AddHba1cParams> {
  final Hba1cRepository repository;

  AddHba1c(this.repository);

  @override
  Future<Either<Failure, Unit>> call(AddHba1cParams params) async {
    return await repository.addHba1cRecord(params.hba1c);
  }
}

class AddHba1cParams extends Equatable {
  final Hba1c hba1c;

  const AddHba1cParams({required this.hba1c});

  @override
  List<Object?> get props => [hba1c];
}
