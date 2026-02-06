import 'package:glupulse/core/api/api_client.dart';
import 'package:glupulse/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:glupulse/features/Food/data/models/cart_model.dart';

abstract class CartRemoteDataSource {
  Future<CartModel> getCart();
  Future<void> addToCart(String foodId, int quantity);
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final ApiClient apiClient;
  final AuthLocalDataSource localDataSource;

  CartRemoteDataSourceImpl({required this.apiClient, required this.localDataSource});

  @override
  Future<CartModel> getCart() async {
    // Ganti dengan URL API Anda yang sebenarnya
    const url = '/cart';
    try {
      final token = await localDataSource.getLastToken();
      final response = await apiClient.get(url, token: token);
      // The get method in ApiClient already checks for success status codes
      // and throws a ServerException on failure.
      // It also returns the decoded JSON body directly.
      return CartModel.fromJson(response);
    } catch (e) {
      // Re-throw the exception from ApiClient or other sources
      rethrow;
    }
  }

  @override
  Future<void> addToCart(String foodId, int quantity) async {
    const url = '/cart/add';
    try {
      final token = await localDataSource.getLastToken();
      await apiClient.post(
        url,
        token: token,
        body: {'food_id': foodId, 'quantity': quantity},
      );
    } catch (e) {
      rethrow;
    }
  }
}