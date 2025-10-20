import 'package:flutter/material.dart';
import 'package:glupulse/app/theme/app_theme.dart';
import 'package:glupulse/features/HealthData/presentation/pages/health_metric_detail_page.dart';
import 'package:glupulse/features/HealthData/presentation/pages/input_health_data_page.dart';

class AnalyticTab extends StatelessWidget {
  const AnalyticTab({super.key});

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
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Stack( // Menggunakan Stack untuk menumpuk widget
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '85', // Contoh skor
                        style: TextStyle(
                          fontSize: 96,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Glupulse Score',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'You are a healthy individual.',
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
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricCard(
                          context: context,
                          title: 'Blood Sugar',
                          value: '110',
                          unit: 'mg/dL',
                          icon: Icons.water_drop_outlined,
                          color: Colors.redAccent,
                          status: 'Normal',
                          statusColor: const Color(0xFF9CF0A6),
                          statusTextColor: const Color(0xFF02A916),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const HealthMetricDetailPage(
                                title: 'Blood Sugar',
                                value: '110',
                                unit: 'mg/dL',
                                status: 'Normal',
                                icon: Icons.water_drop_outlined,
                                iconColor: Colors.redAccent,
                              ),
                            ));
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildMetricCard(
                          context: context,
                          title: 'Blood Pressure',
                          value: '120/80',
                          unit: 'mmHg',
                          icon: Icons.favorite_border,
                          color: Colors.blueAccent,
                          status: 'Normal',
                          statusColor: const Color(0xFF9CF0A6),
                          statusTextColor: const Color(0xFF02A916),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const HealthMetricDetailPage(
                                title: 'Blood Pressure',
                                value: '120/80',
                                unit: 'mmHg',
                                status: 'Normal',
                                icon: Icons.favorite_border,
                                iconColor: Colors.blueAccent,
                              ),
                            ));
                          },
                        ),
                      ),
                    ],
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
    required IconData icon,
    required Color color,
    String? status,
    Color? statusColor,
    Color? statusTextColor,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 191, // Menyamakan tinggi dengan card di home_tab
      child: Card(
        elevation: 1,
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: InkWell(
          onTap: onTap,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: color.withOpacity(0.8))),
                    if (status != null && statusColor != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: statusColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: statusTextColor ?? Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    const Spacer(),
                    Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Theme.of(context).colorScheme.primary)),
                    Text(unit, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                  ],
                ),
              ),
              Positioned(top: 12, right: 12, child: Icon(icon, color: color, size: 24)),
            ],
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
