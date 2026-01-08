import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:glupulse/features/HealthData/presentation/cubit/health_profile_cubit.dart';
import 'package:glupulse/features/hba1c/domain/entities/hba1c.dart';
import 'package:glupulse/features/hba1c/presentation/cubit/hba1c_cubit.dart';
import 'package:glupulse/features/hba1c/presentation/pages/hba1c_history_page.dart';
import 'package:glupulse/features/hba1c/presentation/pages/add_edit_hba1c_page.dart';
import '../../../HealthData/presentation/cubit/health_profile_state.dart';

class Hba1cListPage extends StatefulWidget {
  const Hba1cListPage({super.key});

  @override
  State<Hba1cListPage> createState() => _Hba1cListPageState();
}

class _Hba1cListPageState extends State<Hba1cListPage> {
  @override
  void initState() {
    super.initState();
    _fetchHba1cRecords();
    // Memastikan data profil kesehatan juga diambil saat halaman dimuat
    context.read<HealthProfileCubit>().fetchHealthProfile();
  }

  Future<void> _fetchHba1cRecords() async {
    context.read<Hba1cCubit>().getHba1cRecords();
  }

  void _navigateToAddEditPage({Hba1c? hba1c}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddEditHba1cPage(hba1c: hba1c),
      ),
    );
    _fetchHba1cRecords();
  }

  void _navigateToHistoryPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const Hba1cHistoryPage(),
      ),
    );
  }


  // --- Helper untuk warna berdasarkan trend ---
  Color _trendColor(String? trend) {
    switch (trend) {
      case "improving":
        return Colors.green;
      case "worsening":
        return Colors.red;
      case "stable":
      default:
        return Colors.blue;
    }
  }

  IconData _trendIcon(String? trend) {
    switch (trend) {
      case "improving":
        return Icons.trending_up;
      case "worsening":
        return Icons.trending_down;
      case "stable":
      default:
        return Icons.horizontal_rule;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      // AppBar dihilangkan untuk diganti dengan header kustom di dalam body.
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddEditPage(),
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SingleChildScrollView( // Bungkus seluruh konten dengan SingleChildScrollView
        child: SafeArea( // Tetap gunakan SafeArea untuk menghindari tumpang tindih dengan status bar
          child: Column(
            children: [
              // --- Header Kustom ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Tombol Kembali di kiri
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    // Judul di tengah
                    const Text( // Diubah dari 'HbA1c'
                      'Ringkasan HbA1c',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              // --- Dekorasi Garis Atas (Kiri ke Tengah) ---
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 10,
                    width: MediaQuery.of(context).size.width / 2.2,
                    decoration: BoxDecoration(
                        color: const Color(0xFF0F67FE),
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(10), bottomRight: Radius.circular(10))),
                  ),
                ),
              ),
              // --- WIDGET UNTUK HBA1C TERAKHIR (BENTUK TEKS) ---
              BlocBuilder<Hba1cCubit, Hba1cState>(
                builder: (context, state) {
                  String percentage = 'N/A';
                  String? trend = 'stable';

                  if (state is Hba1cLoaded && state.hba1cRecords.isNotEmpty) {
                    final latestRecord = state.hba1cRecords.first;
                    percentage = latestRecord.hba1cPercentage.toStringAsFixed(1);
                    trend = latestRecord.trend;
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
                      children: [                          
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: percentage,
                                    style: const TextStyle(fontSize: 75),
                                  ),
                                  if (percentage != 'N/A')
                                    const TextSpan(
                                      text: '%',
                                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(_trendIcon(trend), color: _trendColor(trend), size: 28),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Last Hba1c',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              // --- Dekorasi Garis Bawah (Kanan ke Tengah) ---
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    height: 10,
                    width: MediaQuery.of(context).size.width / 2.2,
                    decoration: BoxDecoration(
                        color: const Color(0xFF0F67FE),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10), bottomLeft: Radius.circular(10))),
                  ),
                ),
              ),
              // --- Judul untuk Main Overview ---
              const Padding(
                padding: EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Main Overview',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // --- DUA KARTU INFORMASI (ESTIMASI GLUKOSA & TARGET) ---
              BlocBuilder<HealthProfileCubit, HealthProfileState>(
                builder: (context, healthProfileState) {
                  return BlocBuilder<Hba1cCubit, Hba1cState>(
                    builder: (context, hba1cState) {
                      String eAgValue = 'N/A';
                      String hba1cTargetValue = '< 7.0'; // Nilai default

                      if (hba1cState is Hba1cLoaded && hba1cState.hba1cRecords.isNotEmpty) {
                        final latestHba1cRecord = hba1cState.hba1cRecords.first;
                        eAgValue = latestHba1cRecord.estimatedAvgGlucose?.toString() ?? 'N/A';
                      }

                      if (healthProfileState is HealthProfileLoaded) {
                        final hba1cTarget = healthProfileState.healthProfile.hba1cTarget;
                        if (hba1cTarget != null) {
                          hba1cTargetValue = '< ${hba1cTarget.toStringAsFixed(1)}';
                        }
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                        child: IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: _buildInfoCard(
                                  context,
                                  icon: Icons.water_drop_outlined,
                                  title: 'Estimasi Glukosa\nRata-Rata',
                                  value: eAgValue,
                                  unit: 'mg/dL',
                                  backgroundColor: Colors.white,
                                  valueColor: Colors.redAccent,
                                  iconBackgroundColor: Colors.redAccent.withOpacity(0.1),
                                  textColor: Colors.black87,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildInfoCard(
                                  context,
                                  icon: Icons.flag_outlined,
                                  title: 'Hba1c Target',
                                  value: hba1cTargetValue,
                                  unit: '%',
                                  backgroundColor: Colors.white,
                                  iconBackgroundColor: Colors.green.shade50,
                                  valueColor: Colors.green.shade800,
                                  textColor: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              // --- Judul untuk Riwayat ---
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'History Hba1c',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: _navigateToHistoryPage,
                      child: Text(
                        'Lihat Semua',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // --- Konten Utama (List) ---
              BlocConsumer<Hba1cCubit, Hba1cState>(
                listener: (context, state) {
                  if (state is Hba1cUpdated) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Data HbA1c berhasil diperbarui')),
                    );
                  } else if (state is Hba1cDeleted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Data berhasil dihapus')),
                    );
                    _fetchHba1cRecords();
                  }
                },
                builder: (context, state) {
                  if (state is Hba1cLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is Hba1cLoaded) {
                    if (state.hba1cRecords.isEmpty) {
                      return const Center(
                        child: Text('Belum ada data HbA1c, silakan tambah data.'),
                      );
                    }

                    final limitedRecords = state.hba1cRecords.take(5).toList();

                    return ListView.builder(
                      shrinkWrap: true, // Penting: agar ListView tidak mencoba mengambil semua ruang yang tersedia
                      physics: const NeverScrollableScrollPhysics(), // Penting: agar ListView tidak memiliki scroll sendiri
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 80), // Padding bawah untuk FAB
                      itemCount: limitedRecords.length,
                      itemBuilder: (context, index) {
                        final h = limitedRecords[index];

                        // --- GESTUR SWIPE-TO-DELETE ---
                        return Dismissible(
                          key: Key(h.id!), // Key unik untuk setiap item
                          direction: DismissDirection.endToStart, // Geser dari kanan ke kiri
                          confirmDismiss: (direction) async {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Konfirmasi Hapus'),
                                content: const Text('Yakin ingin menghapus data HBA1c ini?'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Tidak'),
                                    onPressed: () => Navigator.of(ctx).pop(false),
                                  ),
                                  TextButton(
                                    child: const Text('Ya'),
                                    onPressed: () => Navigator.of(ctx).pop(true),
                                  ),
                                ],
                              ),
                            );
                            return confirmed ?? false;
                          },
                          onDismissed: (direction) {
                            // Fungsi ini hanya akan dipanggil jika confirmDismiss mengembalikan true
                            context.read<Hba1cCubit>().deleteHba1c(h.id!);                           
                          },
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20.0),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          child: Card(
                            color: Colors.white,
                            margin: const EdgeInsets.only(bottom: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 4,
                            clipBehavior: Clip.antiAlias,
                            child: InkWell(
                              onTap: h.id == null ? null : () => _navigateToAddEditPage(hba1c: h),
                              child: IntrinsicHeight(
                                child: Row(
                                  children: [
                                    // Bagian Kiri: Nilai HbA1c
                                    Container(
                                      color: const Color(0xFF0F67FE),
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                      child: Center(
                                        child: Text(
                                          "${h.hba1cPercentage}%",
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Bagian Tengah: Detail Teks
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text("mmol/mol: ${h.hba1cMmolMol ?? 'N/A'}", style: const TextStyle(color: Colors.black54, fontSize: 12)),
                                            const SizedBox(height: 4),
                                            Text("Perubahan: ${h.changeFromPrevious != null ? h.changeFromPrevious!.toStringAsFixed(1) : 'N/A'}%", style: const TextStyle(color: Colors.black54, fontSize: 12)),
                                            const SizedBox(height: 4),
                                            Text("Tanggal Tes: ${DateFormat('dd MMM yyyy').format(h.testDate)}", style: const TextStyle(fontSize: 12, color: Colors.black54)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Bagian Kanan: Hanya Trend
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                      child:
                                        Row(
                                          children: [
                                            Icon(_trendIcon(h.trend), color: _trendColor(h.trend)),
                                            const SizedBox(width: 4),
                                            Text(
                                              h.trend ?? "stable",
                                              style: TextStyle(color: _trendColor(h.trend), fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }

                  return const Center(child: Text('Belum ada data HbA1c'));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget untuk membuat kartu informasi
  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required String unit,
    required Color backgroundColor,
    required Color valueColor,
    required Color iconBackgroundColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: valueColor,
              size: 24,
            ),
          ),
          const SizedBox(height: 16), // Ganti Spacer dengan SizedBox untuk tinggi yang konsisten
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: textColor)),
              const SizedBox(width: 4),
              Text(unit, style: TextStyle(fontSize: 12, color: textColor, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 12, height: 1.3),
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
