import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glupulse/features/recommendation/presentation/cubit/recommendation_cubit.dart';
import 'package:glupulse/features/recommendation/presentation/pages/add_recommendation_page.dart';
import 'package:glupulse/features/recommendation/domain/entities/recommendation_entity.dart';

class RecommendationPage extends StatefulWidget {
  final RecommendationEntity? recommendation;

  const RecommendationPage({super.key, this.recommendation});

  @override
  State<RecommendationPage> createState() => _RecommendationPageState();
}

class _RecommendationPageState extends State<RecommendationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  // late bool _showRecommendations; // Removed

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(); // Rotates slowly for a dynamic effect

    // Only fetch if we don't already have data to avoid flickering/re-loading
    // when coming from AddRecommendationPage or navigating back and forth.
    final cubit = context.read<RecommendationCubit>();
    if (cubit.state is! RecommendationLoaded) {
      cubit.fetchLatestRecommendation();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToAddRecommendation() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const AddRecommendationPage()),
    );
  }

  Future<void> _onRefresh() async {
    await context.read<RecommendationCubit>().fetchLatestRecommendation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      body: BlocConsumer<RecommendationCubit, RecommendationState>(
        listener: (context, state) {
          if (state is RecommendationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          // Always display the header and the permanent "Tap to Get Recommendation" button
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(), // Keep for pull-to-refresh
            child: SafeArea(
              child: Column(
                children: [
                  // --- Header Kustom ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                        const Text(
                          'Recommendation',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // --- Permanent "Tap to Get Recommendation" Button ---
                  // This button will always be visible at the top.
                  Center(
                    child: GestureDetector(
                      onTap: _navigateToAddRecommendation,
                      child: SizedBox(
                        width: 250,
                        height: 250,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Rotating Dashed Circle
                            AnimatedBuilder(
                              animation: _controller,
                              builder: (context, child) {
                                return Transform.rotate(
                                  angle: _controller.value * 2 * math.pi,
                                  child: CustomPaint(
                                    size: const Size(250, 250),
                                    painter: DashedCirclePainter(),
                                  ),
                                );
                              },
                            ),
                            // Inner Circle with Gradient
                            Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF0F67FE), Color(0xFF4C8CFF)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF0F67FE).withOpacity(0.4),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.touch_app_rounded,
                                    size: 48,
                                    color: Colors.white,
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    'Tap to Get\nRecommendation',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Spacing after the button

                  // --- Conditional Content (Loading/Loaded/Error) ---
                  if (state is RecommendationLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (state is RecommendationLoaded)
                    _buildResultContent(state.recommendation)
                  else if (state is RecommendationError)
                    Text('Error: ${state.message}', style: const TextStyle(color: Colors.red))
                  else if (state is RecommendationInitial)
                    const SizedBox.shrink(), // Nothing below the button for initial state
                  
                  const SizedBox(height: 40), // Spacing at the bottom
                ],
              ),
            ),
          );
        },
      ),
      // --- REMOVED FloatingActionButton ---
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _navigateToAddRecommendation,
      //   label: const Text('Add New Recommendation'),
      //   icon: const Icon(Icons.add),
      //   backgroundColor: Theme.of(context).colorScheme.primary,
      //   foregroundColor: Colors.white,
      // ),
    );
  }

  Widget _buildResultContent(RecommendationEntity recommendation) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header - Status Kesehatan Singkat
          _buildSectionHeader(),
          const SizedBox(height: 20),

          // 2. Ringkasan Utama (Insight Card)
          _buildSummaryCard(recommendation.analysisSummary),
          const SizedBox(height: 20),

          // 3. Insight Detail (Expandable)
          _buildDetailAccordion(recommendation.insightsResponse),
          const SizedBox(height: 30),

          // 4. Activity Recommendation
          if (recommendation.activityRecommendations.isNotEmpty) ...[
            Text(
              'Recommended Activities',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey.shade800,
              ),
            ),
            const SizedBox(height: 16),
            ...recommendation.activityRecommendations.map((activity) => 
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _buildActivityCard(activity),
              )
            ),
            const SizedBox(height: 20),
          ],

          // 5. Food Recommendation (Empty State if empty)
          if (recommendation.foodRecommendations.isEmpty)
            _buildFoodEmptyState()
          else ...[
            Text(
              'Recommended Foods',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey.shade800,
              ),
            ),
            const SizedBox(height: 16),
            ...recommendation.foodRecommendations.map((food) => 
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _buildFoodCard(food),
              )
            ),
          ],

          const SizedBox(height: 24),

          // 6. Footer
          Center(
            child: Text(
              'Session ID: ${recommendation.sessionId.split('-').first}...',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade400, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Health Insight',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Weekly Analysis',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.green.shade100),
          ),
          child: Row(
            children: [
              Icon(Icons.check_circle, size: 14, color: Colors.green.shade600),
              const SizedBox(width: 4),
              Text(
                'Controlled',
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String summary) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4C8CFF), Color(0xFF0F67FE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F67FE).withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'Key Focus',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            summary,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailAccordion(String insights) {
    final List<String> bullets = insights.split('. ').where((s) => s.isNotEmpty).toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.lightbulb_outline, color: Colors.purple.shade400, size: 20),
          ),
          title: const Text(
            'Detailed Plan',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          iconColor: Colors.grey,
          children: bullets.map((text) => _buildBulletPoint(text.trim())).toList(),
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: Icon(Icons.check, size: 16, color: Color(0xFF0F67FE)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(ActivityRecommendationEntity activity) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(Icons.directions_run, color: Colors.orange.shade400, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity.activityName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildTag('${activity.recommendedDurationMinutes} min', Colors.blue),
                          _buildTag(activity.recommendedIntensity, Colors.orange),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.description,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 1.4),
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.verified, size: 16, color: Colors.green.shade400),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        activity.reason,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color.shade700,
        ),
      ),
    );
  }

  Widget _buildFoodCard(FoodRecommendationEntity food) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(Icons.restaurant, color: Colors.green.shade400, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        food.foodName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      if (food.nutritionHighlight.isNotEmpty)
                        Text(
                          food.nutritionHighlight,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildCompactMacro('Cal', '${food.calories.toInt()}'),
                          _buildCompactMacro('Prot', '${food.proteinGrams}g'),
                          _buildCompactMacro('Carb', '${food.carbsGrams}g'),
                          _buildCompactMacro('Fat', '${food.fatGrams}g'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    food.reason,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${food.currency} ${food.price.toInt()}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactMacro(String label, String value) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade400)),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade800)),
      ],
    );
  }

  Widget _buildFoodEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Icon(Icons.restaurant_menu_rounded, size: 48, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'No Food Suggestions Yet',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 8),
          Text(
            'Log your meals to get personalized food recommendations.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class DashedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0F67FE).withValues(alpha: 0.5)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 2; // Slight padding

    const double dashWidth = 15;
    const double dashSpace = 15;

    final circumference = 2 * math.pi * radius;
    final dashCount = (circumference / (dashWidth + dashSpace)).floor();
    final anglePerDash = (2 * math.pi) / dashCount;
    final dashAngle = (dashWidth / circumference) * 2 * math.pi;

    for (int i = 0; i < dashCount; i++) {
      // Only draw if it's not in the top gap (visual aesthetic)
      // Or just draw all for a full dashed circle
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        (i * anglePerDash),
        dashAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
