import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glupulse/features/recommendation/presentation/cubit/recommendation_cubit.dart';
import 'package:glupulse/features/recommendation/presentation/cubit/recommendation_feedback_cubit.dart';
import 'package:glupulse/features/recommendation/presentation/pages/add_recommendation_page.dart';
import 'package:glupulse/features/recommendation/domain/entities/recommendation_entity.dart';
import 'package:glupulse/injection_container.dart' as di;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:glupulse/features/Food/presentation/pages/food_detail_page.dart';
import 'package:glupulse/features/Food/domain/entities/food.dart';

class RecommendationPage extends StatefulWidget {
  final RecommendationEntity? recommendation;

  const RecommendationPage({super.key, this.recommendation});

  @override
  State<RecommendationPage> createState() => _RecommendationPageState();
}

class _RecommendationPageState extends State<RecommendationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final PageController _activityPageController = PageController();
  final PageController _foodPageController = PageController();
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
    _activityPageController.dispose();
    _foodPageController.dispose();
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

  void _showFeedbackDialog(BuildContext context, String sessionId) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider(
        create: (context) => di.sl<RecommendationFeedbackCubit>(),
        child: _FeedbackDialog(sessionId: sessionId),
      ),
    );
  }

  void _showFoodFeedbackDialog(BuildContext context, String recommendationFoodId, String foodId, String foodName) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider(
        create: (context) => di.sl<RecommendationFeedbackCubit>(),
        child: _FoodFeedbackDialog(recommendationFoodId: recommendationFoodId, foodId: foodId, foodName: foodName),
      ),
    );
  }

  void _showActivityFeedbackDialog(BuildContext context, String recommendationActivityId, int activityId, String activityName) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider(
        create: (context) => di.sl<RecommendationFeedbackCubit>(),
        child: _ActivityFeedbackDialog(recommendationActivityId: recommendationActivityId, activityId: activityId, activityName: activityName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      body: BlocBuilder<RecommendationCubit, RecommendationState>(
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
                    Text('Belum ada data recommendation, silakan get recommendation terlebih dahulu', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade600, fontSize: 16))
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

  Widget _buildActivityEmptyState() {
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
          Icon(Icons.directions_run_rounded, size: 48, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'Belum ada rekomendasi aktivitas',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey.shade700),
          ),
        ],
      ),
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
          Text(
            'Recommended Activities',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey.shade800,
            ),
          ),
          const SizedBox(height: 16),
          if (recommendation.activityRecommendations.isNotEmpty) ...[
            SizedBox(
              height: 200,
              child: PageView.builder(
                controller: _activityPageController,
                itemCount: recommendation.activityRecommendations.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: _buildActivityCard(recommendation.activityRecommendations[index]),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: SmoothPageIndicator(
                controller: _activityPageController,
                count: recommendation.activityRecommendations.length,
                effect: ExpandingDotsEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: Theme.of(context).colorScheme.primary,
                  dotColor: Colors.grey.shade300,
                ),
              ),
            ),
          ] else
            _buildActivityEmptyState(),
          const SizedBox(height: 20),

          // 5. Food Recommendation (Empty State if empty)
          Text(
            'Recommended Foods',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey.shade800,
            ),
          ),
          const SizedBox(height: 16),
          if (recommendation.foodRecommendations.isEmpty)
            _buildFoodEmptyState()
          else ...[
            SizedBox(
              height: 280,
              child: PageView.builder(
                controller: _foodPageController,
                itemCount: recommendation.foodRecommendations.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: _buildFoodCard(recommendation.foodRecommendations[index]),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: SmoothPageIndicator(
                controller: _foodPageController,
                count: recommendation.foodRecommendations.length,
                effect: ExpandingDotsEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: Theme.of(context).colorScheme.primary,
                  dotColor: Colors.grey.shade300,
                ),
              ),
            ),
          ],

          // 6. Footer (Feedback Button & Session Info)
          const SizedBox(height: 24),
          Center(
            child: OutlinedButton.icon(
              onPressed: () => _showFeedbackDialog(context, recommendation.sessionId),
              icon: const Icon(Icons.feedback_outlined),
              label: const Text('Give Feedback'),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
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
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          childrenPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          iconColor: Colors.white,
          collapsedIconColor: Colors.white,
          title: Row(
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
          children: [
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
    final imageAsset = _getImageAssetForActivity(activity.activityCode);
    final cardColor = _getColorForActivity(activity.activityCode);

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
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 180,
        child: Stack(
          children: [
            Row(
              children: [
                // LEFT SIDE: Content
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon Container
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: cardColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            _getIconForActivity(activity.activityCode),
                            size: 24,
                            color: cardColor,
                          ),
                        ),
                        const Spacer(),
                        // Activity Name
                        Text(
                          activity.activityName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        // Tags (Duration & Intensity)
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            _buildTag('${activity.recommendedDurationMinutes} min', Colors.blue),
                            _buildTag(activity.recommendedIntensity, Colors.orange),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                // RIGHT SIDE: Image or Fallback
                Expanded(
                  flex: 2,
                  child: Container(
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: cardColor.withOpacity(0.05),
                    ),
                    child: imageAsset != null
                        ? Image.asset(
                              imageAsset,
                              fit: BoxFit.cover, 
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(
                                    _getIconForActivity(activity.activityCode),
                                    size: 50,
                                    color: cardColor.withOpacity(0.5),
                                  ),
                                );
                              },
                            )
                        : Center(
                            child: Icon(
                              _getIconForActivity(activity.activityCode),
                              size: 60,
                              color: cardColor.withOpacity(0.3),
                            ),
                          ),
                  ),
                ),
              ],
            ),
            // Feedback Button Overlay
            Positioned(
              top: 8,
              right: 8,
              child: Material(
                color: Colors.white.withOpacity(0.9),
                shape: const CircleBorder(),
                elevation: 2,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => _showActivityFeedbackDialog(
                    context,
                    activity.recommendationActivityId,
                    activity.activityId,
                    activity.activityName,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.feedback_outlined,
                      size: 18,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _getImageAssetForActivity(String code) {
    if (code == 'CALISTHENICS') {
      return 'assets/images/aktivity/Calisthenics.png';
    } else if (code == 'DANCE') {
      return 'assets/images/aktivity/Dancing.png';
    } else if (code == 'CYCLING_LIGHT' || code == 'CYCLING_INTENSE') {
      return 'assets/images/aktivity/Cyling.png';
    } else if (code == 'HIIT') {
      return 'assets/images/aktivity/High_Intensity_Interval_Training.jpg';
    } else if (code == 'HIKING') {
      return 'assets/images/aktivity/Hiking.png';
    } else if (code == 'HOUSEWORK') {
      return 'assets/images/aktivity/Household_Chores.png';
    } else if (code == 'MARTIAL_ARTS') {
      return 'assets/images/aktivity/Martial_arts _Boxing.png';
    } else if (code == 'OCCUPATIONAL') {
      return 'assets/images/aktivity/Occupational_Labor.png';
    } else if (code == 'RACKET_SPORTS') {
      return 'assets/images/aktivity/Raket Sports (Badminton, Tenis).png';
    }
    return null;
  }

  IconData _getIconForActivity(String code) {
    switch (code) {
      case 'RUNNING':
        return Icons.directions_run;
      case 'WALKING':
        return Icons.directions_walk;
      case 'CYCLING_LIGHT':
      case 'CYCLING_INTENSE':
        return Icons.directions_bike;
      case 'SWIMMING':
        return Icons.pool;
      case 'YOGA_PILATES':
        return Icons.self_improvement;
      case 'WEIGHT_LIFTING':
        return Icons.fitness_center;
      case 'HIIT':
        return Icons.timer;
      case 'DANCE':
        return Icons.music_note;
      case 'HIKING':
        return Icons.hiking;
      case 'TEAM_SPORTS':
        return Icons.sports_basketball;
      case 'RACKET_SPORTS':
        return Icons.sports_tennis;
      case 'MARTIAL_ARTS':
        return Icons.sports_mma;
      case 'HOUSEWORK':
        return Icons.cleaning_services;
      case 'OCCUPATIONAL':
        return Icons.work;
      case 'CALISTHENICS':
        return Icons.accessibility_new;
      default:
        return Icons.sports;
    }
  }
  
  Color _getColorForActivity(String code) {
      switch (code) {
      case 'RUNNING':
      case 'HIIT':
      case 'MARTIAL_ARTS':
        return Colors.red;
      case 'WALKING':
      case 'YOGA_PILATES':
      case 'HOUSEWORK':
        return Colors.green;
      case 'CYCLING_LIGHT':
      case 'CYCLING_INTENSE':
      case 'RACKET_SPORTS':
        return Colors.orange;
      case 'SWIMMING':
      case 'TEAM_SPORTS':
        return Colors.blue;
      case 'WEIGHT_LIFTING':
      case 'CALISTHENICS':
      case 'HIKING':
        return Colors.brown;
      case 'DANCE':
        return Colors.purple;
      default:
        return Colors.blueGrey;
    }
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
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              final foodEntity = Food(
                foodId: food.foodId,
                sellerId: 'recommendation', 
                foodName: food.foodName,
                description: food.description,
                price: food.price.toInt(),
                currency: food.currency,
                photoUrl: null, 
                isAvailable: true,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
                calories: food.calories,
                carbsGrams: food.carbsGrams,
                proteinGrams: food.proteinGrams,
                fatGrams: food.fatGrams,
              );
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => FoodDetailPage(food: foodEntity),
              ));
            },
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
                            Padding(
                              padding: const EdgeInsets.only(right: 24.0),
                              child: Text(
                                food.foodName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => _showFoodFeedbackDialog(
                  context,
                  food.recommendationFoodId,
                  food.foodId,
                  food.foodName,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.feedback_outlined,
                    size: 20,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
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
            'Belum ada rekomendasi makanan',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey.shade700),
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

class _FeedbackDialog extends StatefulWidget {
  final String sessionId;

  const _FeedbackDialog({required this.sessionId});

  @override
  State<_FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<_FeedbackDialog> {
  String _overallFeedback = 'helpful';
  final TextEditingController _notesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RecommendationFeedbackCubit, RecommendationFeedbackState>(
      listener: (context, state) {
        if (state is RecommendationFeedbackSuccess) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Feedback submitted successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is RecommendationFeedbackError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is RecommendationFeedbackLoading;
        final primaryColor = Theme.of(context).colorScheme.primary;

        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.thumb_up_alt_outlined, color: primaryColor),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Session Feedback',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'How helpful was this session?',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _overallFeedback,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'very_helpful', child: Text('🌟 Very Helpful')),
                      DropdownMenuItem(value: 'helpful', child: Text('👍 Helpful')),
                      DropdownMenuItem(value: 'neutral', child: Text('😐 Neutral')),
                      DropdownMenuItem(value: 'unhelpful', child: Text('👎 Unhelpful')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _overallFeedback = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Additional Notes',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Any specific feedback?',
                      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: primaryColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(foregroundColor: Colors.grey),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                      if (_formKey.currentState!.validate()) {
                        context.read<RecommendationFeedbackCubit>().submitOverallFeedback(
                              widget.sessionId,
                              _overallFeedback,
                              _notesController.text,
                            );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}

class _FoodFeedbackDialog extends StatefulWidget {
  final String recommendationFoodId;
  final String foodId;
  final String foodName;

  const _FoodFeedbackDialog({required this.recommendationFoodId, required this.foodId, required this.foodName});

  @override
  State<_FoodFeedbackDialog> createState() => _FoodFeedbackDialogState();
}

class _FoodFeedbackDialogState extends State<_FoodFeedbackDialog> {
  int _rating = 0;
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _glucoseSpikeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _notesController.dispose();
    _glucoseSpikeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RecommendationFeedbackCubit, RecommendationFeedbackState>(
      listener: (context, state) {
        if (state is RecommendationFeedbackSuccess) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Food feedback submitted successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is RecommendationFeedbackError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is RecommendationFeedbackLoading;
        final primaryColor = Theme.of(context).colorScheme.primary;

        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.restaurant, color: Colors.orange),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.foodName,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Rate this food',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: _StarRating(
                      rating: _rating,
                      onRatingChanged: (rating) => setState(() => _rating = rating),
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Glucose Spike (mg/dL)',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _glucoseSpikeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'e.g. 15',
                      suffixText: 'mg/dL',
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      prefixIcon: const Icon(Icons.trending_up, color: Colors.redAccent, size: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.orange),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Invalid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Notes',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _notesController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: 'Did you enjoy it?',
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.orange),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(foregroundColor: Colors.grey),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                      if (_rating == 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please select a rating')),
                        );
                        return;
                      }
                      if (_formKey.currentState!.validate()) {
                        context.read<RecommendationFeedbackCubit>().submitFoodFeedbackEntry(
                              widget.recommendationFoodId,
                              widget.foodId,
                              _rating,
                              _notesController.text,
                              int.parse(_glucoseSpikeController.text),
                            );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}

class _ActivityFeedbackDialog extends StatefulWidget {
  final String recommendationActivityId;
  final int activityId;
  final String activityName;

  const _ActivityFeedbackDialog({required this.recommendationActivityId, required this.activityId, required this.activityName});

  @override
  State<_ActivityFeedbackDialog> createState() => _ActivityFeedbackDialogState();
}

class _ActivityFeedbackDialogState extends State<_ActivityFeedbackDialog> {
  int _rating = 0;
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _glucoseChangeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _notesController.dispose();
    _glucoseChangeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RecommendationFeedbackCubit, RecommendationFeedbackState>(
      listener: (context, state) {
        if (state is RecommendationFeedbackSuccess) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Activity feedback submitted successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is RecommendationFeedbackError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is RecommendationFeedbackLoading;

        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.directions_run, color: Colors.blue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.activityName,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Rate this activity',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: _StarRating(
                      rating: _rating,
                      onRatingChanged: (rating) => setState(() => _rating = rating),
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Glucose Change (mg/dL)',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Use negative (-) for drop, positive (+) for rise',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _glucoseChangeController,
                    keyboardType: const TextInputType.numberWithOptions(signed: true),
                    decoration: InputDecoration(
                      hintText: 'e.g. -15',
                      suffixText: 'mg/dL',
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      prefixIcon: const Icon(Icons.show_chart, color: Colors.blueAccent, size: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Invalid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Notes',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _notesController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: 'How did you feel?',
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(foregroundColor: Colors.grey),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                      if (_rating == 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please select a rating')),
                        );
                        return;
                      }
                      if (_formKey.currentState!.validate()) {
                        context.read<RecommendationFeedbackCubit>().submitActivityFeedbackEntry(
                              widget.recommendationActivityId,
                              widget.activityId,
                              _rating,
                              _notesController.text,
                              int.parse(_glucoseChangeController.text),
                            );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}

class _StarRating extends StatelessWidget {
  final int rating;
  final ValueChanged<int> onRatingChanged;
  final Color color;

  const _StarRating({
    required this.rating,
    required this.onRatingChanged,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () => onRatingChanged(index + 1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Icon(
              index < rating ? Icons.star_rounded : Icons.star_outline_rounded,
              color: index < rating ? color : Colors.grey.shade400,
              size: 36,
            ),
          ),
        );
      }),
    );
  }
}