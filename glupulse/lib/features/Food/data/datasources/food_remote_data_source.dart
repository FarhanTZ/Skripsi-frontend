import 'package:glupulse/core/api/api_client.dart';
import 'package:glupulse/core/error/exceptions.dart';
import 'package:glupulse/features/Food/data/models/food_model.dart';
import 'package:glupulse/features/auth/data/datasources/auth_local_data_source.dart';

abstract class FoodRemoteDataSource {
  Future<List<FoodModel>> getFoods();
}

class FoodRemoteDataSourceImpl implements FoodRemoteDataSource {
  final ApiClient apiClient;
  final AuthLocalDataSource localDataSource;

  FoodRemoteDataSourceImpl({required this.apiClient, required this.localDataSource});

  @override
  Future<List<FoodModel>> getFoods() async {
    try {
      // Ambil token dari local storage
      final token = await localDataSource.getLastToken();
      // Panggil metode getList dari ApiClient
      final List<dynamic> jsonList = await apiClient.getList('/foods', token: token);
      // Konversi list JSON menjadi list FoodModel
      return jsonList.map((json) => FoodModel.fromJson(json)).toList();
    } on ServerException {
      rethrow; // Lempar kembali ServerException yang sudah ditangani oleh ApiClient
    }
  }
}
