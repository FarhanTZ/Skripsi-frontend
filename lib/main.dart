import 'package:flutter/material.dart';

import 'app/theme/app_theme.dart';
import 'features/authentication/presentation/screens/auth/introduction/introduction_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GluPulse',
      theme: AppTheme.lightTheme,
      home: const IntroductionScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
