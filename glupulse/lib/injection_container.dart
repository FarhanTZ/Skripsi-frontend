import 'package:get_it/get_it.dart';
import 'package:glupulse/features/HealthData/data/datasources/health_profile_remote_data_source.dart';
import 'package:glupulse/features/HealthData/data/repositories/health_profile_repository_impl.dart';
import 'package:glupulse/features/HealthData/domain/repositories/health_profile_repository.dart';
import 'package:glupulse/features/HealthData/domain/usecases/get_health_profile.dart';
import 'package:glupulse/features/HealthData/domain/usecases/update_health_profile.dart';
import 'package:glupulse/features/HealthData/presentation/cubit/health_profile_cubit.dart';
import 'package:glupulse/features/hba1c/domain/usecases/get_hba1c_record.dart';
import 'package:glupulse/features/health_event/domain/usecases/get_health_event_record.dart';
import 'package:glupulse/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:glupulse/features/profile/domain/repositories/profile_repository.dart';
import 'package:glupulse/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:glupulse/core/api/api_client.dart';
import 'package:glupulse/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:glupulse/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:glupulse/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:glupulse/features/auth/domain/repositories/auth_repository.dart';
import 'package:glupulse/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:glupulse/features/auth/domain/usecases/login_usecase.dart';
import 'package:glupulse/features/auth/domain/usecases/login_with_google_usecase.dart';
import 'package:glupulse/features/auth/domain/usecases/register_usecase.dart';
import 'package:glupulse/features/auth/domain/usecases/request_password_reset_usecase.dart';
import 'package:glupulse/features/auth/domain/usecases/complete_password_reset_usecase.dart';
import 'package:glupulse/features/auth/domain/usecases/verify_signup_otp_usecase.dart';
import 'package:glupulse/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:glupulse/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:glupulse/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:glupulse/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:glupulse/features/profile/domain/usecases/update_username_usecase.dart';
import 'package:glupulse/features/profile/domain/usecases/delete_account_usecase.dart';
import 'package:glupulse/features/profile/domain/usecases/update_password_usecase.dart';
import 'package:glupulse/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:glupulse/features/Address/data/datasources/address_remote_data_source.dart';
import 'package:glupulse/features/Address/data/repositories/address_repository_impl.dart';
import 'package:glupulse/features/Address/domain/repositories/address_repository.dart';
import 'package:glupulse/features/Address/domain/usecases/add_address_usecase.dart';
import 'package:glupulse/features/Address/domain/usecases/update_address_usecase.dart';
import 'package:glupulse/features/Address/domain/usecases/delete_address_usecase.dart';
import 'package:glupulse/features/Address/domain/usecases/set_default_address_usecase.dart';
import 'package:glupulse/features/Address/presentation/cubit/address_cubit.dart';
import 'package:glupulse/features/Food/data/datasources/food_remote_data_source.dart';
import 'package:glupulse/features/Food/data/repositories/food_repository_impl.dart';
import 'package:glupulse/features/Food/domain/repositories/food_repository.dart';
import 'package:glupulse/features/Food/domain/usecases/get_foods.dart';
import 'package:glupulse/features/Food/domain/usecases/get_cart_usecase.dart';
import 'package:glupulse/features/Food/domain/usecases/add_to_cart_usecase.dart';
import 'package:glupulse/features/Food/domain/usecases/update_cart_item_usecase.dart';
import 'package:glupulse/features/Food/domain/usecases/remove_cart_item_usecase.dart';
import 'package:glupulse/features/Food/presentation/cubit/food_cubit.dart';
import 'package:glupulse/features/Food/presentation/cubit/cart_cubit.dart';
import 'package:glupulse/features/hba1c/data/datasources/hba1c_remote_data_source.dart';
import 'package:glupulse/features/hba1c/data/repositories/hba1c_repository_impl.dart';
import 'package:glupulse/features/hba1c/domain/repositories/hba1c_repository.dart';
import 'package:glupulse/features/hba1c/domain/usecases/add_hba1c.dart';
import 'package:glupulse/features/hba1c/domain/usecases/delete_hba1c.dart';
import 'package:glupulse/features/hba1c/domain/usecases/get_hba1c_records.dart';
import 'package:glupulse/features/hba1c/domain/usecases/update_hba1c.dart';
import 'package:glupulse/features/hba1c/presentation/cubit/hba1c_cubit.dart';
import 'package:glupulse/features/health_event/data/datasources/health_event_remote_data_source.dart';
import 'package:glupulse/features/health_event/data/repositories/health_event_repository_impl.dart';
import 'package:glupulse/features/health_event/domain/repositories/health_event_repository.dart';
import 'package:glupulse/features/health_event/domain/usecases/add_health_event.dart';
import 'package:glupulse/features/health_event/domain/usecases/delete_health_event.dart';
import 'package:glupulse/features/health_event/domain/usecases/get_health_event_records.dart';
import 'package:glupulse/features/health_event/domain/usecases/update_health_event.dart';
import 'package:glupulse/features/health_event/presentation/cubit/health_event_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance; // sl = Service Locator

