import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/activity/domain/repositories/activity_repository.dart';

class DeleteActivityLog implements UseCase<Unit, DeleteActivityLogParams> {
  final ActivityRepository repository;

  DeleteActivityLog(this.repository);

  @override
  Future<Either<Failure, Unit>> call(DeleteActivityLogParams params) async {
    return await repository.deleteActivityLog(params.id);
  }
}

class DeleteActivityLogParams extends Equatable {
  final String id;

  const DeleteActivityLogParams({required this.id});

  @override
  List<Object> get props => [id];
}
