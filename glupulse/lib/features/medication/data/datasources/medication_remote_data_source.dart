import 'package:glupulse/core/api/api_client.dart';
import 'package:glupulse/core/error/exceptions.dart';
import 'package:glupulse/features/medication/data/models/medication_log_model.dart';
import 'package:glupulse/features/medication/data/models/medication_model.dart';

abstract class MedicationRemoteDataSource {
  // Definitions
  Future<List<MedicationModel>> getMedications(String token);
  Future<void> addMedication(MedicationModel medication, String token);
  Future<void> updateMedication(MedicationModel medication, String token);
  Future<void> deleteMedication(int id, String token);

  // Logs
  Future<List<MedicationLogModel>> getMedicationLogs(String token);
  Future<void> addMedicationLog(MedicationLogModel log, String token);
  Future<void> updateMedicationLog(MedicationLogModel log, String token);
  Future<void> deleteMedicationLog(String id, String token);
}

class MedicationRemoteDataSourceImpl implements MedicationRemoteDataSource {
  final ApiClient apiClient;

  MedicationRemoteDataSourceImpl({required this.apiClient});

  // --- Definitions ---

  @override
  Future<List<MedicationModel>> getMedications(String token) async {
    try {
      final response = await apiClient.getList('/health/medication', token: token);
      return response.map((json) => MedicationModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> addMedication(MedicationModel medication, String token) async {
    try {
      await apiClient.post('/health/medication', body: medication.toJson(), token: token);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updateMedication(MedicationModel medication, String token) async {
    try {
      await apiClient.put('/health/medication/${medication.id}', body: medication.toJson(), token: token);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteMedication(int id, String token) async {
    try {
      await apiClient.delete('/health/medication/$id', token: token);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // --- Logs ---

  @override
  Future<List<MedicationLogModel>> getMedicationLogs(String token) async {
    try {
      final response = await apiClient.getList('/health/log/medication', token: token);
      return response.map((json) => MedicationLogModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> addMedicationLog(MedicationLogModel log, String token) async {
    try {
      await apiClient.post('/health/log/medication', body: log.toJson(), token: token);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updateMedicationLog(MedicationLogModel log, String token) async {
    try {
      await apiClient.put('/health/log/medication/${log.id}', body: log.toJson(), token: token);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteMedicationLog(String id, String token) async {
    try {
      await apiClient.delete('/health/log/medication/$id', token: token);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
