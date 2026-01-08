import 'package:glupulse/core/api/api_client.dart';
import 'package:glupulse/core/error/exceptions.dart';
import 'package:glupulse/features/seller/data/models/seller_model.dart';
import 'package:glupulse/features/auth/data/datasources/auth_local_data_source.dart';

abstract class SellerRemoteDataSource {
  Future<SellerModel> getSellerById(String sellerId);
}

class SellerRemoteDataSourceImpl implements SellerRemoteDataSource {
  final ApiClient apiClient;
  final AuthLocalDataSource localDataSource;

  SellerRemoteDataSourceImpl({required this.apiClient, required this.localDataSource});

  @override
  Future<SellerModel> getSellerById(String sellerId) async {
    try {
      final token = await localDataSource.getLastToken();
      // Mencoba endpoint /seller/profile/{sellerId} sesuai saran
      final response = await apiClient.get('/seller/profile/$sellerId', token: token);
      return SellerModel.fromJson(response);
    } on ServerException {
      rethrow;
    }
  }
}
