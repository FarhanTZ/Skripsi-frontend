import 'package:glupulse/core/api/api_client.dart';
import 'package:glupulse/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:glupulse/features/HealthData/data/models/health_profile_model.dart';

abstract class HealthProfileRemoteDataSource {
  Future<HealthProfileModel> getHealthProfile(String token);
  Future<HealthProfileModel> updateHealthProfile(
      HealthProfileModel healthProfile, String token);
}

class HealthProfileRemoteDataSourceImpl implements HealthProfileRemoteDataSource {
  final ApiClient client;
  final AuthLocalDataSource localDataSource;

  HealthProfileRemoteDataSourceImpl(
      {required this.client, required this.localDataSource});

  @override
  Future<HealthProfileModel> getHealthProfile(String token) async {
    final response = await client.get('/health/profile', token: token);
    return HealthProfileModel.fromJson(response);
  }

  @override
  Future<HealthProfileModel> updateHealthProfile(
      HealthProfileModel healthProfile, String token) async {
    final response = await client.put(
      '/health/profile',
      body: healthProfile.toJson(),
      token: token,
    );
    return HealthProfileModel.fromJson(response);
  }
}
