import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glupulse/app/theme/app_theme.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/HealthData/presentation/pages/health_metric_detail_page.dart';
import 'package:glupulse/features/glucose/presentation/cubit/glucose_cubit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glupulse/features/HealthData/presentation/pages/input_health_data_page.dart';
import 'package:glupulse/features/glucose/presentation/pages/glucose_list_page.dart';
import 'package:glupulse/features/HealthData/presentation/cubit/health_profile_state.dart';
import 'package:glupulse/features/HealthData/presentation/cubit/health_profile_cubit.dart';
import 'package:glupulse/features/hba1c/presentation/cubit/hba1c_cubit.dart';
import 'package:glupulse/features/hba1c/presentation/pages/hba1c_list_page.dart';
import 'package:glupulse/features/health_event/presentation/pages/health_event_list_page.dart';
import 'package:glupulse/features/activity/presentation/pages/activity_type_list_page.dart';

import 'package:glupulse/features/sleep_log/presentation/pages/sleep_log_list_page.dart';
import 'package:glupulse/features/medication/presentation/pages/medication_log_list_page.dart';
import 'package:glupulse/features/meal_log/presentation/pages/meal_log_page.dart';

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

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // Menggunakan ConstrainedBox untuk memastikan konten mengisi seluruh tinggi layar
    // jika kontennya lebih pendek dari layar.
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
            width: double.infinity,
            height: 400,
            decoration: BoxDecoration(
              color: const Color(0xFF0F67FE),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(50),
              ),  
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack( // Menggunakan Stack untuk menumpuk widget
              children: [
                Align(
                  alignment: Alignment.center, // Align akan menengahkan child-nya
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Column hanya akan setinggi kontennya
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [ BlocBuilder<Hba1cCubit, Hba1cState>(
                        builder: (context, state) {
                          String hba1cValue = '0.0%';
                          String hba1cStatus = 'No data available.';

                          if (state is Hba1cLoaded && state.hba1cRecords.isNotEmpty) {
                            // Urutkan data dari yang terbaru
                            final sortedRecords = List.from(state.hba1cRecords)
                              ..sort((a, b) => b.testDate.compareTo(a.testDate));
                            final latestRecord = sortedRecords.first;
                            hba1cValue = '${latestRecord.hba1cPercentage.toStringAsFixed(1)}%';
                            hba1cStatus = _getHba1cStatusMessage(latestRecord.hba1cPercentage);
                          }

                          return Column(
                            children: [
                              Text(
                                hba1cValue,
                                style: const TextStyle(
                                  fontSize: 80,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Last Hba1c',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                hba1cStatus,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                            ],
                          );
                        },
                      ),const SizedBox(height: 24), // Spasi sebelum tombol
                      ElevatedButton( // Tombol di luar BlocBuilder
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const GlucoseListPage(),
                          ));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                        ),
                        child: const Text(
                          'Track Glucose',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  bottom: 24,
                  left: 24,
                  right: 24,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const Hba1cListPage(),
                            ));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                          ),
                          child: const Text(
                            'Track Hba1c',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ActivityTypeListPage(),
                            ));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                          ),
                          child: const Text(
                            'Track Activity',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const HealthEventListPage(),
                            ));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                          ),
                          child: const Text(
                            'Log Health Event',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 8),
                         ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const SleepLogListPage(),
                            ));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                          ),
                          child: const Text(
                            'Sleep Log',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const MedicationLogListPage(),
                            ));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                          ),
                          child: const Text(
                            'Log Medication',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const MealLogPage(),
                            ));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                          ),
                          child: const Text(
                            'Log Meal',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ), // <-- Added comma here

                // Widget untuk status kesehatan di pojok kanan atas
                Positioned(
                  top: 20,
                  right: 20,
                  child: BlocBuilder<Hba1cCubit, Hba1cState>(
                    builder: (context, state) {
                      if (state is Hba1cLoaded && state.hba1cRecords.isNotEmpty) {
                        // Urutkan data dari yang terbaru
                        final sortedRecords = List.from(state.hba1cRecords)
                          ..sort((a, b) => b.testDate.compareTo(a.testDate));
                        final latestRecord = sortedRecords.first;
                        final statusInfo = _getHba1cStatus(latestRecord.hba1cPercentage);
                        return _buildStatusBadge(statusInfo['text']!, statusInfo['bgColor']!, statusInfo['textColor']!);
                      }
                      // Tampilkan badge 'No Data' jika tidak ada data
                      return _buildStatusBadge('No Data', Colors.grey.shade300, Colors.black54);
                    },
                  ),
                ),
              ],
            ),
           ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Smart Health Metrix',
                    style: textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  // --- Kartu Metrik ---
                  Column(
                    children: [
                      BlocBuilder<GlucoseCubit, GlucoseState>(
                        builder: (context, state) {
                          String value = 'N/A';
                          String status = 'No Data';
                          Color statusColor = Colors.grey.shade300;
                          Color statusTextColor = Colors.black54;

                          if (state is GlucoseLoaded && state.glucoseRecords.isNotEmpty) {
                            final latestRecord = state.glucoseRecords.first;
                            value = latestRecord.glucoseValue.toString();
                            final statusInfo = _getGlucoseStatus(latestRecord.glucoseValue);
                            status = statusInfo['text'];
                            statusColor = statusInfo['bgColor'];
                            statusTextColor = statusInfo['textColor'];
                          }

                          return _buildMetricCard(
                            context: context,
                            title: 'Blood Sugar',
                            value: value,
                            unit: 'mg/dL',
                            iconWidget: SvgPicture.asset(
                              'assets/images/Health.svg',
                              colorFilter: const ColorFilter.mode(Colors.redAccent, BlendMode.srcIn),
                            ),
                            iconBackgroundColor: Colors.redAccent,
                            status: status,
                            statusColor: statusColor,
                            statusTextColor: statusTextColor,
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const GlucoseListPage(),
                              ));
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      BlocBuilder<HealthProfileCubit, HealthProfileState>(
                        builder: (context, state) {
                          String value = 'N/A';
                          String status = 'No Data';
                          Color statusColor = Colors.grey.shade300;
                          Color statusTextColor = Colors.black54;
                      
                          if (state is HealthProfileLoaded) {
                            final profile = state.healthProfile;
                            final bmiInfo = _getBmiStatus(profile.bmi);
                            value = bmiInfo['value'];
                            status = bmiInfo['status'];
                            statusColor = bmiInfo['bgColor'];
                            statusTextColor = bmiInfo['textColor'];
                          }
                      
                          return _buildMetricCard(
                            context: context,
                            title: 'BMI',
                            value: value,
                            unit: 'kg/m²',
                            iconWidget: SvgPicture.asset(
                              'assets/images/bmi.svg',
                              colorFilter: const ColorFilter.mode(Colors.green, BlendMode.srcIn),
                            ),
                            iconBackgroundColor: Colors.green,
                            status: status,
                            statusColor: statusColor,
                            statusTextColor: statusTextColor,
                            onTap: () {
                              // Anda bisa membuat halaman detail BMI jika diperlukan
                              // Untuk saat ini, kita bisa tampilkan SnackBar atau biarkan kosong
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Category Health',
                    style: textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildCategoryCard(
                    context: context,
                    title: 'Category Blood Sugar',
                    description:
                        'Your blood sugar is in the normal range. Keep up the good work!',
                    icon: Icons.water_drop_outlined,
                    color: Colors.redAccent,
                  ),
                  const SizedBox(height: 12),
                  BlocBuilder<HealthProfileCubit, HealthProfileState>(
                    builder: (context, state) {
                       String description = 'Input your weight and height to see your BMI category.';
                        if (state is HealthProfileLoaded) {
                          final profile = state.healthProfile;
                          final bmiInfo = _getBmiStatus(profile.bmi);
                          description = bmiInfo['description'];
                        }

                      return _buildCategoryCard(
                        context: context,
                        title: 'Category BMI',
                        description: description,
                        icon: Icons.calculate_outlined,
                        color: Colors.green,
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required BuildContext context,
    required String title,
    required String value,
    required String unit,
    required Widget iconWidget,
    required Color iconBackgroundColor,
    String? status,
    Color? statusColor,
    Color? statusTextColor,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      // Tinggi diatur otomatis oleh konten di dalamnya
      child: Card(
        elevation: 1,
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: iconBackgroundColor.withOpacity(0.15),
                  child: SizedBox(width: 32, height: 32, child: iconWidget),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Theme.of(context).colorScheme.primary)),
                          const SizedBox(width: 8),
                          Text(unit, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ),
                if (status != null && statusColor != null)
                  Container(
                    constraints: const BoxConstraints(minWidth: 75), // Menetapkan lebar minimum
                    alignment: Alignment.center, // Menengahkan teks di dalam badge
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(fontWeight: FontWeight.bold, color: statusTextColor ?? Colors.white, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(description,
                      style: const TextStyle(
                          fontSize: 14, color: AppTheme.inputLabelColor)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- HELPER FUNCTIONS ---

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
      return {'text': 'Normal', 'bgColor': const Color(0xFF9CF0A6), 'textColor': const Color(0xFF02A916)};
    } else if (value >= 5.7 && value <= 6.4) {
      return {'text': 'Prediabetes', 'bgColor': const Color(0xFFFDFD66), 'textColor': const Color(0xFFB7B726)};
    } else {
      return {'text': 'Diabetes', 'bgColor': const Color(0xFFFA4D5E), 'textColor': const Color(0xFFBF070A)};
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
      return {'value': value, 'status': 'Underweight', 'description': 'Your BMI is in the underweight range. Consider a diet plan.', 'bgColor': const Color(0xFFFDFD66), 'textColor': const Color(0xFFB7B726)};
    } else if (bmi >= 18.5 && bmi < 25) {
      return {'value': value, 'status': 'Normal', 'description': 'Your BMI is in the healthy weight range. Great job!', 'bgColor': const Color(0xFF9CF0A6), 'textColor': const Color(0xFF02A916)};
    } else if (bmi >= 25 && bmi < 29.9) { // Sesuai standar umum, obesitas dimulai dari 30
      return {'value': value, 'status': 'Overweight', 'description': 'Your BMI is in the overweight range. Consider more activity.', 'bgColor': Colors.orange.shade100, 'textColor': Colors.orange.shade800};
    } else {
      return {'value': value, 'status': 'Obesity', 'description': 'Your BMI is in the obesity range. Please consult a doctor.', 'bgColor': const Color(0xFFFA4D5E), 'textColor': const Color(0xFFBF070A)};
    }
  }


  // Helper untuk mendapatkan status dan warna berdasarkan nilai glukosa
  Map<String, dynamic> _getGlucoseStatus(int value) {
    if (value < 70) {
      return {'text': 'Low', 'bgColor': const Color(0xFFFDFD66), 'textColor': const Color(0xFFB7B726)};
    } else if (value >= 70 && value <= 140) {
      return {'text': 'Normal', 'bgColor': const Color(0xFF9CF0A6), 'textColor': const Color(0xFF02A916)};
    } else if (value > 140 && value <= 250) {
      return {'text': 'High', 'bgColor': Colors.orange.shade100, 'textColor': Colors.orange.shade800};
    } else { // > 250
      return {'text': 'Diabetes', 'bgColor': const Color(0xFFFA4D5E), 'textColor': const Color(0xFFBF070A)};
    }
  }
  Widget _buildStatusBadge(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(text, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
    );
  }

  // --- END OF HELPER FUNCTIONS ---

}
