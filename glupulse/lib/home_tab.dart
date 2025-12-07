import 'package:glupulse/features/recommendation/domain/entities/recommendation_entity.dart';
import 'package:glupulse/features/recommendation/presentation/cubit/recommendation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glupulse/features/Food/presentation/cubit/food_cubit.dart';
import 'package:glupulse/features/glucose/presentation/cubit/glucose_cubit.dart';
import 'package:glupulse/features/hba1c/presentation/cubit/hba1c_cubit.dart';
// import 'package:glupulse/features/Food/presentation/widgets/food_card.dart'; // Removed as we use local helper
import 'package:glupulse/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:glupulse/features/activity/presentation/pages/activity_detail_page.dart';
import 'package:glupulse/features/Food/presentation/pages/food_detail_page.dart';
import 'package:glupulse/features/hba1c/presentation/pages/hba1c_list_page.dart';
import 'package:glupulse/features/auth/presentation/cubit/auth_state.dart';
import 'package:glupulse/features/glucose/presentation/pages/glucose_list_page.dart';
import 'package:glupulse/features/notification/presentation/pages/notification_page.dart';
import 'package:glupulse/features/HealthData/presentation/pages/health_metric_detail_page.dart';
import 'package:glupulse/features/HealthData/presentation/cubit/health_profile_cubit.dart';
import 'package:glupulse/features/HealthData/presentation/cubit/health_profile_state.dart';
import 'package:intl/intl.dart';


class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  void initState() {
    super.initState();
    // Memuat data makanan saat halaman pertama kali dibuka
    context.read<FoodCubit>().fetchFoods();
    context.read<Hba1cCubit>().getHba1cRecords();
    context.read<GlucoseCubit>().getGlucoseRecords();
    context.read<HealthProfileCubit>().fetchHealthProfile();
    context.read<RecommendationCubit>().fetchLatestRecommendation();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        String fullName = 'Guest';

        // Mengambil dan memformat tanggal saat ini
        final String currentDate = DateFormat('E, dd MMM yyyy').format(DateTime.now());

