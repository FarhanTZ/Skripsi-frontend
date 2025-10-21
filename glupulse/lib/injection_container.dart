import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:glupulse/core/api/api_client.dart';
import 'package:glupulse/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:glupulse/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:glupulse/features/auth/domain/repositories/auth_repository.dart';
import 'package:glupulse/features/auth/domain/usecases/login_usecase.dart';
import 'package:glupulse/features/auth/domain/usecases/login_with_google_usecase.dart';
import 'package:glupulse/features/auth/domain/usecases/register_usecase.dart';
import 'package:glupulse/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:glupulse/features/auth/presentation/cubit/auth_cubit.dart';

final sl = GetIt.instance; // sl = Service Locator

Future<void> init() async {
  // --- Features - Auth ---

  // Cubit
  // Didaftarkan sebagai factory karena kita mungkin ingin instance baru di beberapa tempat.
  sl.registerFactory(
    () => AuthCubit(
      loginUseCase: sl(),
      verifyOtpUseCase: sl(),
      registerUseCase: sl(),
      loginWithGoogleUseCase: sl(),
      googleSignIn: sl(),
    ),
  );

  // Use Cases
  // Lazy Singleton agar hanya dibuat saat pertama kali dibutuhkan.
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LoginWithGoogleUseCase(sl()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      apiClient: sl(),
    ),
  );

  // --- Core ---
  sl.registerLazySingleton(() => ApiClient());

  // --- External ---
  // Daftarkan GoogleSignIn sebagai lazy singleton
  sl.registerLazySingleton(() => GoogleSignIn());
}
