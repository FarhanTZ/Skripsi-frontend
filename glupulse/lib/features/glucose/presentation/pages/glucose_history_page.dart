import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glupulse/features/glucose/domain/entities/glucose.dart';
import 'package:glupulse/features/glucose/presentation/cubit/glucose_cubit.dart';
import 'package:glupulse/features/glucose/presentation/pages/add_edit_glucose_page.dart';
import 'package:intl/intl.dart';

enum GlucoseFilter { day, week, month, year, all }

class GlucoseHistoryPage extends StatefulWidget {
  const GlucoseHistoryPage({super.key});

  @override
  State<GlucoseHistoryPage> createState() => _GlucoseHistoryPageState();
}

class _GlucoseHistoryPageState extends State<GlucoseHistoryPage> {
  GlucoseFilter _selectedFilter = GlucoseFilter.all;

  @override
  void initState() {
    super.initState();
    _fetchGlucoseRecords();
  }

  Future<void> _fetchGlucoseRecords() async {
    context.read<GlucoseCubit>().getGlucoseRecords();
  }

  void _navigateToAddEditPage({Glucose? glucose}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => InputGlucosePage(glucose: glucose),
      ),
    );
    _fetchGlucoseRecords();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      appBar: AppBar(
        toolbarHeight: 80,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        title: const Text(
          'Riwayat Glukosa Lengkap',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: BlocConsumer<GlucoseCubit, GlucoseState>(
              listener: (context, state) {
                if (state is GlucoseDeleted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Data berhasil dihapus')),
                  );
                  _fetchGlucoseRecords();
                }
              },
              builder: (context, state) {
                if (state is GlucoseLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is GlucoseLoaded) {
                  if (state.glucoseRecords.isEmpty) {
                    return const Center(
                      child: Text('Belum ada data glukosa.'),
                    );
                  }

                  final now = DateTime.now();
                  List<Glucose> filteredRecords;

                  switch (_selectedFilter) {
                    case GlucoseFilter.day:
                      filteredRecords = state.glucoseRecords.where((h) {
                        return h.readingTimestamp.year == now.year &&
                            h.readingTimestamp.month == now.month &&
                            h.readingTimestamp.day == now.day;
                      }).toList();
                      break;
                    case GlucoseFilter.week:
                      final oneWeekAgo = now.subtract(const Duration(days: 7));
                      filteredRecords = state.glucoseRecords
                          .where((h) => h.readingTimestamp.isAfter(oneWeekAgo))
                          .toList();
                      break;
                    case GlucoseFilter.month:
                      final oneMonthAgo = now.subtract(const Duration(days: 30));
                      filteredRecords = state.glucoseRecords
                          .where((h) => h.readingTimestamp.isAfter(oneMonthAgo))
                          .toList();
                      break;
                    case GlucoseFilter.year:
                      final oneYearAgo = now.subtract(const Duration(days: 365));
                      filteredRecords = state.glucoseRecords
                          .where((h) => h.readingTimestamp.isAfter(oneYearAgo))
                          .toList();
                      break;
                    case GlucoseFilter.all:
                    default:
                      filteredRecords = state.glucoseRecords;
                  }
                  
                  // Sort descending by date
                  filteredRecords.sort((a, b) => b.readingTimestamp.compareTo(a.readingTimestamp));

                  if (filteredRecords.isEmpty) {
                     return const Center(child: Text('Tidak ada data untuk filter ini.'));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                    itemCount: filteredRecords.length,
                    itemBuilder: (context, index) {
                      final record = filteredRecords[index];
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
                          context.read<GlucoseCubit>().deleteGlucose(record.readingId!);
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
                            onTap: () => _navigateToAddEditPage(glucose: record),
                            child: IntrinsicHeight(
                              child: Row(
                                children: [
                                  Container(
                                    width: 100,
                                    color: const Color(0xFF0F67FE),
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
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
                                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
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
                                                  .format(record.readingTimestamp.toLocal()),
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
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Row(
                                      children: [
                                        Icon(_trendIcon(record.trendArrow), color: _trendColor(record.trendArrow)),
                                        const SizedBox(width: 4),
                                        Text(record.trendArrow ?? "stable", style: TextStyle(color: _trendColor(record.trendArrow), fontWeight: FontWeight.bold, fontSize: 12)),
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
                } else if (state is GlucoseError) {
                    return const Center(child: Text('Tidak ada data untuk ditampilkan.'));
                }
                return const Center(child: Text('Tidak ada data untuk ditampilkan.'));
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildFilterOption(label: '1D', filter: GlucoseFilter.day),
          _buildFilterOption(label: '1W', filter: GlucoseFilter.week),
          _buildFilterOption(label: '1M', filter: GlucoseFilter.month),
          _buildFilterOption(label: '1Y', filter: GlucoseFilter.year),
          _buildFilterOption(label: 'All', filter: GlucoseFilter.all),
        ],
      ),
    );
  }

  Widget _buildFilterOption({required String label, required GlucoseFilter filter}) {
    final bool isActive = _selectedFilter == filter;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedFilter = filter;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isActive ? Theme.of(context).colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.black54,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
