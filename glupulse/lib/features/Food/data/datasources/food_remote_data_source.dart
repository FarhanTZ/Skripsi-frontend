import 'package:glupulse/core/api/api_client.dart';
import 'package:glupulse/core/error/exceptions.dart';
import 'package:glupulse/features/Food/data/models/cart_model.dart';
import 'package:glupulse/features/Food/data/models/food_category_model.dart';
import 'package:glupulse/features/Food/data/models/food_model.dart';
import 'package:glupulse/features/auth/data/datasources/auth_local_data_source.dart';

abstract class FoodRemoteDataSource {
  Future<List<FoodModel>> getFoods();
  Future<List<FoodCategoryModel>> getFoodCategories();
  Future<CartModel> getCart();
  Future<void> addToCart(String foodId, int quantity);
  Future<void> updateCartItem(String foodId, int quantity);
  Future<void> removeCartItem(String foodId);
  Future<String> checkout(String addressId, String paymentMethod);
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
  Future<List<FoodCategoryModel>> getFoodCategories() async {
    try {
      final token = await localDataSource.getLastToken();
      final List<dynamic> jsonList = await apiClient.getList('/food/categories', token: token);
      return jsonList.map((json) => FoodCategoryModel.fromJson(json)).toList();
    } on ServerException {
      rethrow;
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
  Future<String> checkout(String addressId, String paymentMethod) async {
    try {
      final token = await localDataSource.getLastToken();
      final response = await apiClient.post(
        '/checkout',
        body: {
          'address_id': addressId,
          'payment_method': paymentMethod,
        },
        token: token,
      );
      
      // Fungsi bantu untuk mencari ID dalam Map
      String? findId(Map<String, dynamic> map) {
          if (map.containsKey('order_id')) return map['order_id'].toString();
          if (map.containsKey('id')) return map['id'].toString();
          if (map.containsKey('orderId')) return map['orderId'].toString();
          return null;
      }

      // 1. Cek langsung di root response
      var id = findId(response);
      if (id != null) return id;

      // 2. Cek di dalam object 'data'
      if (response.containsKey('data') && response['data'] is Map) {
          final dataMap = response['data'] as Map<String, dynamic>;
          id = findId(dataMap);
          if (id != null) return id;
          
          // Cek lagi kalau ada nested 'order' di dalam 'data'
          if (dataMap.containsKey('order') && dataMap['order'] is Map) {
             id = findId(dataMap['order']);
             if (id != null) return id;
          }
      }

      // 3. Cek di dalam object 'order'
      if (response.containsKey('order') && response['order'] is Map) {
          id = findId(response['order'] as Map<String, dynamic>);
          if (id != null) return id;
      }

      // Jika masih tidak ketemu, tampilkan semua keys biar gampang debug
      throw ServerException('Order created but ID not returned. Keys: ${response.keys.toList()} | Response: $response');
      
    } on ServerException {
      rethrow;
    }
  }
}
