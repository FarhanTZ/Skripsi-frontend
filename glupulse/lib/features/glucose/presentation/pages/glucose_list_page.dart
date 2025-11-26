import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:glupulse/core/usecases/usecase.dart';
import 'package:glupulse/features/glucose/domain/entities/glucose.dart';
import 'package:glupulse/features/HealthData/domain/entities/health_profile.dart';
import 'package:glupulse/features/HealthData/presentation/cubit/health_profile_state.dart'; // <-- Impor state // <-- Impor untuk AuthCubit
import 'package:glupulse/features/HealthData/presentation/cubit/health_profile_cubit.dart';
import 'package:glupulse/features/glucose/presentation/cubit/glucose_cubit.dart';
import 'package:glupulse/features/glucose/presentation/pages/add_edit_glucose_page.dart';

class GlucoseListPage extends StatefulWidget {
  const GlucoseListPage({super.key});

  @override
  State<GlucoseListPage> createState() => _GlucoseListPageState();
}

class _GlucoseListPageState extends State<GlucoseListPage> {
  @override
  void initState() {
    super.initState();
    _fetchGlucoseRecords();
    _fetchHealthProfile();
  }

  Future<void> _fetchGlucoseRecords() async {
    context.read<GlucoseCubit>().getGlucoseRecords();
  }

  Future<void> _fetchHealthProfile() async {
    // Memuat data profil kesehatan pengguna. userId akan diambil dari token secara otomatis.
    context.read<HealthProfileCubit>().getHealthProfile(NoParams());
  }

