import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glupulse/splash_screen.dart';
import 'package:glupulse/app/theme/app_theme.dart';
import 'package:glupulse/features/auth/presentation/pages/otp_verification_page.dart';
import 'package:glupulse/home_page.dart';
import 'package:glupulse/injection_container.dart' as di;
import 'package:glupulse/injection_container.dart';
import 'package:glupulse/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:glupulse/features/profile/presentation/pages/edit_profile_page.dart';

import 'features/introduction/presentation/pages/introduction_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init(); // Inisialisasi service locator
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthCubit>()..checkAuthenticationStatus(),
      child: MaterialApp(
        title: 'GluPulse',
        theme: AppTheme.lightTheme,
        home: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading || state is AuthInitial) {
              // Tampilkan splash screen saat memeriksa status autentikasi
              return const SplashScreen();
            } else if (state is AuthAuthenticated) {
              // Jika sudah terotentikasi, langsung ke HomePage
              return const HomePage(); // Pastikan HomePage sudah di-import
            } else if (state is AuthProfileIncomplete) {
              // Jika profil tidak lengkap, arahkan untuk melengkapi
              return const EditProfilePage(isFromAuthFlow: true);
            } else if (state is AuthOtpRequired) {
              // Jika butuh verifikasi OTP, arahkan ke OtpVerificationPage
              return OtpVerificationPage(userId: state.user.id);
            }
            // Jika tidak (AuthUnauthenticated, AuthError), tampilkan IntroductionScreen
            // yang akan mengarahkan ke LoginPage
            return const IntroductionScreen();
          },
        ),
      ),
    );
  }
}

// Path: d:\Skripsi\Codingan_Skirpsi\Frontend\glupulse\lib\features\auth\presentation\pages\login_page.dart
