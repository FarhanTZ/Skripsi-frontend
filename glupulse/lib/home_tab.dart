import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glupulse/features/Food/presentation/cubit/food_cubit.dart';
import 'package:glupulse/features/Food/presentation/widgets/food_card.dart';
import 'package:glupulse/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:glupulse/features/activity/presentation/pages/activity_detail_page.dart';
import 'package:glupulse/features/Food/presentation/pages/food_detail_page.dart';
import 'package:glupulse/features/HealthData/presentation/pages/input_health_data_page.dart';
import 'package:glupulse/features/auth/presentation/cubit/auth_state.dart';
import 'package:glupulse/features/notification/presentation/pages/notification_page.dart';
import 'package:glupulse/features/HealthData/presentation/pages/health_metric_detail_page.dart';
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
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const InputHealthDataPage(),
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
                        child: Text(
                          '5.7%', // Contoh Skor
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Last Hba1c',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 4),
                            Text(
                              'based on your data, we think your health status is above average',
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
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
                _buildHealthMetricCard(
                  context: context,
                  category: 'Blood Sugar',
                  iconWidget: SvgPicture.asset(
                    'assets/images/Health.svg', // Menggunakan SVG asset
                    colorFilter: const ColorFilter.mode(Colors.redAccent, BlendMode.srcIn),
                    width: 24,
                  ),
                  iconColor: Colors.redAccent,
                  value: '110',
                  unit: 'mg/dL',
                  status: 'Critical',
                  statusText: 'Critical', // Status baru
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
                _buildHealthMetricCard(
                  context: context,
                  category: 'BMI',
                  iconWidget: SvgPicture.asset(
                    'assets/images/bmi.svg', // Menggunakan SVG asset yang baru
                    colorFilter: const ColorFilter.mode(Colors.green, BlendMode.srcIn), // Warna tetap hijau
                    width: 24,
                  ),
                  iconColor: Colors.green,
                  value: '22.5',
                  unit: 'kg/m²',
                  status: 'Normal',
                  statusText: 'Normal',
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
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
            const SizedBox(height: 16),

            // --- Recommendation Food Cards ---
          SizedBox(
            height: 191,
            child: _buildRecommendationFoodList(),
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
                    fontSize: 20,
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
                  title: 'Walking Class',
                  price: 'Rp 50.000',
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
                  title: 'Yoga Class',
                  price: 'Rp 65.000',
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
                  title: 'Cycling Tour',
                  price: 'Rp 80.000',
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
      },
    );
  }

  // Widget baru untuk membangun daftar rekomendasi makanan dari API
  Widget _buildRecommendationFoodList() {
    return BlocBuilder<FoodCubit, FoodState>(
      builder: (context, state) {
        if (state is FoodLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FoodLoaded) {
          // Ambil hanya makanan (bukan minuman) dan batasi 5 item untuk rekomendasi
          final recommendedFoods = state.foods
              .where((f) => f.tags?.contains('drink') == false)
              .take(5)
              .toList();

          return ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            itemCount: recommendedFoods.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final food = recommendedFoods[index];
              // Gunakan FoodCard yang sudah ada
              return FoodCard(
                food: food,
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => FoodDetailPage(food: food)));
                },
              );
            },
          );
        } else if (state is FoodError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        // State awal atau jika tidak ada data
        return const Center(
          child: Text('No food recommendations available.'),
        );
      },
    );
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

  // Widget helper untuk membuat card rekomendasi (makanan & aktivitas)
  Widget _buildRecommendationCard({
    required BuildContext context,
    required String title, // Kembalikan parameter title
    required String price, // Kembalikan parameter price
    required IconData icon,
    required Color color,
    VoidCallback? onTap, // Menambahkan parameter onTap opsional
  }) {
    return SizedBox(
      width: 170, // Menyamakan lebar dengan card lain
      child: Card(
        elevation: 1,
        margin: EdgeInsets.zero,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        clipBehavior: Clip.antiAlias, // Ensures InkWell ripple effect is clipped
        child: InkWell(
          onTap: onTap, // Gunakan onTap yang diberikan dari pemanggil
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bagian Gambar/Ikon
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                  ),
                  child: Center(
                    child: Icon(icon, color: color, size: 40),
                  ),
                ),
              ),
              // Bagian Teks (Judul dan Harga)
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        maxLines: 2, // Batasi judul hingga 2 baris
                        overflow: TextOverflow.ellipsis, // Tampilkan '...' jika lebih dari 2 baris
                      ),
                    const SizedBox(height: 4),
                    Text(price, style: TextStyle(
                        fontSize: 14, 
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Hapus extension AppThemeRandomColor karena tidak lagi digunakan di sini