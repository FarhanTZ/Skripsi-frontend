import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:glupulse/features/health_event/domain/entities/health_event.dart';
import 'package:glupulse/features/health_event/presentation/cubit/health_event_cubit.dart';
import 'package:glupulse/features/health_event/presentation/pages/health_event_history_page.dart';
import 'package:glupulse/features/health_event/presentation/pages/add_edit_health_event_page.dart';

class HealthEventListPage extends StatefulWidget {
  const HealthEventListPage({super.key});

  @override
  State<HealthEventListPage> createState() => _HealthEventListPageState();
}

class _HealthEventListPageState extends State<HealthEventListPage> {
  // Daftar tipe event yang bisa dipilih, diambil dari add_edit_health_event_page.dart
  final List<String> _eventTypes = [
    'hypoglycemia',
    'hyperglycemia',
    'illness',
    'other'
  ];
  String? _selectedEventType; // State untuk menyimpan event type yang dipilih
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

  void _navigateToHistoryPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const HealthEventHistoryPage(),
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

  // Widget baru untuk dropdown event type dengan tampilan seperti kartu
  Widget _buildEventTypeDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedEventType,
        items: _eventTypes.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            _selectedEventType = newValue;
          });
        },
        decoration: InputDecoration(
          label: Row(
            mainAxisSize: MainAxisSize.min, // Agar Row tidak mengambil semua lebar
            children: const [
              Text('Event Type'),
              SizedBox(width: 8),
              Icon(Icons.event_note, size: 20, color: Colors.black87),
            ],
          ),
          labelStyle: const TextStyle(fontSize: 14, color: Colors.black54),
          border: InputBorder.none,
          // contentPadding diatur agar tidak terlalu rapat dengan label
          contentPadding: const EdgeInsets.only(top: 4),
        ),
        isExpanded: true,
      ),
    );
  }

  // --- Helper untuk warna berdasarkan tipe event ---
  Color _eventColor(String eventType) {
    switch (eventType.toLowerCase()) {
      case "hypoglycemia":
        return Colors.orange.shade700;
      case "hyperglycemia":
        return Colors.red.shade700;
      case "illness":
        return Colors.purple.shade700;
      case "other":
      default:
        return Colors.blue.shade700;
    }
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
                  if (state is HealthEventAdded || state is HealthEventUpdated || state is HealthEventDeleted) {
                    if (state is HealthEventUpdated || state is HealthEventDeleted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state is HealthEventUpdated ? 'Event updated successfully' : 'Event deleted successfully')),
                      );
                    }
                    // Panggil fetch di sini untuk memastikan data selalu terbaru setelah aksi
                    _fetchHealthEventRecords();
                  }
                },
                builder: (context, state) {
                  if (state is HealthEventLoading || state is HealthEventAdded || state is HealthEventUpdated || state is HealthEventDeleted) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is HealthEventLoaded) {
                    if (state.healthEventRecords.isEmpty) {
                      return const Center(
                          child: Text("Belum ada data Health Event."));
                    }

                    // Inisialisasi _selectedEventType jika masih null
                    if (_selectedEventType == null && state.healthEventRecords.isNotEmpty) {
                      _selectedEventType = state.healthEventRecords.first.eventType;
                    }

                    HealthEvent? latestFilteredEvent;
                    if (state.healthEventRecords.isNotEmpty) {
                      // Cari event yang cocok dengan _selectedEventType
                      final matchingEvents = state.healthEventRecords
                          .where((event) => event.eventType == _selectedEventType);

                      if (matchingEvents.isNotEmpty) {
                        latestFilteredEvent = matchingEvents.first;
                      }
                      // Jika matchingEvents kosong, latestFilteredEvent akan tetap null,
                      // yang akan ditangani oleh kondisi if (latestFilteredEvent == null) di bawah.
                    }

                    if (latestFilteredEvent == null) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Tidak ada data untuk event type yang dipilih."),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                // Ambil state terbaru langsung dari Cubit, ini lebih aman.
                                final currentState = context.read<HealthEventCubit>().state;
                                setState(() {
                                  // Reset filter ke event paling baru yang ada di state
                                  if (currentState is HealthEventLoaded && currentState.healthEventRecords.isNotEmpty) {
                                    _selectedEventType = currentState.healthEventRecords.first.eventType;
                                  }
                                });
                              },
                              child: const Text('Reset Filter'),
                            ),
                          ],
                        ),
                      );
                    }

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
                                    _buildEventTypeDropdown(), // Menggunakan dropdown baru
                                    const SizedBox(height: 12),
                                    _buildSingleSummaryCard(
                                      _buildSummaryCard(
                                        title: "Glucose",
                                        value: "${latestFilteredEvent.glucoseValue ?? 'N/A'} mg/dL",
                                        icon: Icons.bloodtype,
                                        color: Colors.red.shade50,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    _buildSingleSummaryCard(
                                      _buildSummaryCard(
                                        title: "Ketone",
                                        value:
                                            "${latestFilteredEvent.ketoneValueMmol ?? 'N/A'} mmol",
                                        icon: Icons.science,
                                        color: Colors.orange.shade50,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    _buildSingleSummaryCard(
                                      _buildSummaryCard(
                                        title: "Severity",
                                        value: latestFilteredEvent.severity,
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
                                _buildChipList("Symptoms", latestFilteredEvent.symptoms),
                                const SizedBox(height: 16),
                                _buildChipList("Treatments", latestFilteredEvent.treatments),
                              ],
                            ),
                          ),

                          const SizedBox(height: 30),

                          // ------------------------
                          // 📜 History Section
                          // ------------------------
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "History Health Event",
                                  style: TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold),
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
                          const SizedBox(height: 12),

                          ListView.builder(
                            itemCount: state.healthEventRecords.take(5).length, // Batasi hanya 5 item
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final event = state.healthEventRecords.take(5).toList()[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 16.0), // Padding untuk setiap item list
                                child: Dismissible(
                                  key: Key(event.id!),
                                  direction: DismissDirection.endToStart,
                                  confirmDismiss: (direction) async {
                                    final confirmed = await showDialog<bool>(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text('Konfirmasi Hapus'),
                                        content: const Text('Yakin ingin menghapus riwayat event ini?'),
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
                                    context.read<HealthEventCubit>().deleteHealthEvent(event.id!);                                    
                                  },
                                  background: Container(
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.only(right: 20.0),
                                    margin: const EdgeInsets.only(bottom: 16), // Sesuaikan dengan margin Card
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
                                      onTap: () => _navigateToAddEditPage(
                                          healthEvent: event),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Bagian Atas: Tipe Event
                                          Container(
                                            width: double.infinity,
                                            color: _eventColor(event.eventType),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 8),
                                            child: Text(
                                              event.eventType.toUpperCase(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          // Bagian Bawah: Detail Teks
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Row(children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        "Severity: ${event.severity}",
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14)),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                        "Glukosa: ${event.glucoseValue ?? 'N/A'} mg/dL",
                                                        style: const TextStyle(
                                                            color: Colors
                                                                .black54,
                                                            fontSize: 12)),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                        "Tanggal: ${DateFormat('dd MMM yyyy').format(event.eventDate)}",
                                                        style: const TextStyle(
                                                            fontSize: 12,
                                                            color: Colors
                                                                .black54)),
                                                  ],
                                                ),
                                              ),
                                              Icon(Icons.arrow_forward_ios,
                                                  color: Colors.grey.shade400,
                                                  size: 16),
                                            ]),
                                          ),
                                    ],
                                    ), 
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