Future<void> init() async {
  // --- Features - Auth ---

  // Cubit
  // Didaftarkan sebagai factory karena kita mungkin ingin instance baru di beberapa tempat.
  sl.registerFactory(
    () => AuthCubit(
      loginUseCase: sl(),
      verifyOtpUseCase: sl(),
      verifySignupOtpUseCase: sl(), // Tambahkan ini
      registerUseCase: sl(),
      loginWithGoogleUseCase: sl(),
      getCurrentUserUseCase: sl(),
      requestPasswordResetUseCase: sl(),
      getHealthProfile: sl(),
      completePasswordResetUseCase: sl(),
      updateUsernameUseCase: sl(), // Tambahkan ini
      updatePasswordUseCase: sl(),
      deleteAccountUseCase: sl(),
      authRepository: sl(), // Sudah ada
      profileRepository: sl(), // Tambahkan ini
      googleSignIn: sl(),
    ),
  );

  // Use Cases
  // Lazy Singleton agar hanya dibuat saat pertama kali dibutuhkan.
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LoginWithGoogleUseCase(sl()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(sl()));
  sl.registerLazySingleton(() => VerifySignupOtpUseCase(sl())); // Tambahkan ini
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => RequestPasswordResetUseCase(sl()));
  sl.registerLazySingleton(() => CompletePasswordResetUseCase(sl()));
  sl.registerLazySingleton(() => DeleteAccountUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      apiClient: sl(),
      localDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      sharedPreferences: sl(),
    ),
  );

  // --- Features - Profile ---

  // Cubit
  sl.registerFactory(
    () => ProfileCubit(
      getProfileUseCase: sl(),
      updateProfileUseCase: sl(),
      updateUsernameUseCase: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUsernameUseCase(sl()));
  sl.registerLazySingleton(() => UpdatePasswordUseCase(sl()));

  // Repository
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(
      apiClient: sl(),
      localDataSource: sl(),
    ),
  );

  // --- Features - Address ---

  // Cubit
  sl.registerFactory(
    () => AddressCubit(
      addAddressUseCase: sl(),
      updateAddressUseCase: sl(),
      deleteAddressUseCase: sl(),
      setDefaultAddressUseCase: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => AddAddressUseCase(sl()));
  sl.registerLazySingleton(() => UpdateAddressUseCase(sl()));
  sl.registerLazySingleton(() => DeleteAddressUseCase(sl()));
  sl.registerLazySingleton(() => SetDefaultAddressUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AddressRepository>(
    () => AddressRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<AddressRemoteDataSource>(
    () => AddressRemoteDataSourceImpl(
      apiClient: sl(),
      localDataSource: sl(),
    ),
  );

  // --- Features - Food ---

  // Cubit
  sl.registerFactory(() => FoodCubit(getFoodsUseCase: sl()));
  sl.registerFactory(
    () => CartCubit(
      getCartUseCase: sl(),
      addToCartUseCase: sl(),
      updateCartItemUseCase: sl(),
      removeCartItemUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetFoods(sl()));
  sl.registerLazySingleton(() => GetCartUseCase(sl()));
  sl.registerLazySingleton(() => AddToCartUseCase(sl()));
  sl.registerLazySingleton(() => UpdateCartItemUseCase(sl()));
  sl.registerLazySingleton(() => RemoveCartItemUseCase(sl()));

  // Repository
  sl.registerLazySingleton<FoodRepository>(() => FoodRepositoryImpl(
        remoteDataSource: sl(),
      ));

  // Data sources
  sl.registerLazySingleton<FoodRemoteDataSource>(
      () => FoodRemoteDataSourceImpl(
        apiClient: sl(),
        localDataSource: sl()
      ));

  // --- Features - Hba1c ---

  // Cubit
  sl.registerFactory(
    () => Hba1cCubit(
      getHba1cRecordsUseCase: sl(),
      getHba1cRecordUseCase: sl(),
      addHba1cUseCase: sl(),
      updateHba1cUseCase: sl(),
      deleteHba1cUseCase: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetHba1cRecords(sl()));
  sl.registerLazySingleton(() => GetHba1cRecord(sl()));
  sl.registerLazySingleton(() => AddHba1c(sl()));
  sl.registerLazySingleton(() => UpdateHba1c(sl()));
  sl.registerLazySingleton(() => DeleteHba1c(sl()));

  // Repository
  sl.registerLazySingleton<Hba1cRepository>(
    () => Hba1cRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<Hba1cRemoteDataSource>(
    () => Hba1cRemoteDataSourceImpl(apiClient: sl()),
  );

  // --- Features - HealthData ---

  // Cubit
  sl.registerFactory(
    () => HealthProfileCubit(
      getHealthProfile: sl(),
      updateHealthProfile: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetHealthProfile(sl()));
  sl.registerLazySingleton(() => UpdateHealthProfile(sl()));

  // Repository
  sl.registerLazySingleton<HealthProfileRepository>(
    () => HealthProfileRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<HealthProfileRemoteDataSource>(
    () => HealthProfileRemoteDataSourceImpl(
      client: sl(),
      localDataSource: sl(),
    ),
  );

  // --- Features - Health Event ---

  // Cubit
  sl.registerFactory(
    () => HealthEventCubit(
      getHealthEventRecordsUseCase: sl(),
      getHealthEventRecordUseCase: sl(),
      addHealthEventUseCase: sl(),
      updateHealthEventUseCase: sl(),
      deleteHealthEventUseCase: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetHealthEventRecords(sl()));
  sl.registerLazySingleton(() => GetHealthEventRecord(sl()));
  sl.registerLazySingleton(() => AddHealthEvent(sl()));
  sl.registerLazySingleton(() => UpdateHealthEvent(sl()));
  sl.registerLazySingleton(() => DeleteHealthEvent(sl()));

  // Repository
  sl.registerLazySingleton<HealthEventRepository>(
    () => HealthEventRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<HealthEventRemoteDataSource>(
    () => HealthEventRemoteDataSourceImpl(apiClient: sl()),
  );

  // --- Core ---
  sl.registerLazySingleton(() => ApiClient());

  // --- External ---
  // Daftarkan SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Daftarkan http.Client
  sl.registerLazySingleton(() => http.Client());

  // Daftarkan GoogleSignIn sebagai lazy singleton
  sl.registerLazySingleton(() => GoogleSignIn());
}
