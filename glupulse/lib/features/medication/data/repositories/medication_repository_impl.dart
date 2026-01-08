import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/exceptions.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/core/network/network_info.dart';
import 'package:glupulse/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:glupulse/features/medication/data/datasources/medication_remote_data_source.dart';
import 'package:glupulse/features/medication/data/models/medication_log_model.dart';
import 'package:glupulse/features/medication/data/models/medication_model.dart';
import 'package:glupulse/features/medication/domain/entities/medication.dart';
import 'package:glupulse/features/medication/domain/entities/medication_log.dart';
import 'package:glupulse/features/medication/domain/repositories/medication_repository.dart';

class MedicationRepositoryImpl implements MedicationRepository {
  final MedicationRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  MedicationRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  // --- Definitions ---

  @override
  Future<Either<Failure, Unit>> addMedication(Medication medication) async {
    if (await networkInfo.isConnected) {
      try {
        final token = await localDataSource.getLastToken();
        final model = MedicationModel.fromEntity(medication);
        await remoteDataSource.addMedication(model, token);
        return const Right(unit);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteMedication(int id) async {
    if (await networkInfo.isConnected) {
      try {
        final token = await localDataSource.getLastToken();
        await remoteDataSource.deleteMedication(id, token);
        return const Right(unit);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List<Medication>>> getMedications() async {
    if (await networkInfo.isConnected) {
      try {
        final token = await localDataSource.getLastToken();
        final models = await remoteDataSource.getMedications(token);
        return Right(models);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateMedication(Medication medication) async {
    if (await networkInfo.isConnected) {
      try {
        final token = await localDataSource.getLastToken();
        final model = MedicationModel.fromEntity(medication);
        await remoteDataSource.updateMedication(model, token);
        return const Right(unit);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  // --- Logs ---

  @override
  Future<Either<Failure, Unit>> addMedicationLog(MedicationLog log) async {
    if (await networkInfo.isConnected) {
      try {
        final token = await localDataSource.getLastToken();
        final model = MedicationLogModel.fromEntity(log);
        await remoteDataSource.addMedicationLog(model, token);
        return const Right(unit);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteMedicationLog(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final token = await localDataSource.getLastToken();
        await remoteDataSource.deleteMedicationLog(id, token);
        return const Right(unit);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List<MedicationLog>>> getMedicationLogs() async {
    if (await networkInfo.isConnected) {
      try {
        final token = await localDataSource.getLastToken();
        final models = await remoteDataSource.getMedicationLogs(token);
        return Right(models);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateMedicationLog(MedicationLog log) async {
    if (await networkInfo.isConnected) {
      try {
        final token = await localDataSource.getLastToken();
        final model = MedicationLogModel.fromEntity(log);
        await remoteDataSource.updateMedicationLog(model, token);
        return const Right(unit);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
