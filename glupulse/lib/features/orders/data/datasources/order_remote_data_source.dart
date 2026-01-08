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
      final List<dynamic> jsonList = await apiClient.getList('/orders/track', token: token);
      return jsonList.map((json) => OrderModel.fromJson(json)).toList();
    } on ServerException {
      rethrow;
    }
  }

  @override
  Future<List<OrderModel>> getOrderHistory({int limit = 10, int offset = 0}) async {
    try {
      final token = await localDataSource.getLastToken();
      final List<dynamic> jsonList = await apiClient.getList(
        '/orders/history?limit=$limit&offset=$offset',
        token: token,
      );
      return jsonList.map((json) => OrderModel.fromJson(json)).toList();
    } on ServerException {
      rethrow;
    }
  }
}
