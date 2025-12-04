import 'package:flutter/material.dart';
import 'dart:math' as math;
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
  late bool _showRecommendations;

  @override
  void initState() {
    super.initState();
    _showRecommendations = widget.recommendation != null;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(); // Rotates slowly for a dynamic effect
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              // --- Header Kustom ---
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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

              if (!_showRecommendations) ...[
                const SizedBox(height: 20),

                // --- Circle Button ---
                Center(
                  child: GestureDetector(
                    onTap: _navigateToAddRecommendation, // Changed onTap
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
                                  color: const Color(0xFF0F67FE)
                                      .withValues(alpha: 0.4),
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
                const SizedBox(height: 20),
              ],

              // Removed if (!_showRecommendations) block here
              if (_showRecommendations && widget.recommendation != null) ...[
                const SizedBox(height: 20),
                _buildResultContent(widget.recommendation!),
                const SizedBox(height: 40),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultContent(RecommendationEntity recommendation) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header - Status Kesehatan Singkat
          _buildSectionHeader(),
          const SizedBox(height: 16),

          // 2. Ringkasan Utama (Insight Card)
          _buildSummaryCard(recommendation.analysisSummary),
          const SizedBox(height: 16),

          // 3. Insight Detail (Expandable)
          _buildDetailAccordion(recommendation.insightsResponse),
          const SizedBox(height: 24),

          // 4. Activity Recommendation
          if (recommendation.activityRecommendations.isNotEmpty) ...[
            const Text(
              'Aktivitas yang Disarankan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...recommendation.activityRecommendations.map((activity) => 
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: _buildActivityCard(activity),
              )
            ),
            const SizedBox(height: 24),
          ],

          // 5. Food Recommendation (Empty State if empty)
          if (recommendation.foodRecommendations.isEmpty)
            _buildFoodEmptyState()
          else ...[
            const Text(
              'Rekomendasi Makanan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...recommendation.foodRecommendations.map((food) => 
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: _buildFoodCard(food),
              )
            ),
          ],

          const SizedBox(height: 24),

          // 6. Footer
          Center(
            child: Text(
              'Sesi dibuat: ${DateTime.now().toString().split('.')[0]}\nSession ID: ${recommendation.sessionId}',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade400, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border:
            Border(left: BorderSide(color: Colors.green.shade400, width: 6)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Health Insight Mingguan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                'Berlaku sampai 8 Des 2025',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Terkontrol',
              style: TextStyle(
                color: Colors.green.shade700,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String summary) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4C8CFF), Color(0xFF0F67FE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F67FE).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.auto_awesome, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                'Fokus Utama Minggu Ini',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            summary.length > 100 ? '${summary.substring(0, 100)}...' : summary, // Truncate for card title if needed, or show full
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16, // Reduced font size slightly for potentially long text
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Prioritas: Kontrol gula setelah makan & aktivitas rutin', // Static for now as it's not clearly in JSON
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailAccordion(String insights) {
    // Simple split by periods to simulate bullets if the text is a paragraph
    final List<String> bullets = insights.split('. ').where((s) => s.isNotEmpty).toList();

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        title: const Text(
          'Insight & Rencana Perbaikan',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: bullets.map((text) => _buildBulletPoint(text.trim())).toList(),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2.0),
            child: Icon(Icons.check_circle_outline, size: 16,
                color: Color(0xFF0F67FE)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
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
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.directions_walk, color: Colors.orange.shade700),
            ),
            title: Text(
              activity.activityName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(activity.description, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.timer_outlined,
                          size: 14, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text('${activity.recommendedDurationMinutes} menit',
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade600)),
                      const SizedBox(width: 12),
                      Icon(Icons.flash_on,
                          size: 14, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text('Intensitas: ${activity.recommendedIntensity}',
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade600)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '✅ Manfaat: ${activity.reason}',
                    style:
                        TextStyle(fontSize: 12, color: Colors.green.shade700),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '⚠️ ${activity.safetyNote}',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange.shade800,
                        fontStyle: FontStyle.italic),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F67FE),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  ),
                  child: const Text('Mulai'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodCard(FoodRecommendationEntity food) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.restaurant, color: Colors.green.shade700),
            ),
            title: Text(
              food.foodName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (food.nutritionHighlight.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        food.nutritionHighlight,
                        style: TextStyle(fontSize: 10, color: Colors.blue.shade700, fontWeight: FontWeight.bold),
                      ),
                    ),
                  Text(
                    food.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMacroItem('Kalori', '${food.calories.toInt()} kcal'),
                      _buildMacroItem('Protein', '${food.proteinGrams}g'),
                      _buildMacroItem('Carbs', '${food.carbsGrams}g'),
                      _buildMacroItem('Fat', '${food.fatGrams}g'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '✅ ${food.reason}',
                    style: TextStyle(fontSize: 12, color: Colors.green.shade700),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Expanded(
                  child: Text(
                    'Saran Porsi: ${food.portionSuggestion}',
                     style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange.shade800,
                        fontStyle: FontStyle.italic),
                  ),
                ),
                Text(
                  '${food.currency} ${food.price.toInt()}', // Simple formatting
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
        Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildFoodEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.restaurant_menu_rounded,
                size: 32, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          const Text(
            'Rekomendasi Makanan',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'Belum tersedia untuk sesi ini.\nSilakan input log makan terbaru agar rekomendasi lebih akurat.',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.grey.shade600, fontSize: 13, height: 1.4),
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