  void _navigateToInputPage({Glucose? glucose}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => InputGlucosePage(glucose: glucose),
      ),
    );
    // Tidak perlu fetch manual, BlocConsumer akan menangani refresh UI.
  }

  Color _trendColor(String? trend) {
    switch (trend) {
      case "rising_rapidly":
      case "rising":
        return Colors.red;
      case "falling_rapidly":
      case "falling":
        return Colors.orange;
      case "stable":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _trendIcon(String? trend) {
    switch (trend) {
      case "rising_rapidly":
        return Icons.keyboard_double_arrow_up;
      case "rising":
        return Icons.keyboard_arrow_up;
      case "falling_rapidly":
        return Icons.keyboard_double_arrow_down;
      case "falling":
        return Icons.keyboard_arrow_down;
      case "stable":
        return Icons.horizontal_rule;
      default:
        return Icons.help_outline;
    }
  }

  // Helper widget untuk menampilkan symptoms sebagai chip
  Widget _buildSymptomsChips(List<String> symptoms) {
    // Jika daftar symptoms kosong atau null, jangan tampilkan apa-apa
    if (symptoms.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Align(
        alignment: Alignment.centerLeft, // <-- Perubahan di sini
        child: Wrap(
          spacing: 6.0,
          runSpacing: 4.0,
          children: symptoms.map((symptom) {
            return Chip(
              avatar: Icon(Icons.local_fire_department_outlined, size: 16, color: Colors.orange.shade800),
              label: Text(
                symptom.replaceAll('_', ' '),
                style: TextStyle(color: Colors.orange.shade900, fontSize: 12),
              ),
              backgroundColor: Colors.orange.shade50,
            );
          }).toList(),
        ),
      ),
    );
  }

  // Widget baru untuk menampilkan bagian symptoms dari record terbaru
  Widget _buildLatestSymptomsSection(Glucose latestRecord) {
    // Jika tidak ada symptoms, jangan tampilkan apa-apa
    if (latestRecord.symptoms == null || latestRecord.symptoms!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Symptoms',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          // Menggunakan kembali _buildSymptomsChips untuk konsistensi
          // Padding di dalam _buildSymptomsChips diatur ulang ke nol agar tidak ada padding ganda
          Padding(
            padding: const EdgeInsets.only(top: 0), // Reset padding atas
            child: _buildSymptomsChips(latestRecord.symptoms!),
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan kartu target glukosa
  Widget _buildTargetCard(String title, int? value, IconData icon, Color iconColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white, // Warna latar belakang kartu
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
            // Kotak untuk ikon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),
            const SizedBox(height: 16),
            // Nilai (angka)
            Text(
              value != null ? '$value' : 'N/A',
              style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            // Judul kartu
            Text(
              title,
              style: TextStyle(color: Colors.grey.shade700, fontSize: 12, height: 1.3),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk menampilkan bagian target glukosa dari HealthProfile
  Widget _buildTargetRangesSection(HealthProfile profile) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
      child: Row(
        children: [
          _buildTargetCard('Fasting Target', profile.targetGlucoseFasting, Icons.wb_sunny_outlined, Colors.blue.shade600),
          const SizedBox(width: 16),
          _buildTargetCard('Post-Meal Target', profile.targetGlucosePostprandial, Icons.restaurant_menu_outlined, Colors.orange.shade600),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToInputPage(),
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                      'Glucose History',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
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
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                  ),
                ),
              ),
              BlocBuilder<GlucoseCubit, GlucoseState>(
                builder: (context, state) {
                  if (state is GlucoseLoaded && state.glucoseRecords.isNotEmpty) {
                    final latestRecord = state.glucoseRecords.first;
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
                                      text: latestRecord.glucoseValue.toString(),
                                      style: const TextStyle(fontSize: 75),
                                    ),
                                    const TextSpan(
                                      text: ' mg/dL',
                                      style: TextStyle(
                                          fontSize: 20, fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Icon(_trendIcon(latestRecord.trendArrow),
                                  color: _trendColor(latestRecord.trendArrow), size: 40),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Last Glucose Reading',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  // Tampilkan pesan jika tidak ada data sama sekali
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(child: Text("Belum ada data glukosa.")),
                  );
                },
              ),
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
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10))),
                  ),
                ),
              ),
              // --- Bagian Target Glukosa dari Health Profile ---
              BlocBuilder<HealthProfileCubit, HealthProfileState>(
                builder: (context, state) {
                  if (state is HealthProfileLoaded) {
                    // Jika data profil berhasil dimuat, tampilkan bagian target
                    return _buildTargetRangesSection(state.healthProfile);
                  }
                  // Selama loading atau jika ada error, jangan tampilkan apa-apa
                  // Anda bisa menambahkan CircularProgressIndicator kecil jika mau
                  return const SizedBox.shrink(

                  );
                },
              ),
              // --- Bagian Symptoms Terbaru ---
              BlocBuilder<GlucoseCubit, GlucoseState>(
                builder: (context, state) {
                  if (state is GlucoseLoaded && state.glucoseRecords.isNotEmpty) {
                    // Ambil record terbaru dan tampilkan symptoms-nya
                    final latestRecord = state.glucoseRecords.first;
                    return _buildLatestSymptomsSection(latestRecord);
                  }
                  // Jika tidak ada data, jangan tampilkan apa-apa
                  return const SizedBox.shrink();
                },
              ),

              // --- Judul History ---
              const Padding(
                padding: EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'History',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              BlocConsumer<GlucoseCubit, GlucoseState>(
                listener: (context, state) {
                  if (state is GlucoseAdded) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Glucose data added successfully')),
                    );
                    _fetchGlucoseRecords(); // Panggil fetch untuk memuat ulang data
                  }
                  if (state is GlucoseUpdated) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Glucose data updated successfully')),
                    );
                    _fetchGlucoseRecords(); // Panggil fetch untuk memuat ulang data
                  } else if (state is GlucoseDeleted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Glucose data deleted successfully')),
                    );
                    _fetchGlucoseRecords(); // Panggil fetch untuk memuat ulang data
                  } else if (state is GlucoseError) {
                     ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is GlucoseLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is GlucoseLoaded) {
                    if (state.glucoseRecords.isEmpty) {
                      return const Center(
                        child: Text('No glucose data available. Add a record.'),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                      itemCount: state.glucoseRecords.length,
                      itemBuilder: (context, index) {
                        final record = state.glucoseRecords[index];
                        return Dismissible(
                          key: Key(record.readingId!),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (direction) async {
                            return await showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Confirm Delete'),
                                content: const Text(
                                    'Are you sure you want to delete this record?'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('No'),
                                    onPressed: () => Navigator.of(ctx).pop(false),
                                  ),
                                  TextButton(
                                    child: const Text('Yes'),
                                    onPressed: () => Navigator.of(ctx).pop(true),
                                  ),
                                ],
                              ),
                            );
                          },
                          onDismissed: (direction) {
                            context
                                .read<GlucoseCubit>()
                                .deleteGlucose(record.readingId!);
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
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            elevation: 4,
                            clipBehavior: Clip.antiAlias,
                            child: InkWell(
                              onTap: () => _navigateToInputPage(glucose: record),
                              child: IntrinsicHeight(
                                child: Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      color: const Color(0xFF0F67FE),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 16),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                            Text(
                                            "${record.glucoseValue}",
                                            style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const Text(
                                            "mg/dL",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white70,
                                            ),
                                          )
                                        ]
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 12.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              record.readingType.replaceAll('_', ' ').toUpperCase(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              DateFormat('dd MMM yyyy, HH:mm')
                                                  .format(record.readingTimestamp),
                                              style: const TextStyle(
                                                  fontSize: 12, color: Colors.black54),
                                            ),
                                            if (record.deviceName != null && record.deviceName!.isNotEmpty) ...[
                                              const SizedBox(height: 4),
                                              Text(
                                                "Device: ${record.deviceName!}",
                                                style: const TextStyle(fontSize: 12, color: Colors.black54),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                            if (record.deviceId != null && record.deviceId!.isNotEmpty) ...[
                                              const SizedBox(height: 4),
                                              Text(
                                                "ID: ${record.deviceId!}",
                                                style: const TextStyle(fontSize: 12, color: Colors.black54),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                            // Gejala sekarang ditampilkan di atas daftar
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 16.0),
                                      child: Row(
                                          children: [
                                            Icon(_trendIcon(record.trendArrow), color: _trendColor(record.trendArrow)),
                                            const SizedBox(width: 4),
                                            Text(
                                              record.trendArrow ?? "stable",
                                              style: TextStyle(color: _trendColor(record.trendArrow), fontWeight: FontWeight.bold, fontSize: 12),
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
                  if (state is GlucoseError) {
                    return Center(child: Text('Terjadi kesalahan: ${state.message}'));
                  }
                  return const Center(child: Text('Tidak ada data untuk ditampilkan.'));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
