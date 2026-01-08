import 'package:flutter/material.dart';
import 'package:glupulse/app/theme/app_theme.dart';

class WelcomeIntroPage extends StatelessWidget {
  final VoidCallback onContinue;
  final VoidCallback onSignIn;

  const WelcomeIntroPage({
    super.key,
    required this.onContinue,
    required this.onSignIn,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start, 
        children: [
          const SizedBox(height: 20),
          Text(
            'Welcome to\nGlupulse App',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 40),
          Image.asset(
            'assets/images/Introduction_1.png',
            width: double.infinity,
            fit: BoxFit.fitWidth,
          ),
          const SizedBox(height: 40),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
                'Explore the amazing features of our app to monitor your health.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.inputLabelColor)),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onContinue,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            child: const Text('Lanjutkan', style: TextStyle(fontSize: 16)),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Already have an account? ",
                style: TextStyle(color: AppTheme.inputLabelColor),
              ),
              TextButton(
                onPressed: onSignIn,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Sign In',
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.red),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20), // Beri padding bawah
        ],
      ),
    );
  }
}