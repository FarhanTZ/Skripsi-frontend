import 'package:flutter/material.dart';
import 'package:glupulse/app/theme/app_theme.dart';
import 'package:glupulse/features/auth/presentation/pages/login_page.dart';
import 'package:glupulse/features/introduction/presentation/widgets/intro_page_widget.dart';
import 'package:glupulse/features/introduction/presentation/widgets/final_intro_page_widget.dart';
import 'package:glupulse/features/introduction/presentation/widgets/welcome_intro_page_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';



class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {

  final PageController _pageController = PageController();


  bool _isLastPage = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Indikator Halaman
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: 3,
                    effect: const ExpandingDotsEffect(
                      dotHeight: 8,
                      dotWidth: 16,
                      spacing: 6,
                      activeDotColor: AppTheme.inputLabelColor,
                      dotColor: Colors.black26,
                    ),
                    onDotClicked: (index) => _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeIn,
                    ),
                  ),


                  _isLastPage
                      ? const SizedBox.shrink() // Sembunyikan tombol 'MULAI' di halaman terakhir
                      : TextButton(
                          onPressed: () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeIn,
                            );
                          },
                          child: const Text(
                            'LANJUT',
                            style: TextStyle(
                                color: AppTheme.inputLabelColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                ],
              ),
            ),


            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    // Halaman terakhir adalah index 2 (karena dimulai dari 0)
                    _isLastPage = index == 2;
                  });
                },
                children: [

                  WelcomeIntroPage(
                    onContinue: () => _pageController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeIn,
                    ),
                    onSignIn: _navigateToHome,
                  ),

                  IntroPage(
                    imageUrl: 'assets/images/Introduction_2.png',
                    title: 'Personalize Your Health\nwith Smart AI',
                    description: 'Achieve your wellness goals with our AI-powered platform to your unique needs.',
                  ),

                  FinalIntroPage(
                    imageUrl: 'assets/images/Introduction_3.png',
                    title: 'Your Intelligent Fitness Companion.',
                    description: 'Track your calory & fitness nutrition with AI and get special recommendations.',
                    onGetStarted: _navigateToHome,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}