import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/hba1c/domain/entities/hba1c.dart';
import 'package:glupulse/features/hba1c/domain/repositories/hba1c_repository.dart';

class GetHba1cRecord implements UseCase<Hba1c, GetHba1cRecordParams> {
  final Hba1cRepository repository;

  GetHba1cRecord(this.repository);

  @override
  Future<Either<Failure, Hba1c>> call(GetHba1cRecordParams params) async {
    return await repository.getHba1cRecord(params.id);
  }
}

class GetHba1cRecordParams extends Equatable {
  final String id;

  const GetHba1cRecordParams({required this.id});

  @override
  List<Object?> get props => [id];
}
