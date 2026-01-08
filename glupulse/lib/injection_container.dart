import 'package:get_it/get_it.dart';
import 'package:glupulse/features/HealthData/data/datasources/health_profile_remote_data_source.dart';
import 'package:glupulse/features/HealthData/data/repositories/health_profile_repository_impl.dart';
import 'package:glupulse/features/HealthData/domain/repositories/health_profile_repository.dart';
import 'package:glupulse/features/HealthData/domain/usecases/get_health_profile.dart';
import 'package:glupulse/features/HealthData/domain/usecases/update_health_profile.dart';
import 'package:glupulse/features/HealthData/presentation/cubit/health_profile_cubit.dart';
import 'package:glupulse/features/activity/data/datasources/activity_remote_data_source.dart';
import 'package:glupulse/features/activity/data/repositories/activity_repository_impl.dart';
import 'package:glupulse/features/activity/domain/repositories/activity_repository.dart';
import 'package:glupulse/features/activity/domain/usecases/add_activity_log.dart';
import 'package:glupulse/features/activity/domain/usecases/delete_activity_log.dart';
import 'package:glupulse/features/activity/domain/usecases/get_activity_logs.dart';
import 'package:glupulse/features/activity/domain/usecases/get_activity_types.dart';
import 'package:glupulse/features/activity/domain/usecases/update_activity_log.dart';
import 'package:glupulse/features/activity/presentation/cubit/activity_cubit.dart';
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
import 'package:glupulse/features/Food/domain/usecases/checkout_usecase.dart';
import 'package:glupulse/features/Food/domain/usecases/get_food_categories.dart';
import 'package:glupulse/features/Food/presentation/cubit/food_cubit.dart';
import 'package:glupulse/features/Food/presentation/cubit/food_category_cubit.dart';
import 'package:glupulse/features/Food/presentation/cubit/cart_cubit.dart';
import 'package:glupulse/features/Food/presentation/cubit/checkout_cubit.dart';
import 'package:glupulse/features/hba1c/data/datasources/hba1c_remote_data_source.dart';
import 'package:glupulse/features/hba1c/data/repositories/hba1c_repository_impl.dart';
import 'package:glupulse/features/hba1c/domain/repositories/hba1c_repository.dart';
import 'package:glupulse/features/hba1c/domain/usecases/add_hba1c.dart';
import 'package:glupulse/features/hba1c/domain/usecases/delete_hba1c.dart';
import 'package:glupulse/features/hba1c/domain/usecases/get_hba1c_records.dart';
import 'package:glupulse/features/hba1c/domain/usecases/update_hba1c.dart';
import 'package:glupulse/features/hba1c/presentation/cubit/hba1c_cubit.dart';
import 'package:glupulse/features/glucose/data/datasources/glucose_remote_data_source.dart';
import 'package:glupulse/features/glucose/data/repositories/glucose_repository_impl.dart';
import 'package:glupulse/features/glucose/domain/repositories/glucose_repository.dart';
import 'package:glupulse/features/glucose/domain/usecases/add_glucose_record.dart';
import 'package:glupulse/features/glucose/domain/usecases/delete_glucose_record.dart';
import 'package:glupulse/features/glucose/domain/usecases/get_glucose_record.dart';
import 'package:glupulse/features/glucose/domain/usecases/get_glucose_records.dart';
import 'package:glupulse/features/glucose/domain/usecases/update_glucose_record.dart';
import 'package:glupulse/features/glucose/presentation/cubit/glucose_cubit.dart';
import 'package:glupulse/features/health_event/data/datasources/health_event_remote_data_source.dart';
import 'package:glupulse/features/health_event/data/repositories/health_event_repository_impl.dart';
import 'package:glupulse/features/health_event/domain/repositories/health_event_repository.dart';
import 'package:glupulse/features/health_event/domain/usecases/add_health_event.dart';
import 'package:glupulse/features/health_event/domain/usecases/delete_health_event.dart';
import 'package:glupulse/features/health_event/domain/usecases/get_health_event_records.dart';
import 'package:glupulse/features/health_event/domain/usecases/update_health_event.dart';
import 'package:glupulse/features/health_event/presentation/cubit/health_event_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:glupulse/features/medication/data/datasources/medication_remote_data_source.dart';
import 'package:glupulse/features/medication/data/repositories/medication_repository_impl.dart';
import 'package:glupulse/features/medication/domain/repositories/medication_repository.dart';
import 'package:glupulse/features/medication/domain/usecases/medication_log_usecases.dart';
import 'package:glupulse/features/medication/domain/usecases/medication_usecases.dart';
import 'package:glupulse/features/medication/presentation/cubit/medication_cubit.dart';
import 'package:glupulse/features/medication/presentation/cubit/medication_log_cubit.dart';
import 'package:glupulse/features/sleep_log/data/datasources/sleep_log_remote_data_source.dart';
import 'package:glupulse/features/sleep_log/data/repositories/sleep_log_repository_impl.dart';
import 'package:glupulse/features/sleep_log/domain/repositories/sleep_log_repository.dart';
import 'package:glupulse/features/sleep_log/domain/usecases/add_sleep_log.dart';
import 'package:glupulse/features/sleep_log/domain/usecases/delete_sleep_log.dart';
import 'package:glupulse/features/sleep_log/domain/usecases/get_sleep_log.dart';
import 'package:glupulse/features/sleep_log/domain/usecases/get_sleep_logs.dart';
import 'package:glupulse/features/sleep_log/domain/usecases/update_sleep_log.dart';
import 'package:glupulse/features/sleep_log/presentation/cubit/sleep_log_cubit.dart';
import 'package:glupulse/features/meal_log/data/datasources/meal_log_remote_data_source.dart';
import 'package:glupulse/features/meal_log/data/repositories/meal_log_repository_impl.dart';
import 'package:glupulse/features/meal_log/domain/repositories/meal_log_repository.dart';
import 'package:glupulse/features/meal_log/domain/usecases/add_meal_log.dart';
import 'package:glupulse/features/meal_log/domain/usecases/delete_meal_log.dart';
import 'package:glupulse/features/meal_log/domain/usecases/get_meal_log.dart';
import 'package:glupulse/features/meal_log/domain/usecases/get_meal_logs.dart';
import 'package:glupulse/features/meal_log/domain/usecases/update_meal_log.dart';
import 'package:glupulse/features/meal_log/presentation/cubit/meal_log_cubit.dart';
import 'package:glupulse/features/recommendation/data/datasources/recommendation_remote_data_source.dart';
import 'package:glupulse/features/recommendation/data/repositories/recommendation_repository_impl.dart';
import 'package:glupulse/features/recommendation/domain/repositories/recommendation_repository.dart';
import 'package:glupulse/features/recommendation/domain/usecases/post_recommendation.dart';
import 'package:glupulse/features/recommendation/domain/usecases/get_latest_recommendation.dart';
import 'package:glupulse/features/recommendation/domain/usecases/submit_recommendation_feedback.dart';
import 'package:glupulse/features/recommendation/domain/usecases/submit_food_feedback.dart';
import 'package:glupulse/features/recommendation/domain/usecases/submit_activity_feedback.dart';
import 'package:glupulse/features/recommendation/presentation/cubit/recommendation_cubit.dart';
import 'package:glupulse/features/recommendation/presentation/cubit/recommendation_feedback_cubit.dart';
import 'package:glupulse/features/seller/data/datasources/seller_remote_data_source.dart';
import 'package:glupulse/features/seller/data/repositories/seller_repository_impl.dart';
import 'package:glupulse/features/seller/domain/repositories/seller_repository.dart';
import 'package:glupulse/features/seller/domain/usecases/get_seller_by_id.dart';
import 'package:glupulse/features/seller/presentation/cubit/seller_cubit.dart';
import 'package:glupulse/features/orders/data/datasources/order_remote_data_source.dart';
import 'package:glupulse/features/orders/data/repositories/order_repository_impl.dart';
import 'package:glupulse/features/orders/domain/repositories/order_repository.dart';
import 'package:glupulse/features/orders/domain/usecases/get_track_orders_usecase.dart';
import 'package:glupulse/features/orders/domain/usecases/get_order_history_usecase.dart';
import 'package:glupulse/features/orders/presentation/cubit/order_history_cubit.dart';
import 'package:glupulse/features/orders/presentation/cubit/order_track_cubit.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:glupulse/core/network/network_info.dart';

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
      networkInfo: sl(),
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
      networkInfo: sl(),
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
    () => AddressRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
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
  sl.registerFactory(() => FoodCategoryCubit(getFoodCategoriesUseCase: sl()));
  sl.registerFactory(
    () => CartCubit(
      getCartUseCase: sl(),
      addToCartUseCase: sl(),
      updateCartItemUseCase: sl(),
      removeCartItemUseCase: sl(),
    ),
  );
  sl.registerFactory(() => CheckoutCubit(checkoutUseCase: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetFoods(sl()));
  sl.registerLazySingleton(() => GetFoodCategories(sl()));
  sl.registerLazySingleton(() => GetCartUseCase(sl()));
  sl.registerLazySingleton(() => AddToCartUseCase(sl()));
  sl.registerLazySingleton(() => UpdateCartItemUseCase(sl()));
  sl.registerLazySingleton(() => RemoveCartItemUseCase(sl()));
  sl.registerLazySingleton(() => CheckoutUseCase(sl()));

  // Repository
  sl.registerLazySingleton<FoodRepository>(() => FoodRepositoryImpl(
        remoteDataSource: sl(),
        networkInfo: sl(),
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
      networkInfo: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<Hba1cRemoteDataSource>(
    () => Hba1cRemoteDataSourceImpl(apiClient: sl()),
  );

  // --- Features - Glucose ---

  // Cubit
  sl.registerFactory(
    () => GlucoseCubit(
      getGlucoseRecordsUseCase: sl(),
      getGlucoseRecordUseCase: sl(),
      addGlucoseRecordUseCase: sl(),
      updateGlucoseRecordUseCase: sl(),
      deleteGlucoseRecordUseCase: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetGlucoseRecords(sl()));
  sl.registerLazySingleton(() => GetGlucoseRecord(sl()));
  sl.registerLazySingleton(() => AddGlucoseRecord(sl()));
  sl.registerLazySingleton(() => UpdateGlucoseRecord(sl()));
  sl.registerLazySingleton(() => DeleteGlucoseRecord(sl()));

  // Repository
  sl.registerLazySingleton<GlucoseRepository>(
    () => GlucoseRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<GlucoseRemoteDataSource>(
    () => GlucoseRemoteDataSourceImpl(apiClient: sl()),
  );

  // --- Features - Activity ---

  // Cubit
  sl.registerFactory(
    () => ActivityCubit(
      getActivityTypes: sl(),
      getActivityLogs: sl(),
      addActivityLog: sl(),
      updateActivityLog: sl(),
      deleteActivityLog: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetActivityTypes(sl()));
  sl.registerLazySingleton(() => GetActivityLogs(sl()));
  sl.registerLazySingleton(() => AddActivityLog(sl()));
  sl.registerLazySingleton(() => UpdateActivityLog(sl()));
  sl.registerLazySingleton(() => DeleteActivityLog(sl()));

  // Repository
  sl.registerLazySingleton<ActivityRepository>(
    () => ActivityRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<ActivityRemoteDataSource>(
    () => ActivityRemoteDataSourceImpl(apiClient: sl()),
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
      networkInfo: sl(),
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
      networkInfo: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<HealthEventRemoteDataSource>(
    () => HealthEventRemoteDataSourceImpl(apiClient: sl()),
  );

  // --- Features - Sleep Log ---

  // Cubit
  sl.registerFactory(
    () => SleepLogCubit(
      getSleepLogsUseCase: sl(),
      getSleepLogUseCase: sl(),
      addSleepLogUseCase: sl(),
      updateSleepLogUseCase: sl(),
      deleteSleepLogUseCase: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetSleepLogs(sl()));
  sl.registerLazySingleton(() => GetSleepLog(sl()));
  sl.registerLazySingleton(() => AddSleepLog(sl()));
  sl.registerLazySingleton(() => UpdateSleepLog(sl()));
  sl.registerLazySingleton(() => DeleteSleepLog(sl()));

  // Repository
  sl.registerLazySingleton<SleepLogRepository>(
    () => SleepLogRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<SleepLogRemoteDataSource>(
    () => SleepLogRemoteDataSourceImpl(apiClient: sl()),
  );

  // --- Features - Medication ---

  // Cubit
  sl.registerFactory(
    () => MedicationCubit(
      getMedications: sl(),
      addMedication: sl(),
      updateMedication: sl(),
      deleteMedication: sl(),
    ),
  );

  sl.registerFactory(
    () => MedicationLogCubit(
      getMedicationLogs: sl(),
      addMedicationLog: sl(),
      updateMedicationLog: sl(),
      deleteMedicationLog: sl(),
    ),
  );

  // Use Cases - Medication Definitions
  sl.registerLazySingleton(() => GetMedications(sl()));
  sl.registerLazySingleton(() => AddMedication(sl()));
  sl.registerLazySingleton(() => UpdateMedication(sl()));
  sl.registerLazySingleton(() => DeleteMedication(sl()));

  // Use Cases - Medication Logs
  sl.registerLazySingleton(() => GetMedicationLogs(sl()));
  sl.registerLazySingleton(() => AddMedicationLog(sl()));
  sl.registerLazySingleton(() => UpdateMedicationLog(sl()));
  sl.registerLazySingleton(() => DeleteMedicationLog(sl()));

  // Repository
  sl.registerLazySingleton<MedicationRepository>(
    () => MedicationRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<MedicationRemoteDataSource>(
    () => MedicationRemoteDataSourceImpl(apiClient: sl()),
  );

  // --- Features - Meal Log ---

  // Cubit
  sl.registerFactory(
    () => MealLogCubit(
      getMealLogsUseCase: sl(),
      getMealLogUseCase: sl(),
      addMealLogUseCase: sl(),
      updateMealLogUseCase: sl(),
      deleteMealLogUseCase: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetMealLogs(sl()));
  sl.registerLazySingleton(() => GetMealLog(sl()));
  sl.registerLazySingleton(() => AddMealLog(sl()));
  sl.registerLazySingleton(() => UpdateMealLog(sl()));
  sl.registerLazySingleton(() => DeleteMealLog(sl()));

  // Repository
  sl.registerLazySingleton<MealLogRepository>(
    () => MealLogRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<MealLogRemoteDataSource>(
    () => MealLogRemoteDataSourceImpl(apiClient: sl()),
  );

  // --- Features - Recommendation ---

  // Cubit
  sl.registerFactory(
    () => RecommendationCubit(
      postRecommendation: sl(),
      getLatestRecommendation: sl(),
    ),
  );
  sl.registerFactory(
    () => RecommendationFeedbackCubit(
      submitRecommendationFeedback: sl(),
      submitFoodFeedback: sl(),
      submitActivityFeedback: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => PostRecommendation(sl()));
  sl.registerLazySingleton(() => GetLatestRecommendation(sl()));
  sl.registerLazySingleton(() => SubmitRecommendationFeedback(sl()));
  sl.registerLazySingleton(() => SubmitFoodFeedback(sl()));
  sl.registerLazySingleton(() => SubmitActivityFeedback(sl()));

  // Repository
  sl.registerLazySingleton<RecommendationRepository>(
    () => RecommendationRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<RecommendationRemoteDataSource>(
    () => RecommendationRemoteDataSourceImpl(
      apiClient: sl(),
    ),
  );

  // --- Features - Seller ---

  // Cubit
  sl.registerFactory(() => SellerCubit(getSellerById: sl()));

  // Use Cases
  sl.registerLazySingleton(() => GetSellerById(sl()));

  // Repository
  sl.registerLazySingleton<SellerRepository>(
    () => SellerRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<SellerRemoteDataSource>(
    () => SellerRemoteDataSourceImpl(
      apiClient: sl(),
      localDataSource: sl(),
    ),
  );

  // --- Features - Orders ---

  // Cubit
  sl.registerFactory(
    () => OrderTrackCubit(
      getTrackOrdersUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => OrderHistoryCubit(
      getOrderHistoryUseCase: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetTrackOrdersUseCase(sl()));
  sl.registerLazySingleton(() => GetOrderHistoryUseCase(sl()));

  // Repository
  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<OrderRemoteDataSource>(
    () => OrderRemoteDataSourceImpl(
      apiClient: sl(),
      localDataSource: sl(),
    ),
  );

  // --- Core ---
  sl.registerLazySingleton(() => ApiClient());
  // Daftarkan SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Daftarkan http.Client
  sl.registerLazySingleton(() => http.Client());

  // Daftarkan GoogleSignIn sebagai lazy singleton
  sl.registerLazySingleton(() => GoogleSignIn());

  // --- Network Info ---
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => InternetConnectionChecker.instance);
}