        // Ambil nama dari state AuthCubit
        if (state is AuthAuthenticated) {
          final user = state.user;
          // Gunakan nama depan, tangani jika null
          fullName = user.firstName ?? '';
          // Jika nama depan kosong, gunakan username sebagai fallback
          if (fullName.isEmpty) {
            fullName = user.username;
          }
        } else if (state is AuthProfileIncomplete) {
          final user = state.user;
          fullName = user.firstName ?? '';
          if (fullName.isEmpty) {
            fullName = user.username;
          }
        }
        return SingleChildScrollView(
          child: Column(
        children: [
          Container(
            width: double.infinity,
            // Tinggi diatur otomatis oleh children
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withOpacity(0.8),
                ],
              ),
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
            child: Padding(
              padding: const EdgeInsets.only(top: 48.0, left: 24.0, right: 24.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Grup Tanggal
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/images/calender.svg', // Pastikan path ini benar
                                colorFilter: const ColorFilter.mode(
                                    Colors.white, BlendMode.srcIn),
                                width: 20,
                              ),
                              const SizedBox(width: 8), 
                              Text(
                                currentDate, // Menggunakan tanggal dinamis
                                style: const TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Sapaan Pengguna
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.person_outline,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [ 
                                  Text(
                                    'Hi, $fullName', // Menggunakan nama dinamis
                                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      SvgPicture.asset('assets/images/hearttick.svg', // Path ke ikon baru
                                        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                                        width: 18,
                                      ),
                                      const SizedBox(width: 6),
                                      const Text('85%', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                                      const SizedBox(width: 8),
                                      const Text('•',
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 16)),
                                      const SizedBox(width: 6),
                                      SvgPicture.asset('assets/images/member.svg', // Pastikan path ini benar
                                        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                                        width: 18,
                                      ),
                                      const SizedBox(width: 6),
                                      const Text('Pro Member', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Ikon Notifikasi
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const NotificationPage()));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.notifications_outlined,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // --- Search Bar ---
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search for articles, doctors...',
                      prefixIcon: Icon(
                        Icons.search,
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24), // Padding bawah di dalam container
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Health Score',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute( // Diubah untuk mengarah ke halaman list HbA1c
                builder: (context) => const Hba1cListPage(),
              ));
            },
            child: Card(
              elevation: 2,
              color: Colors.white,
              clipBehavior: Clip.antiAlias, // Penting agar child mengikuti lengkungan Card
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: SizedBox(
                width: 385,
                height: 105,
                child: Row(
                  children: [
                    Container(
                      width: 120,
                      color: const Color(0xFF0F67FE),
                      child: Center(
                        child: BlocBuilder<Hba1cCubit, Hba1cState>(
                          builder: (context, state) {
                            String hba1cValue = '0.0%';
                            if (state is Hba1cLoaded && state.hba1cRecords.isNotEmpty) {
                              // Urutkan data dari yang terbaru
                              final sortedRecords = List.from(state.hba1cRecords)
                                ..sort((a, b) => b.testDate.compareTo(a.testDate));
                              hba1cValue = '${sortedRecords.first.hba1cPercentage.toStringAsFixed(1)}%';
                            }
                            return Text(
                              hba1cValue,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: BlocBuilder<Hba1cCubit, Hba1cState>(
                          builder: (context, state) { // Kurung kurawal pembuka
                            String statusMessage = 'No data available. Please input your Hba1c record.';
                            if (state is Hba1cLoaded && state.hba1cRecords.isNotEmpty) {
                              final latestRecord = state.hba1cRecords.first;
                              statusMessage = _getHba1cStatusMessage(latestRecord.hba1cPercentage);
                            }
                            return Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 const Text('Last Hba1c',
                                     style: TextStyle(
                                         fontWeight: FontWeight.bold, fontSize: 16)),
                                 const SizedBox(height: 4),
                                 Text(
                                  statusMessage,
                                   style: const TextStyle(fontSize: 14, color: Colors.grey),
                                   maxLines: 3,
                                 ),
                               ],
                             );
                          }, // Kurung kurawal penutup
                        ), // Penutup untuk BlocBuilder
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Smart Health Metrix',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 191, // Tinggi sesuai dengan tinggi card
            child: ListView(
              scrollDirection: Axis.horizontal, // Mengatur scroll ke kanan
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              children: [
                // --- Card Gula Darah ---
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
                      status = statusInfo['status'];
                      statusColor = statusInfo['color'];
                      statusTextColor = statusInfo['textColor'];
                    }

                    return _buildHealthMetricCard(
                      context: context,
                      category: 'Blood Sugar',
                      iconWidget: SvgPicture.asset(
                        'assets/images/Health.svg',
                        colorFilter: const ColorFilter.mode(Colors.redAccent, BlendMode.srcIn),
                        width: 24,
                      ),
                      iconColor: Colors.redAccent,
                      value: value,
                      unit: 'mg/dL',
                      status: status,
                      statusText: status,
                      statusColor: statusColor,
                      statusTextColor: statusTextColor,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const GlucoseListPage()));
                      },
                    );
                  },
                ),
                const SizedBox(width: 12),
                // --- Card Tekanan Darah ---
                _buildHealthMetricCard(
                  context: context,
                  category: 'Blood Pressure',
                  iconWidget: SvgPicture.asset(
                    'assets/images/Blood_Pressure.svg', // Menggunakan SVG asset
                    colorFilter: const ColorFilter.mode(Color(0xFF4043FD), BlendMode.srcIn),
                    width: 24,
                  ),
                  iconColor: const Color(0xFF4043FD),
                  value: '120/80',
                  unit: 'mmHg',
                  status: 'Low',
                  statusText: 'Low', // Status baru
                  statusColor: const Color(0xFFFDFD66), // Warna BG Kuning
                  statusTextColor: const Color(0xFFB7B726), // Warna Teks Kuning
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const HealthMetricDetailPage(
                        title: 'Blood Pressure',
                        value: '120/80',
                        unit: 'mmHg',
                        status: 'Low',
                        icon: Icons.favorite_border,
                        iconColor: const Color(0xFF4043FD),
                      ),
                    ));
                  },
                ),
                const SizedBox(width: 12),
                // --- Card BMI ---
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
                      statusColor = bmiInfo['color'];
                      statusTextColor = bmiInfo['textColor'];
                    }

                    return _buildHealthMetricCard(
                      context: context,
                      category: 'BMI',
                      iconWidget: SvgPicture.asset(
                        'assets/images/bmi.svg', // Menggunakan SVG asset yang baru
                        colorFilter: const ColorFilter.mode(Colors.green, BlendMode.srcIn), // Warna tetap hijau
                        width: 24,
                      ),
                      iconColor: Colors.green,
                      value: value,
                      unit: 'kg/m²',
                      status: status,
                      statusText: status,
                      statusColor: statusColor,
                      statusTextColor: statusTextColor,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => HealthMetricDetailPage(
                            title: 'BMI',
                            value: value,
                            unit: 'kg/m²',
                            status: status,
                            icon: Icons.calculate_outlined,
                            iconColor: Colors.green,
                          ),
                        ));
                      },
                    );
                  },
                ),
                const SizedBox(width: 12),
                // --- Card Heart Rate ---
                _buildHealthMetricCard(
                  context: context,
                  category: 'Heart Rate',
                  iconWidget: SvgPicture.asset(
                    'assets/images/health-rate.svg', // Menggunakan SVG asset yang sama
                    colorFilter: const ColorFilter.mode(Colors.orangeAccent, BlendMode.srcIn),
                    width: 24,
                  ),
                  iconColor: Colors.orangeAccent,
                  value: '72',
                  unit: 'BPM',
                  status: 'Resting',
                  statusText: 'Normal',
                  statusColor: const Color(0xFF9CF0A6),
                  statusTextColor: const Color(0xFF02A916),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const HealthMetricDetailPage(
                        title: 'Heart Rate',
                        value: '72',
                        unit: 'BPM',
                        status: 'Resting',
                        icon: Icons.monitor_heart_outlined,
                        iconColor: Colors.orangeAccent,
                      ),
                    ));
                  },
                ),
              ],
            ),
          ), // End of Smart Health Metrix ListView
          const SizedBox(height: 16),

              // --- Recommendation Food Section ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Recommendation Food',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              BlocBuilder<RecommendationCubit, RecommendationState>(
                builder: (context, recommendationState) {
                  if (recommendationState is RecommendationLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (recommendationState is RecommendationLoaded && recommendationState.recommendation.foodRecommendations.isNotEmpty) {
                    final foodRecommendations = recommendationState.recommendation.foodRecommendations;
                    return SizedBox(
                      height: 170, // Adjusted height for food cards
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        itemCount: foodRecommendations.length,
                        separatorBuilder: (context, index) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final food = foodRecommendations[index];
                          return _buildFoodCard(food);
                        },
                      ),
                    );
                  } else if (recommendationState is RecommendationError) {
                    return Center(child: Text('Error loading food recommendations: ${recommendationState.message}'));
                  }
                  return const SizedBox.shrink(); // No food recommendations or initial state
                },
              ),
            const SizedBox(height: 24),

              // --- Recommendation Activity Section ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Recommendation Activity',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              BlocBuilder<RecommendationCubit, RecommendationState>(
                builder: (context, recommendationState) {
                  if (recommendationState is RecommendationLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (recommendationState is RecommendationLoaded && recommendationState.recommendation.activityRecommendations.isNotEmpty) {
                    final activityRecommendations = recommendationState.recommendation.activityRecommendations;
                    return SizedBox(
                      height: 180, // Adjusted height for activity cards
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        itemCount: activityRecommendations.length,
                        separatorBuilder: (context, index) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final activity = activityRecommendations[index];
                          return _buildActivityCard(activity);
                        },
                      ),
                    );
                  } else if (recommendationState is RecommendationError) {
                    return Center(child: Text('Error loading activity recommendations: ${recommendationState.message}'));
                  }
                  return const SizedBox.shrink(); // No activity recommendations or initial state
                },
              ),
          const SizedBox(height: 24), // Menambahkan spasi di bagian bawah
            ],
          ),
        );
      },
    );
  }

  // Helper untuk mendapatkan pesan status berdasarkan nilai HbA1c
  String _getHba1cStatusMessage(double value) {
    if (value < 5.7) {
      return 'Your last A1c level is normal. Keep it up!';
    } else if (value >= 5.7 && value <= 6.4) {
      return 'Your last A1c indicates prediabetes. Consider consulting a doctor.';
    } else {
      return 'Your last A1c indicates diabetes. Please consult a doctor.';
    }
  }

  // Helper untuk mendapatkan status dan warna berdasarkan nilai glukosa
  Map<String, dynamic> _getGlucoseStatus(int value) {
    if (value < 70) {
      return {'status': 'Low', 'color': const Color(0xFFFDFD66), 'textColor': const Color(0xFFB7B726)};
    } else if (value >= 70 && value <= 140) {
      return {'status': 'Normal', 'color': const Color(0xFF9CF0A6), 'textColor': const Color(0xFF02A916)};
    } else if (value > 140 && value <= 250) {
      return {'status': 'High', 'color': Colors.orange.shade100, 'textColor': Colors.orange.shade800};
    } else { // > 250
      return {'status': 'Critical', 'color': const Color(0xFFFA4D5E), 'textColor': const Color(0xFFBF070A)};
    }
  }

  Map<String, dynamic> _getBmiStatus(double? bmi) {
    if (bmi == null || bmi <= 0) {
      return {
        'value': 'N/A',
        'status': 'No Data',
        'description': 'Input your weight and height to see your BMI category.',
        'color': Colors.grey.shade300,
        'textColor': Colors.black54,
      };
    }
    String value = bmi.toStringAsFixed(1);

    if (bmi < 18.5) {
      return {'value': value, 'status': 'Underweight', 'description': 'Your BMI is in the underweight range. Consider a diet plan.', 'color': const Color(0xFFFDFD66), 'textColor': const Color(0xFFB7B726)};
    } else if (bmi >= 18.5 && bmi < 25) {
      return {'value': value, 'status': 'Normal', 'description': 'Your BMI is in the healthy weight range. Great job!', 'color': const Color(0xFF9CF0A6), 'textColor': const Color(0xFF02A916)};
    } else if (bmi >= 25 && bmi < 29.9) { 
      return {'value': value, 'status': 'Overweight', 'description': 'Your BMI is in the overweight range. Consider more activity.', 'color': Colors.orange.shade100, 'textColor': Colors.orange.shade800};
    } else {
      return {'value': value, 'status': 'Obesity', 'description': 'Your BMI is in the obesity range. Please consult a doctor.', 'color': const Color(0xFFFA4D5E), 'textColor': const Color(0xFFBF070A)};
    }
  }



  // Widget helper untuk membuat card metrik agar kode tidak berulang
  Widget _buildHealthMetricCard({
    required BuildContext context,
    required Widget iconWidget,
    required String category,
    required Color iconColor,
    required String value,
    required String unit,
    required String status,
    String? statusText,
    Color? statusColor,
    Color? statusTextColor,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 170, // Menyamakan lebar dengan card lain
      child: Card(
        elevation: 1,
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    iconWidget,
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(category.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: iconColor.withOpacity(0.8))),
                          if (statusText != null && statusColor != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  statusText,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: statusTextColor ?? Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Theme.of(context).colorScheme.primary)),
                Text('$unit - $status', style: const TextStyle(fontSize: 13, color: Colors.grey)),
              ],
            ),
          ),
        ),
      ),
    );
  }


  // --- Helper Methods for Recommendations ---





  Widget _buildActivityCard(ActivityRecommendationEntity activity) {


    final imageAsset = _getImageAssetForActivity(activity.activityCode);


    final cardColor = _getColorForActivity(activity.activityCode);





    return SizedBox(
      width: 320, // Fixed width to prevent layout overflow in horizontal list
      child: Card(
        elevation: 2,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: 180,
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
        ),
      ),
    );


  }





  Widget _buildFoodCard(FoodRecommendationEntity food) {


    return Container(
      width: 280, // Fixed width to prevent layout overflow in horizontal list
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


}