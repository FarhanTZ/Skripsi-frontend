import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glupulse/features/HealthData/presentation/cubit/health_profile_cubit.dart';
import 'package:glupulse/features/glucose/presentation/cubit/glucose_cubit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glupulse/features/glucose/presentation/pages/glucose_list_page.dart';
import 'package:glupulse/features/HealthData/presentation/cubit/health_profile_state.dart';
import 'package:glupulse/features/hba1c/presentation/cubit/hba1c_cubit.dart';
import 'package:glupulse/features/hba1c/presentation/pages/hba1c_list_page.dart';
import 'package:glupulse/features/health_event/presentation/pages/health_event_list_page.dart';
import 'package:glupulse/features/activity/presentation/pages/activity_type_list_page.dart';

import 'package:glupulse/features/sleep_log/presentation/pages/sleep_log_list_page.dart';
import 'package:glupulse/features/medication/presentation/pages/medication_log_list_page.dart';
import 'package:glupulse/features/meal_log/presentation/pages/meal_log_page.dart';
import 'package:glupulse/features/recommendation/presentation/pages/recommendation_page.dart';

class AnalyticTab extends StatefulWidget {
  const AnalyticTab({super.key});

  @override
  State<AnalyticTab> createState() => _AnalyticTabState();
}

class _AnalyticTabState extends State<AnalyticTab> {
  @override
  void initState() {
    super.initState();
    context.read<Hba1cCubit>().getHba1cRecords();
    context.read<GlucoseCubit>().getGlucoseRecords();
    context.read<HealthProfileCubit>().fetchHealthProfile();
  }

