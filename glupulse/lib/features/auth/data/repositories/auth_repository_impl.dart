import 'package:glupulse/core/error/exceptions.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/features/auth/domain/entities/auth_response.dart';
import 'package:glupulse/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:glupulse/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AuthResponseEntity> login(String username, String password) async {
    try {
      return await remoteDataSource.login(username, password);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure('Terjadi kesalahan koneksi.');
    }
  }

  @override
  Future<void> register(
      {required String username,
      required String email,
      required String password}) async {
    try {
      await remoteDataSource.register(
          username: username, email: email, password: password);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure('Terjadi kesalahan koneksi.');
    }
  }
}