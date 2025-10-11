import 'package:flutter/material.dart';
import 'package:glupulse/app/theme/app_theme.dart';
import 'package:glupulse/features/presentation/screens/auth/login_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


/// Halaman perkenalan utama yang berisi 3 slide.
class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  // Controller untuk mengelola halaman di PageView
  final PageController _pageController = PageController();

  // State untuk melacak apakah sedang di halaman terakhir
  bool _isLastPage = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToHome() {
    // Navigasi ke halaman login setelah introduction selesai.
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Kontainer untuk tombol dan indikator
            Padding(
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

                  // Tombol "Lanjut" atau "Mulai"
                  _isLastPage
                      ? TextButton(
                          onPressed: _navigateToHome,
                          child: const Text(
                            'MULAI',
                            style: TextStyle(
                                color: AppTheme.inputLabelColor,
                                fontWeight: FontWeight.bold),
                          ),
                        )
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

            // PageView untuk menampilkan slide
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
                  // Slide pertama dengan layout khusus
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start, // Mulai dari atas
                    children: [
                      const SizedBox(height: 20), // Beri jarak dari kontrol di atas
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
                        'images/Introduction_1.png',
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
                        onPressed: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: const Text('Get Started', style: TextStyle(fontSize: 16)),
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
                            onPressed: _navigateToHome,
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
                    ],
                  ),
                  IntroPage(
                    imageUrl: 'images/Introduction_2.png',
                    title: 'Personalize Your Health\nwith Smart AI',
                    description: 'Achieve your wellness goals with our AI-powered platform to your unique needs.',
                  ),
                  const IntroPage(
                    imageUrl: 'images/Introduction_3.png',
                    title: 'Your Intelligent Fitness Companion.',
                    description: 'Track your calory & fitness nutrition with AI and get special recommendations.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget untuk membangun satu halaman perkenalan.
class IntroPage extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;

  const IntroPage({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              // Teks judul
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),

              // Deskripsi (jika ada)
              if (description.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(description,
                    textAlign: TextAlign.left,
                    style: const TextStyle(color: AppTheme.inputLabelColor)),
              ],
            ],
          ),
        ),
        const Spacer(), // Mendorong gambar ke bawah
        // Gambar di tengah
        Image.asset(
          imageUrl,
          width: double.infinity,
          fit: BoxFit.fitWidth,
        ),
      ],
    );
  }
}