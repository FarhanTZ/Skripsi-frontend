import 'package:glupulse/core/api/api_client.dart';
import 'package:glupulse/core/error/exceptions.dart';
import 'package:glupulse/features/Food/data/models/cart_model.dart';
import 'package:glupulse/features/Food/data/models/food_model.dart';
import 'package:glupulse/features/auth/data/datasources/auth_local_data_source.dart';

abstract class FoodRemoteDataSource {
  Future<List<FoodModel>> getFoods();
  Future<CartModel> getCart();
  Future<void> addToCart(String foodId, int quantity);
  Future<void> updateCartItem(String foodId, int quantity);
  Future<void> removeCartItem(String foodId);
  Future<void> checkout(String addressId, String paymentMethod);
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

  @override
  Future<CartModel> getCart() async {
    try {
      final token = await localDataSource.getLastToken();
      final response = await apiClient.get('/cart', token: token);
      return CartModel.fromJson(response);
    } on ServerException {
      rethrow;
    }
  }

  @override
  Future<void> addToCart(String foodId, int quantity) async {
    try {
      final token = await localDataSource.getLastToken();
      await apiClient.post(
        '/cart/add',
        body: {'food_id': foodId, 'quantity': quantity},
        token: token,
      );
    } on ServerException {
      rethrow;
    }
  }

  @override
  Future<void> updateCartItem(String foodId, int quantity) async {
    try {
      final token = await localDataSource.getLastToken();
      await apiClient.put(
        '/cart/update',
        body: {'food_id': foodId, 'quantity': quantity},
        token: token,
      );
    } on ServerException {
      rethrow;
    }
  }

  @override
  Future<void> removeCartItem(String foodId) async {
    try {
      final token = await localDataSource.getLastToken();
      // API Anda menggunakan POST untuk remove, jadi kita gunakan post di sini.
      await apiClient.post('/cart/remove',
          body: {'food_id': foodId}, token: token);
    } on ServerException {
      rethrow;
    }
  }

  @override
  Future<void> checkout(String addressId, String paymentMethod) async {
    try {
      final token = await localDataSource.getLastToken();
      await apiClient.post(
        '/checkout',
        body: {
          'address_id': addressId,
          'payment_method': paymentMethod,
        },
        token: token,
      );
    } on ServerException {
      rethrow;
    }
  }
}
