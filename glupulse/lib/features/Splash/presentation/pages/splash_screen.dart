import 'package:flutter/material.dart';
import 'dart:math';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Controller utama untuk semua animasi di splash screen
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    // Animasi untuk efek lingkaran yang melebar (dari 0% hingga 100% durasi)
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );

    // Animasi untuk fade-in teks (dimulai dari 40% hingga 100% durasi)
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.75, 1.0, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Warna latar belakang awal sebelum animasi dimulai
      backgroundColor: const Color(0xFFF2F5F9),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Widget yang akan menganimasikan latar belakang biru yang melebar
          AnimatedBuilder(
            animation: _expandAnimation,
            builder: (context, child) {
              return CustomPaint(
                painter: _CirclePainter(
                  radius: _expandAnimation.value,
                  color: Theme.of(context).colorScheme.primary,
                  screenSize: MediaQuery.of(context).size,
                ),
                child: Container(),
              );
            },
          ),
          // Teks yang akan muncul dengan efek fade
          FadeTransition(
            opacity: _fadeAnimation,
            child: ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  Colors.white,
                  Color(0xFFE0E0E0),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(
                Rect.fromLTWH(0, 0, bounds.width, bounds.height),
              ),
              child: const Text(
                'Glupulse',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans', // Menggunakan font Plus Jakarta Sans
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter untuk menggambar lingkaran yang membesar
class _CirclePainter extends CustomPainter {
  final double radius;
  final Color color;
  final Size screenSize;

  _CirclePainter({required this.radius, required this.color, required this.screenSize});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    // Hitung radius maksimal yang dibutuhkan untuk menutupi seluruh layar
    final maxRadius = sqrt(pow(screenSize.width, 2) + pow(screenSize.height, 2));
    canvas.drawCircle(size.center(Offset.zero), radius * maxRadius, paint);
  }

  @override
  bool shouldRepaint(covariant _CirclePainter oldDelegate) {
    return oldDelegate.radius != radius;
  }
}