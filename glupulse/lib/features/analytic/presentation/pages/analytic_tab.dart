import 'package:flutter/material.dart';
import 'package:glupulse/app/theme/app_theme.dart';
import 'package:glupulse/features/HealthData/presentation/pages/health_metric_detail_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glupulse/features/HealthData/presentation/pages/input_health_data_page.dart';
import 'package:glupulse/features/hba1c/presentation/pages/add_edit_hba1c_page.dart';
import 'package:glupulse/features/hba1c/presentation/pages/hba1c_list_page.dart';
import 'package:glupulse/features/health_event/presentation/pages/add_edit_health_event_page.dart';
import 'package:glupulse/features/health_event/presentation/pages/health_event_list_page.dart';

class AnalyticTab extends StatefulWidget {
  const AnalyticTab({super.key});

  @override
  State<AnalyticTab> createState() => _AnalyticTabState();
}

class _AnalyticTabState extends State<AnalyticTab> {
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
                    children: [
                      Text(
                        '5.7%', // Contoh skor
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
                        'Your last A1c level is normal.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 24), // Spasi sebelum tombol
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const InputHealthDataPage(),
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
                          'Input Health',
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    ],
                  ),
                ), // <-- Added comma here

                // Widget untuk status kesehatan di pojok kanan atas
                Positioned(
                  top: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF9CF0A6), // Warna luar sesuai permintaan
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Text(
                      'Normal',
                      style: TextStyle(
                        color: Color(0xFF02A916), // Warna teks sesuai permintaan
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
                      _buildMetricCard(
                        context: context, 
                        iconWidget: SvgPicture.asset(
                          'assets/images/Health.svg',
                          colorFilter: const ColorFilter.mode(Colors.redAccent, BlendMode.srcIn),
                        ),
                        iconBackgroundColor: Colors.redAccent,
                        status: 'Critical',
                        statusColor: const Color(0xFFFA4D5E), // Warna BG Merah
                        statusTextColor: const Color(0xFFBF070A), // Warna Teks Merah
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const HealthMetricDetailPage(
                              title: 'Blood Sugar',
                              value: '110',
                              unit: 'mg/dL',
                              status: 'Critical',
                              icon: Icons.water_drop_outlined,
                              iconColor: Colors.redAccent,
                            ),
                          ));
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildMetricCard(
                        context: context,
                        iconWidget: SvgPicture.asset(
                          'assets/images/Blood_Pressure.svg',
                          colorFilter: const ColorFilter.mode(Color(0xFF4043FD), BlendMode.srcIn),
                        ),
                        iconBackgroundColor: const Color(0xFF4043FD),
                        status: 'Low',
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
                      const SizedBox(height: 12),
                      _buildMetricCard(
                        context: context, 
                        iconWidget: SvgPicture.asset(
                          'assets/images/bmi.svg',
                          colorFilter: const ColorFilter.mode(Colors.green, BlendMode.srcIn),
                        ),
                        iconBackgroundColor: Colors.green,
                        status: 'Normal',
                        statusColor: const Color(0xFF9CF0A6),
                        statusTextColor: const Color(0xFF02A916),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const HealthMetricDetailPage(
                              title: 'BMI',
                              value: '22.5',
                              unit: 'kg/m²',
                              status: 'Normal',
                              icon: Icons.calculate_outlined,
                              iconColor: Colors.green,
                            ),
                          ));
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildMetricCard(
                        context: context,
                        iconWidget: SvgPicture.asset(
                          'assets/images/health-rate.svg',
                          colorFilter: const ColorFilter.mode(Colors.orangeAccent, BlendMode.srcIn),
                        ),
                        iconBackgroundColor: Colors.orangeAccent,
                        status: 'Normal',
                        statusColor: const Color(0xFF9CF0A6),
                        statusTextColor: const Color(0xFF02A916),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const HealthMetricDetailPage(
                              title: 'Heart Rate',
                              value: '72',
                              unit: 'BPM',
                              status: 'Normal',
                              icon: Icons.monitor_heart_outlined,
                              iconColor: Colors.orangeAccent,
                            ),
                          ));
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
                  _buildCategoryCard(
                    context: context,
                    title: 'Category Blood Pressure',
                    description:
                        'Your blood pressure is slightly high. Consider consulting a doctor.',
                    icon: Icons.favorite_border,
                    color: Colors.blueAccent,
                  ),
                  const SizedBox(height: 12),
                  _buildCategoryCard(
                    context: context,
                    title: 'Category BMI',
                    description:
                        'Your BMI is in the healthy weight range. Great job!',
                    icon: Icons.calculate_outlined,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 12),
                  _buildCategoryCard(
                    context: context,
                    title: 'Category Heart Rate',
                    description:
                        'Your resting heart rate is normal. This indicates good cardiovascular health.',
                    icon: Icons.monitor_heart_outlined,
                    color: Colors.blueAccent,
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
    required Widget iconWidget,
    required Color iconBackgroundColor,
    String? status,
    Color? statusColor,
    Color? statusTextColor,
    required VoidCallback onTap,
  }) {
    // Data dummy, nantinya akan diganti dengan data dinamis
    String title, value, unit;
    if (iconWidget is SvgPicture && iconWidget.bytesLoader is SvgAssetLoader && (iconWidget.bytesLoader as SvgAssetLoader).assetName.contains('Health.svg')) {
      title = 'Blood Sugar';
      value = '110';
      unit = 'mg/dL';
    } else if (iconWidget is SvgPicture && iconWidget.bytesLoader is SvgAssetLoader && (iconWidget.bytesLoader as SvgAssetLoader).assetName.contains('Blood_Pressure.svg')) {
      title = 'Blood Pressure';
      value = '120/80';
      unit = 'mmHg';
    } else if (iconWidget is SvgPicture && iconWidget.bytesLoader is SvgAssetLoader && (iconWidget.bytesLoader as SvgAssetLoader).assetName.contains('bmi.svg')) {
      title = 'BMI';
      value = '22.5';
      unit = 'kg/m²';
    } else {
      title = 'Heart Rate';
      value = '72';
      unit = 'BPM';
    }

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

}
