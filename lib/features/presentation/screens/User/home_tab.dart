import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glupulse/features/presentation/screens/User/activity_detail_page.dart';
import 'package:glupulse/features/presentation/screens/User/food_detail_page.dart';
import 'package:glupulse/features/presentation/screens/User/health_metric_detail_page.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: 430,
            // Tinggi diatur otomatis oleh children
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
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
                                'images/celender.svg', // Pastikan path ini benar
                                colorFilter: const ColorFilter.mode(
                                    Colors.white, BlendMode.srcIn),
                                width: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Tue, 25 Jan 2025',
                                style: TextStyle(color: Colors.white, fontSize: 16),
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
                                  const Text(
                                    'Hi, Parhan',
                                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        'images/hearttick.svg', // Path ke ikon baru
                                        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                                        width: 18,
                                      ),
                                      const SizedBox(width: 6),
                                      const Text('85%', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                                      const SizedBox(width: 8),
                                      const Text('•', style: TextStyle(color: Colors.white, fontSize: 16)),
                                      const SizedBox(width: 6),
                                      SvgPicture.asset(
                                        'images/member.svg', // Pastikan path ini benar
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
                      Container(
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
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 2,
            color: Colors.white,
            clipBehavior: Clip.antiAlias, // Penting agar child mengikuti lengkungan Card
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: SizedBox(
              width: 405,
              height: 106,
              child: Row(
                children: [
                  Container(
                    width: 120, // Lebar container biru
                    color: Theme.of(context).colorScheme.primary,
                    child: const Center(
                      child: Text(
                        '85', // Contoh Skor
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Glupulse Score',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(height: 4),
                          Text(
                            'based on your data, we think your health status is above average',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                  ),
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
                'Smart Health Metrix',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 24,
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
                _buildHealthMetricCard(
                  context: context,
                  category: 'Blood Sugar',
                  icon: Icons.water_drop_outlined,
                  iconColor: Colors.redAccent,
                  value: '110',
                  unit: 'mg/dL',
                  status: 'After Meal',
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const HealthMetricDetailPage(
                        title: 'Blood Sugar',
                        value: '110',
                        unit: 'mg/dL',
                        status: 'After Meal',
                        icon: Icons.water_drop_outlined,
                        iconColor: Colors.redAccent,
                      ),
                    ));
                  },
                ),
                const SizedBox(width: 12),
                // --- Card Tekanan Darah ---
                _buildHealthMetricCard(
                  context: context,
                  category: 'Blood Pressure',
                  icon: Icons.favorite_border,
                  iconColor: Colors.blueAccent,
                  value: '120/80',
                  unit: 'mmHg',
                  status: 'Normal',
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
                const SizedBox(width: 12),
                // --- Card Info Gula Darah Rendah ---
                _buildInfoCard(
                  context: context,
                  category: 'Category Blood Sugar',
                  title: 'Low Blood Sugar',
                  description: 'Learn about hypoglycemia.',
                  icon: Icons.arrow_downward_rounded,
                  color: Colors.orangeAccent,
                ),
                const SizedBox(width: 12),
                // --- Card Info Tekanan Darah Tinggi ---
                _buildInfoCard(
                  context: context,
                  category: 'Category Blood Pressure',
                  title: 'High Blood Pressure',
                  description: 'Learn about hypertension.',
                  icon: Icons.arrow_upward_rounded,
                  color: Colors.purpleAccent,
                ),
              ],
            ),
          ), // End of Smart Health Metrix ListView
          const SizedBox(height: 24),

          // --- Recommendation Food Title ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Recommendation Food',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // --- Recommendation Food Cards ---
          SizedBox(
            height: 191, // Menyamakan tinggi dengan Smart Health Metrix
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24.0), // Menggunakan padding horizontal
              children: [
                _buildRecommendationCard(
                  context: context,
                  title: 'Oatmeal',
                  description: 'Good for breakfast',
                  icon: Icons.breakfast_dining_outlined,
                  color: Colors.brown,
                ),
                const SizedBox(width: 12),
                _buildRecommendationCard(
                  context: context,
                  title: 'Salmon',
                  description: 'Rich in Omega-3',
                  icon: Icons.set_meal_outlined,
                  color: Colors.pink,
                ),
                const SizedBox(width: 12),
                _buildRecommendationCard(
                  context: context,
                  title: 'Avocado',
                  description: 'Healthy fats',
                  icon: Icons.spa_outlined,
                  color: Colors.green,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // --- Recommendation Activity Title ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Recommendation Activity',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // --- Recommendation Activity Cards ---
          SizedBox(
            height: 191, // Menyamakan tinggi dengan Smart Health Metrix
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24.0), // Menggunakan padding horizontal
              children: [
                _buildRecommendationCard(
                  context: context,
                  title: 'Walking',
                  description: '30 minutes',
                  icon: Icons.directions_walk,
                  color: Colors.lightBlue,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ActivityDetailPage(activityName: 'Walking'),
                    ));
                  },
                ),
                const SizedBox(width: 12),
                _buildRecommendationCard(
                  context: context,
                  title: 'Yoga', // Mengganti title menjadi Yoga
                  description: '15 minutes',
                  icon: Icons.self_improvement,
                  color: Colors.purpleAccent,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ActivityDetailPage(activityName: 'Yoga'),
                    ));
                  },
                ),
                const SizedBox(width: 12),
                _buildRecommendationCard(
                  context: context,
                  title: 'Cycling', // Mengganti title menjadi Cycling
                  description: '20 minutes',
                  icon: Icons.directions_bike,
                  color: Colors.orange,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ActivityDetailPage(activityName: 'Cycling'),
                    ));
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24), // Menambahkan spasi di bagian bawah
        ],
      ),
    );
  }

  // Widget helper untuk membuat card metrik agar kode tidak berulang
  Widget _buildHealthMetricCard({
    required BuildContext context,
    required IconData icon,
    required String category,
    required Color iconColor,
    required String value,
    required String unit,
    required String status,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 160, // Menyamakan lebar dengan card lain
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
                    Text(category.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: iconColor.withOpacity(0.8))),
                    // Placeholder untuk menyamakan tinggi dengan card info
                    const SizedBox(height: 22), 
                    const Spacer(),
                    Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Theme.of(context).colorScheme.primary)),
                    Text('$unit - $status', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                  ],
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Icon(icon, color: iconColor, size: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget helper untuk membuat card INFORMASI
  Widget _buildInfoCard({
    required BuildContext context,
    required String category,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return SizedBox(
      width: 160,
      child: Card(
        elevation: 1,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(category.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: color.withOpacity(0.8))),
                  const SizedBox(height: 4),
                  const Spacer(),
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(description, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: Icon(icon, color: color, size: 24),
            ),
          ],
        ),
      ),
    );
  }

  // Widget helper untuk membuat card rekomendasi (makanan & aktivitas)
  Widget _buildRecommendationCard({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    VoidCallback? onTap, // Menambahkan parameter onTap opsional
  }) {
    return SizedBox(
      width: 160, // Menyamakan lebar dengan card lain
      child: Card(
        elevation: 1,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        clipBehavior: Clip.antiAlias, // Ensures InkWell ripple effect is clipped
        child: InkWell(
          onTap: onTap ?? () { // Jika onTap tidak disediakan, gunakan navigasi default ke FoodDetailPage
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => FoodDetailPage(foodName: title), // Default ke FoodDetailPage
            ));
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: color.withOpacity(0.15),
                  child: Icon(icon, color: color, size: 24),
                ),
                const Spacer(),
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(description, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}