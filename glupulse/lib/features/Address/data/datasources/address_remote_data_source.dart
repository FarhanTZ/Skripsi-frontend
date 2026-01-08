import 'package:glupulse/core/api/api_client.dart';
import 'package:glupulse/core/error/exceptions.dart';
import 'package:glupulse/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:glupulse/features/Address/domain/usecases/add_address_usecase.dart';
import 'package:glupulse/features/Address/domain/usecases/update_address_usecase.dart';

abstract class AddressRemoteDataSource {
  Future<void> addAddress(AddAddressParams params);
  Future<void> updateAddress(UpdateAddressParams params);
  Future<void> deleteAddress(String addressId);
  Future<void> setDefaultAddress(String addressId);
}

class AddressRemoteDataSourceImpl implements AddressRemoteDataSource {
  final ApiClient apiClient;
  final AuthLocalDataSource localDataSource;

  AddressRemoteDataSourceImpl({
    required this.apiClient,
    required this.localDataSource,
  });

  @override
  Future<void> addAddress(AddAddressParams params) async {
    try {
      // Ambil token otentikasi dari local storage
      final token = await localDataSource.getLastToken();

      // Lakukan POST request ke endpoint /addresses
      await apiClient.post(
        '/addresses',
        body: params.toJson(), // Gunakan method toJson dari params
        token: token, // Sertakan token dalam header
      );
      // Jika tidak ada exception, berarti request berhasil (status 2xx)
    } on ServerException {
      // Jika ApiClient melempar ServerException, lempar kembali
      rethrow;
    } catch (e) {
      // Tangani error tak terduga lainnya
      throw ServerException('Gagal menambahkan alamat. Periksa koneksi Anda.');
    }
  }

  @override
  Future<void> updateAddress(UpdateAddressParams params) async {
    try {
      final token = await localDataSource.getLastToken();
      await apiClient.put(
        '/addresses/${params.addressId}',
        body: params.toJson(),
        token: token,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Gagal memperbarui alamat. Periksa koneksi Anda.');
    }
  }

  @override
  Future<void> deleteAddress(String addressId) async {
    try {
      final token = await localDataSource.getLastToken();
      await apiClient.delete(
        '/addresses/$addressId',
        token: token,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Gagal menghapus alamat. Periksa koneksi Anda.');
    }
  }

  @override
  Future<void> setDefaultAddress(String addressId) async {
    try {
      final token = await localDataSource.getLastToken();
      // Menggunakan metode POST seperti yang diminta
      await apiClient.post(
        '/addresses/$addressId/set-default',
        token: token,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
          'Gagal mengatur alamat default. Periksa koneksi Anda.');
    }
  }
}