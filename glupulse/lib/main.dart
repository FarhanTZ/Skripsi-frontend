import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glupulse/features/HealthData/presentation/cubit/health_profile_cubit.dart';
import 'package:glupulse/features/Splash/presentation/pages/splash_screen.dart';
import 'package:glupulse/app/theme/app_theme.dart';
import 'package:glupulse/features/auth/presentation/cubit/auth_state.dart';
import 'package:glupulse/features/auth/presentation/pages/otp_verification_page.dart';
import 'package:glupulse/features/hba1c/presentation/cubit/hba1c_cubit.dart';
import 'package:glupulse/features/glucose/presentation/cubit/glucose_cubit.dart';
import 'package:glupulse/features/health_event/presentation/cubit/health_event_cubit.dart';
import 'package:glupulse/navbar_button.dart';
import 'package:glupulse/injection_container.dart' as di;
import 'package:glupulse/injection_container.dart';
import 'package:glupulse/features/Food/presentation/cubit/food_cubit.dart';
import 'package:glupulse/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:glupulse/features/profile/presentation/pages/edit_profile_page.dart';
import 'features/introduction/presentation/pages/introduction_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init(); // Inisialisasi service locator
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthCubit>()..checkAuthenticationStatus()),
        BlocProvider(create: (_) => sl<FoodCubit>()),
        BlocProvider(create: (_) => sl<Hba1cCubit>()),
        BlocProvider(create: (_) => sl<GlucoseCubit>()),
        BlocProvider(create: (_) => sl<HealthEventCubit>()),
        BlocProvider(create: (_) => sl<HealthProfileCubit>()),
        BlocProvider(create: (_) => sl<GlucoseCubit>()),
        // Tambah cubit lain yang harus global di sini
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'GluPulse',
        theme: AppTheme.lightTheme,
        home: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading || state is AuthInitial) {
              return const SplashScreen();
            } else if (state is AuthAuthenticated) {
              return const HomePage();
            } else if (state is AuthProfileIncomplete) {
              return const EditProfilePage(isFromAuthFlow: true);
            } else if (state is AuthOtpRequired) {
              return OtpVerificationPage(
                userId: state.userId,
                pendingId: state.pendingId,
              );
            }
            return const IntroductionScreen();
          },
        ),
      ),
    );
  }
}

