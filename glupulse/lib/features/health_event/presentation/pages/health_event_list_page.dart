import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:glupulse/features/health_event/domain/entities/health_event.dart';
import 'package:glupulse/features/health_event/presentation/cubit/health_event_cubit.dart';
import 'package:glupulse/features/health_event/presentation/pages/add_edit_health_event_page.dart';

class HealthEventListPage extends StatefulWidget {
  const HealthEventListPage({super.key});

  @override
  State<HealthEventListPage> createState() => _HealthEventListPageState();
}

class _HealthEventListPageState extends State<HealthEventListPage> {
  @override
  void initState() {
    super.initState();
    _fetchHealthEventRecords();
  }

  Future<void> _fetchHealthEventRecords() async {
    context.read<HealthEventCubit>().getHealthEventRecords();
  }

  void _navigateToAddEditPage({HealthEvent? healthEvent}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddEditHealthEventPage(healthEvent: healthEvent),
      ),
    );
    // _fetchHealthEventRecords(); // Dihapus: Biarkan BlocConsumer yang menangani refresh
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this record?'),
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () {
              context.read<HealthEventCubit>().deleteHealthEvent(id);
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    IconData? icon,
    Color? color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center, // Pusatkan konten secara vertikal
        children: [
          if (icon != null) Icon(icon, size: 26, color: Colors.black87),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSingleSummaryCard(Widget card) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: card),
        ],
      ),
    );
  }

  Widget _buildChipList(String label, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: items
              .map((e) => Chip(
                    label: Text(e),
                    backgroundColor: Colors.blue.shade50,
                  ))
              .toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddEditPage(),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, size: 30),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // --- Header Kustom ---
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                  const Text(
                    'Health Event Analytics',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocConsumer<HealthEventCubit, HealthEventState>( // Diubah dari BlocBuilder
                listener: (context, state) {
                  // Listener untuk memuat ulang data saat ada perubahan
                  if (state is HealthEventUpdated || state is HealthEventDeleted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state is HealthEventUpdated ? 'Event updated successfully' : 'Event deleted successfully')),
                    );
                    // Panggil fetch di sini untuk memastikan data selalu terbaru setelah aksi
                    _fetchHealthEventRecords();
                  }
                },
                builder: (context, state) {
                  if (state is HealthEventLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is HealthEventLoaded) {
                    if (state.healthEventRecords.isEmpty) {
                      return const Center(
                          child: Text("Belum ada data Health Event."));
                    }

                    final latest = state.healthEventRecords.first;

                    return SingleChildScrollView(
                      padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16), // Hapus padding kanan
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // <-- TAMBAHKAN INI
                        children: [
                          // ------------------------
                          // 🔥 Analytic Summary
                          // ------------------------
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center, // Pusatkan item secara vertikal
                            children: [
                              // --- Kolom Kiri: Kartu Ringkasan ---
                              Expanded(
                                flex: 5, // Beri ruang lebih untuk kartu
                                child: Column( // Padding kanan ditambahkan di sini untuk kartu
                                  children: [
                                    _buildSingleSummaryCard(
                                      _buildSummaryCard(
                                        title: "Event Type",
                                        value: latest.eventType,
                                        icon: Icons.event_note,
                                       ),
                                    ),
                                    const SizedBox(height: 12),
                                    _buildSingleSummaryCard(
                                      _buildSummaryCard(
                                        title: "Glucose",
                                        value: "${latest.glucoseValue} mg/dL",
                                        icon: Icons.bloodtype,
                                        color: Colors.red.shade50,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    _buildSingleSummaryCard(
                                      _buildSummaryCard(
                                        title: "Ketone",
                                        value: "${latest.ketoneValueMmol} mmol",
                                        icon: Icons.science,
                                        color: Colors.orange.shade50,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    _buildSingleSummaryCard(
                                      _buildSummaryCard(
                                        title: "Severity",
                                        value: latest.severity,
                                        icon: Icons.warning,
                                        color: Colors.yellow.shade50,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16), // Jarak antara kartu dan gambar                              
                              // --- Kolom Kanan: Gambar ---
                              Expanded(
                                flex: 4, // Sesuaikan rasio flex sesuai kebutuhan
                                child: ClipRect( // Gunakan ClipRect untuk memotong widget
                                  child: Align(
                                    alignment: Alignment.centerLeft, // Posisikan gambar dari KIRI
                                    widthFactor: 0.5, // Ambil 50% bagian KIRI dari gambar
                                    child: Image.asset(
                                      'assets/images/placeholder_health.png',
                                      fit: BoxFit.cover, // Pastikan gambar menutupi area
                                      height: 500, // Sesuaikan tinggi gambar
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Symptoms & Treatments (diberi padding kanan secara manual)
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildChipList("Symptoms", latest.symptoms),
                                const SizedBox(height: 16),
                                _buildChipList("Treatments", latest.treatments),
                              ],
                            ),
                          ),

                          const SizedBox(height: 30),

                          // ------------------------
                          // 📜 History Section
                          // ------------------------
                          const Align(
                            alignment: Alignment.centerLeft,                            
                            child: Padding(
                              padding: EdgeInsets.only(right: 16.0), // Padding untuk judul history
                              child: Text(
                                "History Health Event",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          ListView.builder(
                            itemCount: state.healthEventRecords.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final event = state.healthEventRecords[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 16.0), // Padding untuk setiap item list
                                child: Card(
                                  child: ListTile(
                                    title: Text(
                                      "${event.eventType} (${event.severity})",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      "Tanggal: ${DateFormat('dd MMM yyyy').format(event.eventDate)}",
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () => _navigateToAddEditPage(
                                              healthEvent: event),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () =>
                                              _confirmDelete(context, event.id!),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  }

                  return const Center(child: Text("Tidak ada data."));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
