import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glupulse/features/health_event/domain/entities/health_event.dart';
import 'package:glupulse/features/health_event/presentation/cubit/health_event_cubit.dart';
import 'package:glupulse/features/health_event/presentation/pages/add_edit_health_event_page.dart';
import 'package:intl/intl.dart';

class HealthEventHistoryPage extends StatefulWidget {
  const HealthEventHistoryPage({super.key});

  @override
  State<HealthEventHistoryPage> createState() => _HealthEventHistoryPageState();
}

class _HealthEventHistoryPageState extends State<HealthEventHistoryPage> {
  // Daftar filter berdasarkan tipe event
  final List<String> _filters = ['all', 'hypoglycemia', 'hyperglycemia', 'illness', 'other'];
  String _selectedFilter = 'all'; // Filter yang aktif

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
    _fetchHealthEventRecords();
  }

  // Helper untuk warna berdasarkan tipe event
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
      appBar: AppBar(
        toolbarHeight: 80,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
        title: const Text(
          'Riwayat Event Lengkap',
          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: BlocConsumer<HealthEventCubit, HealthEventState>(
              listener: (context, state) {
                if (state is HealthEventDeleted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Data berhasil dihapus')),
                  );
                  _fetchHealthEventRecords();
                }
              },
              builder: (context, state) {
                if (state is HealthEventLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is HealthEventLoaded) {
                  if (state.healthEventRecords.isEmpty) {
                    return const Center(child: Text('Belum ada data Health Event.'));
                  }

                  // Logika pemfilteran data
                  final filteredRecords = _selectedFilter == 'all'
                      ? state.healthEventRecords
                      : state.healthEventRecords.where((event) => event.eventType == _selectedFilter).toList();

                  if (filteredRecords.isEmpty) {
                    return const Center(child: Text('Tidak ada data untuk filter yang dipilih.'));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                    itemCount: filteredRecords.length,
                    itemBuilder: (context, index) {
                      final event = filteredRecords[index];
                      return Dismissible(
                        key: Key(event.id!),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (direction) async {
                          return await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Konfirmasi Hapus'),
                                  content: const Text('Yakin ingin menghapus riwayat event ini?'),
                                  actions: <Widget>[
                                    TextButton(child: const Text('Tidak'), onPressed: () => Navigator.of(ctx).pop(false)),
                                    TextButton(child: const Text('Ya'), onPressed: () => Navigator.of(ctx).pop(true)),
                                  ],
                                ),
                              ) ?? false;
                        },
                        onDismissed: (direction) {
                          context.read<HealthEventCubit>().deleteHealthEvent(event.id!);
                        },
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20.0),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(16)),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: Card(
                          color: Colors.white,
                          margin: const EdgeInsets.only(bottom: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 4,
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: () => _navigateToAddEditPage(healthEvent: event),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                          Text("Severity: ${event.severity}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14)),
                                          const SizedBox(height: 4),
                                          Text(
                                              "Glukosa: ${event.glucoseValue ?? 'N/A'} mg/dL",
                                              style: const TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 12)),
                                          const SizedBox(height: 4),
                                          Text(
                                              "Tanggal: ${DateFormat('dd MMM yyyy').format(event.eventDate)}",
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black54)),
                                        ],
                                      ),
                                    ),
                                    Icon(Icons.arrow_forward_ios,
                                        color: Colors.grey.shade400, size: 16),
                                  ]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
                return const Center(child: Text('Terjadi kesalahan'));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Row(
        children: _filters.map((filter) => _buildFilterOption(label: filter, filterValue: filter)).toList(),
      ),
    );
  }

  Widget _buildFilterOption({required String label, required String filterValue}) {
    final bool isActive = _selectedFilter == filterValue;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedFilter = filterValue),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(color: isActive ? Theme.of(context).colorScheme.primary : Colors.transparent, borderRadius: BorderRadius.circular(8)),
          child: Text(label, textAlign: TextAlign.center, style: TextStyle(color: isActive ? Colors.white : Colors.black54, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
        ),
      ),
    );
  }
}