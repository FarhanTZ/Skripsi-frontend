import 'package:flutter/material.dart';

class BmiDetailPage extends StatelessWidget {
  final double? heightCm;
  final double? currentWeightKg;
  final double? bmi;
  final double? targetWeightKg;

  const BmiDetailPage({
    super.key,
    required this.heightCm,
    required this.currentWeightKg,
    required this.bmi,
    this.targetWeightKg,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // --- Consolidated Header and Your BMI Section ---
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF0F67FE),
                      Color(0xFF4C8CFF),
                    ],
                  ),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(50),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0F67FE).withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 32.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back,
                                    color: Colors.white),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ),
                            const Text(
                              'BMI Details',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Your BMI",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              bmi != null ? bmi!.toStringAsFixed(1) : 'N/A',
                              style: const TextStyle(
                                fontSize: 72,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // BMI Status Badge
                            Builder(
                              builder: (context) {
                                final statusInfo = _getBmiStatus(bmi);
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: statusInfo['bgColor'],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    statusInfo['status'],
                                    style: TextStyle(
                                      color: statusInfo['textColor'],
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // --- Content outside blue header ---
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16), 

                    // --- Measurements Section (Scrollable Row) ---
                    const Text(
                      "Measurements",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          // Height Card
                          SizedBox(
                            width: 170, // Increased width
                            height: 160,
                            child: _buildMeasurementCard(
                              label: "Height",
                              value: heightCm != null
                                  ? '${heightCm!.toStringAsFixed(1)} cm'
                                  : 'N/A',
                              icon: Icons.height,
                              iconForegroundColor: Colors.blue.shade600,
                              context: context,
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Weight Card
                          SizedBox(
                            width: 170,
                            height: 160,
                            child: _buildMeasurementCard(
                              label: "Weight",
                              value: currentWeightKg != null
                                  ? '${currentWeightKg!.toStringAsFixed(1)} kg'
                                  : 'N/A',
                              icon: Icons.scale,
                              iconForegroundColor: Colors.orange.shade600,
                              context: context,
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Target Weight Card
                          SizedBox(
                            width: 170,
                            height: 160,
                            child: _buildMeasurementCard(
                              label: "Target Weight",
                              value: targetWeightKg != null
                                  ? '${targetWeightKg!.toStringAsFixed(1)} kg'
                                  : 'N/A',
                              icon: Icons.track_changes,
                              iconForegroundColor: Colors.lightGreen.shade600,
                              context: context,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // --- BMI Categories Section ---
                    const Text(
                      'BMI Categories Reference',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildBmiCategoryRow('Underweight', '< 18.5',
                              const Color(0xFFFDFD66)),
                          const Divider(),
                          _buildBmiCategoryRow('Normal', '18.5 - 24.9',
                              const Color(0xFF9CF0A6)),
                          const Divider(),
                          _buildBmiCategoryRow('Overweight', '25 - 29.9',
                              Colors.orange.shade200),
                          const Divider(),
                          _buildBmiCategoryRow('Obesity', '>= 30',
                              const Color(0xFFFA4D5E)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  Widget _buildMeasurementCard({
    required BuildContext context,
    required String label,
    required String value,
    required IconData icon,
    required Color iconForegroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16), // Fixed padding
      decoration: BoxDecoration(
        color: Colors.white, // Fixed color
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconForegroundColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 24, color: iconForegroundColor),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildBmiCategoryRow(String label, String range, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Text(
            range,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getBmiStatus(double? bmi) {
    if (bmi == null || bmi <= 0) {
      return {
        'value': 'N/A',
        'status': 'No Data',
        'bgColor': Colors.grey.shade300,
        'textColor': Colors.black54,
      };
    }

    if (bmi < 18.5) {
      return {
        'status': 'Underweight',
        'bgColor': const Color(0xFFFDFD66),
        'textColor': const Color(0xFFB7B726)
      };
    } else if (bmi >= 18.5 && bmi < 25) {
      return {
        'status': 'Normal',
        'bgColor': const Color(0xFF9CF0A6),
        'textColor': const Color(0xFF02A916)
      };
    } else if (bmi >= 25 && bmi < 30) {
      return {
        'status': 'Overweight',
        'bgColor': Colors.orange.shade100,
        'textColor': Colors.orange.shade800
      };
    } else {
      return {
        'status': 'Obesity',
        'bgColor': const Color(0xFFFA4D5E),
        'textColor': const Color(0xFFBF070A)
      };
    }
  }
}
