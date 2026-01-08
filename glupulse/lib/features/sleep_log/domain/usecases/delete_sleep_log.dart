import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/sleep_log/domain/repositories/sleep_log_repository.dart';

class DeleteSleepLog implements UseCase<Unit, DeleteSleepLogParams> {
  final SleepLogRepository repository;

  DeleteSleepLog(this.repository);

  @override
  Future<Either<Failure, Unit>> call(DeleteSleepLogParams params) async {
    return await repository.deleteSleepLog(params.id);
  }
}

class DeleteSleepLogParams extends Equatable {
  final String id;

  const DeleteSleepLogParams({required this.id});

  @override
  List<Object> get props => [id];
}