  void _getRecommendation(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const RecommendationPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ConstrainedBox(
      constraints:
          BoxConstraints(minHeight: MediaQuery.of(context).size.height),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // --- 1. HEADER SECTION ---
            Container(
              width: double.infinity,
              // Removed fixed height 400 to let content dictate, but added padding
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0F67FE),
                    Color(0xFF4C8CFF), // Slightly lighter blue for gradient
                  ],
                ),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F67FE).withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 40.0, top: 20),
                  child: Column(
                    children: [
                      // Status Badge Top Right
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: BlocBuilder<Hba1cCubit, Hba1cState>(
                            builder: (context, state) {
                              if (state is Hba1cLoaded &&
                                  state.hba1cRecords.isNotEmpty) {
                                final sortedRecords =
                                    List.from(state.hba1cRecords)
                                      ..sort((a, b) =>
                                          b.testDate.compareTo(a.testDate));
                                final latestRecord = sortedRecords.first;
                                final statusInfo =
                                    _getHba1cStatus(latestRecord.hba1cPercentage);
                                return _buildStatusBadge(
                                  statusInfo['text']!,
                                  // Use white/glass effect for better contrast on gradient
                                  Colors.white.withValues(alpha: 0.2),
                                  Colors.white,
                                );
                              }
                              return _buildStatusBadge(
                                  'No Data',
                                  Colors.white.withValues(alpha: 0.2),
                                  Colors.white70);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Main Hba1c Display
                      BlocBuilder<Hba1cCubit, Hba1cState>(
                        builder: (context, state) {
                          String hba1cValue = '0.0%';
                          String hba1cStatus = 'No data available.';

                          if (state is Hba1cLoaded &&
                              state.hba1cRecords.isNotEmpty) {
                            final sortedRecords = List.from(state.hba1cRecords)
                              ..sort(
                                  (a, b) => b.testDate.compareTo(a.testDate));
                            final latestRecord = sortedRecords.first;
                            hba1cValue =
                                '${latestRecord.hba1cPercentage.toStringAsFixed(1)}%';
                            hba1cStatus = _getHba1cStatusMessage(
                                latestRecord.hba1cPercentage);
                          }

                          return Column(
                            children: [
                              Text(
                                hba1cValue,
                                style: const TextStyle(
                                  fontSize: 72, // Slightly smaller for balance
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  height: 1.0,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Last Hba1c',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Text(
                                  hba1cStatus,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withValues(alpha: 0.85),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),

            // --- 2. QUICK ACTIONS MENU (Floating overlap) ---
            Transform.translate(
              offset: const Offset(0, -25),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildQuickActionItem(
                      context,
                      'Hba1c',
                      'assets/images/health-rate.svg', // Placeholder
                      Colors.orange,
                      () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const Hba1cListPage())),
                    ),
                    _buildQuickActionItem(
                      context,
                      'Glucose',
                      'assets/images/Blood_Pressure.svg', // Or appropriate icon
                      Colors.redAccent,
                      () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const GlucoseListPage())),
                    ),
                    _buildQuickActionItem(
                      context,
                      'Meds',
                      'assets/images/advanced.svg', // Placeholder
                      Colors.teal,
                      () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              const MedicationLogListPage())),
                    ),
                    _buildQuickActionItem(
                      context,
                      'Events',
                      'assets/images/celender.svg',
                      Colors.amber,
                      () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const HealthEventListPage())),
                    ),
                    _buildQuickActionItem(
                      context,
                      'Meal',
                      'assets/images/shopping_cart.svg', // Changed to shopping_cart.svg
                      Colors.green,
                      () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const MealLogPage())),
                    ),
                    _buildQuickActionItem(
                      context,
                      'Activity',
                      'assets/images/Health.svg',
                      Colors.blue,
                      () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ActivityTypeListPage())),
                    ),
                    _buildQuickActionItem(
                      context,
                      'Sleep',
                      'assets/images/Profile_glupulsesvg.svg',
                      Colors.purple,
                      () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SleepLogListPage())),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recommendation Card
                  _buildRecommendationCard(context),
                  const SizedBox(height: 24),
                  
                  Text(
                    'Health Metrics',
                    style: textTheme.titleLarge?.copyWith(
                        fontSize: 20, // Standardized font size
                        color: Theme.of(context)
                            .colorScheme
                            .primary, // Changed to primary color
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // --- 3. METRICS SCROLL (Horizontal) ---
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    clipBehavior: Clip.none,
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: BlocBuilder<GlucoseCubit, GlucoseState>(
                            builder: (context, state) {
                              String value = 'N/A';
                              String status = '--';
                              Color statusColor = Colors.grey.shade200;
                              Color statusTextColor = Colors.grey;

                              if (state is GlucoseLoaded &&
                                  state.glucoseRecords.isNotEmpty) {
                                final latestRecord = state.glucoseRecords.first;
                                value = latestRecord.glucoseValue.toString();
                                final statusInfo =
                                    _getGlucoseStatus(latestRecord.glucoseValue);
                                status = statusInfo['text'];
                                statusColor = statusInfo['bgColor'];
                                statusTextColor = statusInfo['textColor'];
                              }

                              return _buildGridMetricCard(
                                context: context,
                                title: 'Glucose',
                                value: value,
                                unit: 'mg/dL',
                                iconPath: 'assets/images/Health.svg',
                                iconColor: Colors.redAccent,
                                status: status,
                                statusBgColor: statusColor,
                                statusTextColor: statusTextColor,
                                onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const GlucoseListPage())),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: BlocBuilder<HealthProfileCubit,
                              HealthProfileState>(
                            builder: (context, state) {
                              String value = 'N/A';
                              String status = '--';
                              Color statusColor = Colors.grey.shade200;
                              Color statusTextColor = Colors.grey;

                              if (state is HealthProfileLoaded) {
                                final profile = state.healthProfile;
                                final bmiInfo = _getBmiStatus(profile.bmi);
                                value = bmiInfo['value'];
                                status = bmiInfo['status'];
                                statusColor = bmiInfo['bgColor'];
                                statusTextColor = bmiInfo['textColor'];
                              }

                              return _buildGridMetricCard(
                                context: context,
                                title: 'BMI',
                                value: value,
                                unit: 'kg/m²',
                                iconPath: 'assets/images/bmi.svg',
                                iconColor: Colors.green,
                                status: status,
                                statusBgColor: statusColor,
                                statusTextColor: statusTextColor,
                                onTap: () {
                                  // Optional: Navigate to profile or bmi detail
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: BlocBuilder<Hba1cCubit, Hba1cState>(
                            builder: (context, state) {
                              String value = 'N/A';
                              String status = '--';
                              Color statusColor = Colors.grey.shade200;
                              Color statusTextColor = Colors.grey;

                              if (state is Hba1cLoaded &&
                                  state.hba1cRecords.isNotEmpty) {
                                final sortedRecords =
                                    List.from(state.hba1cRecords)
                                      ..sort((a, b) =>
                                          b.testDate.compareTo(a.testDate));
                                final latestRecord = sortedRecords.first;
                                value =
                                    '${latestRecord.hba1cPercentage.toStringAsFixed(1)}';
                                final statusInfo =
                                    _getHba1cStatus(latestRecord.hba1cPercentage);
                                status = statusInfo['text'];
                                statusColor = statusInfo['bgColor'];
                                statusTextColor = statusInfo['textColor'];
                              }

                              return _buildGridMetricCard(
                                context: context,
                                title: 'Hba1c',
                                value: value,
                                unit: '%',
                                iconPath: 'assets/images/health-rate.svg',
                                iconColor: Colors.purple,
                                status: status,
                                statusBgColor: statusColor,
                                statusTextColor: statusTextColor,
                                onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const Hba1cListPage())),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  Text(
                    'Insights',
                    style: textTheme.titleLarge?.copyWith(
                        fontSize: 20, // Standardized font size
                        color: Theme.of(context).colorScheme.primary, // Changed to primary color
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // --- 4. INSIGHTS / CATEGORY CARDS ---
                  // Blood Sugar Insight
                  BlocBuilder<GlucoseCubit, GlucoseState>(
                    builder: (context, state) {
                      String description = 'No recent glucose data.';
                      Color color = Colors.grey;
                      
                      if (state is GlucoseLoaded && state.glucoseRecords.isNotEmpty) {
                         // Simple logic based on last record, or static message as before
                         final val = state.glucoseRecords.first.glucoseValue;
                         if(val >= 70 && val <= 140) {
                           description = 'Your blood sugar is in the normal range. Keep up the good work!';
                           color = Colors.green;
                         } else if (val > 140) {
                           description = 'Your blood sugar is high. Watch your intake.';
                           color = Colors.orange;
                         } else {
                           description = 'Your blood sugar is low.';
                           color = Colors.redAccent;
                         }
                      }
                      
                      return _buildInsightCard(
                        context: context,
                        title: 'Glucose Analysis',
                        description: description,
                        icon: Icons.water_drop_rounded,
                        color: color == Colors.grey ? Colors.blueGrey : color,
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  
                  // BMI Insight
                  BlocBuilder<HealthProfileCubit, HealthProfileState>(
                    builder: (context, state) {
                      String description =
                          'Input your weight and height to see your BMI category.';
                      Color color = Colors.blue;

                      if (state is HealthProfileLoaded) {
                        final profile = state.healthProfile;
                        final bmiInfo = _getBmiStatus(profile.bmi);
                        description = bmiInfo['description'];
                        // Use the color from the helper
                        if (bmiInfo['status'] == 'Normal') {
                           color = Colors.green;
                        } else if (bmiInfo['status'] == 'Obesity') {
                           color = Colors.red;
                        } else {
                           color = Colors.orange;
                        }
                      }

                      return _buildInsightCard(
                        context: context,
                        title: 'BMI Analysis',
                        description: description,
                        icon: Icons.monitor_weight_rounded,
                        color: color,
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- NEW WIDGET HELPERS ---

  Widget _buildQuickActionItem(BuildContext context, String label,
      String iconPath, Color color, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: SvgPicture.asset(
                iconPath,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridMetricCard({
    required BuildContext context,
    required String title,
    required String value,
    required String unit,
    required String iconPath,
    required Color iconColor,
    required String status,
    required Color statusBgColor,
    required Color statusTextColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    iconPath,
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                  ),
                ),
                // Tiny arrow to indicate interactivity
                 Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Colors.grey.shade300),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3.0),
                  child: Text(
                    unit,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: statusBgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: statusTextColor,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightCard({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  // --- HELPER FUNCTIONS (Restored) ---

  String _getHba1cStatusMessage(double value) {
    if (value < 5.7) {
      return 'Your last A1c level is normal.';
    } else if (value >= 5.7 && value <= 6.4) {
      return 'Your last A1c indicates prediabetes.';
    } else {
      return 'Your last A1c indicates diabetes.';
    }
  }

  Map<String, dynamic> _getHba1cStatus(double value) {
    if (value < 5.7) {
      return {
        'text': 'Normal',
        'bgColor': const Color(0xFF9CF0A6),
        'textColor': const Color(0xFF02A916)
      };
    } else if (value >= 5.7 && value <= 6.4) {
      return {
        'text': 'Prediabetes',
        'bgColor': const Color(0xFFFDFD66),
        'textColor': const Color(0xFFB7B726)
      };
    } else {
      return {
        'text': 'Diabetes',
        'bgColor': const Color(0xFFFA4D5E),
        'textColor': const Color(0xFFBF070A)
      };
    }
  }

  Map<String, dynamic> _getBmiStatus(double? bmi) {
    if (bmi == null || bmi <= 0) {
      return {
        'value': 'N/A',
        'status': 'No Data',
        'description': 'Input your weight and height to see your BMI category.',
        'bgColor': Colors.grey.shade300,
        'textColor': Colors.black54,
      };
    }
    String value = bmi.toStringAsFixed(1);

    if (bmi < 18.5) {
      return {
        'value': value,
        'status': 'Underweight',
        'description':
            'Your BMI is in the underweight range. Consider a diet plan.',
        'bgColor': const Color(0xFFFDFD66),
        'textColor': const Color(0xFFB7B726)
      };
    } else if (bmi >= 18.5 && bmi < 25) {
      return {
        'value': value,
        'status': 'Normal',
        'description': 'Your BMI is in the healthy weight range. Great job!',
        'bgColor': const Color(0xFF9CF0A6),
        'textColor': const Color(0xFF02A916)
      };
    } else if (bmi >= 25 && bmi < 29.9) {
      // Sesuai standar umum, obesitas dimulai dari 30
      return {
        'value': value,
        'status': 'Overweight',
        'description':
            'Your BMI is in the overweight range. Consider more activity.',
        'bgColor': Colors.orange.shade100,
        'textColor': Colors.orange.shade800
      };
    } else {
      return {
        'value': value,
        'status': 'Obesity',
        'description':
            'Your BMI is in the obesity range. Please consult a doctor.',
        'bgColor': const Color(0xFFFA4D5E),
        'textColor': const Color(0xFFBF070A)
      };
    }
  }

  // Helper untuk mendapatkan status dan warna berdasarkan nilai glukosa
  Map<String, dynamic> _getGlucoseStatus(int value) {
    if (value < 70) {
      return {
        'text': 'Low',
        'bgColor': const Color(0xFFFDFD66),
        'textColor': const Color(0xFFB7B726)
      };
    } else if (value >= 70 && value <= 140) {
      return {
        'text': 'Normal',
        'bgColor': const Color(0xFF9CF0A6),
        'textColor': const Color(0xFF02A916)
      };
    } else if (value > 140 && value <= 250) {
      return {
        'text': 'High',
        'bgColor': Colors.orange.shade100,
        'textColor': Colors.orange.shade800
      };
    } else {
      // > 250
      return {
        'text': 'Diabetes',
        'bgColor': const Color(0xFFFA4D5E),
        'textColor': const Color(0xFFBF070A)
      };
    }
  }

  Widget _buildRecommendationCard(BuildContext context) {
    return GestureDetector(
      onTap: () => _getRecommendation(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0F67FE), Color(0xFF4C8CFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F67FE).withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Get Recommendation',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'AI-powered health insights',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }
}
