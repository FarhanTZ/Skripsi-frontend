import 'package:glupulse/core/api/api_client.dart';
import 'package:glupulse/core/error/exceptions.dart';
import 'package:glupulse/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:glupulse/features/orders/data/models/order_model.dart';

abstract class OrderRemoteDataSource {
  Future<List<OrderModel>> getTrackOrders();
  Future<List<OrderModel>> getOrderHistory({int limit = 10, int offset = 0});
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final ApiClient apiClient;
  final AuthLocalDataSource localDataSource;

  OrderRemoteDataSourceImpl({
    required this.apiClient,
    required this.localDataSource,
  });

  @override
  Future<List<OrderModel>> getTrackOrders() async {
    try {
      final token = await localDataSource.getLastToken();
      final response = await apiClient.getList('/order/track', token: token);
      print('OrderRemoteDataSourceImpl: getTrackOrders response: $response');
      return response.map((json) => OrderModel.fromJson(json)).toList();
    } on ServerException {
      rethrow;
    }
  }

  @override
  Future<List<OrderModel>> getOrderHistory({int limit = 10, int offset = 0}) async {
    try {
      final token = await localDataSource.getLastToken();
      final response = await apiClient.getList(
        '/order/history?limit=$limit&offset=$offset',
        token: token,
      );
      print('OrderRemoteDataSourceImpl: getOrderHistory response: $response');
      return response.map((json) => OrderModel.fromJson(json)).toList();
    } on ServerException {
      rethrow;
    }
  }
}
