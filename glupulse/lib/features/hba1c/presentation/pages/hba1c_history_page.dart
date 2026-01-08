import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glupulse/features/hba1c/domain/entities/hba1c.dart';
import 'package:glupulse/features/hba1c/presentation/cubit/hba1c_cubit.dart';
import 'package:glupulse/features/hba1c/presentation/pages/add_edit_hba1c_page.dart';
import 'package:intl/intl.dart';

// Enum untuk mengelola state filter
enum Hba1cFilter { day, week, month, year, all }

class Hba1cHistoryPage extends StatefulWidget {
  const Hba1cHistoryPage({super.key});

  @override
  State<Hba1cHistoryPage> createState() => _Hba1cHistoryPageState();
}

class _Hba1cHistoryPageState extends State<Hba1cHistoryPage> {
  // State untuk melacak filter yang sedang aktif, default-nya 'all'
  Hba1cFilter _selectedFilter = Hba1cFilter.all;

  @override
  void initState() {
    super.initState();
    _fetchHba1cRecords();
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

  Color _trendColor(String? trend) {
    switch (trend) {
      case "improving":
        return Colors.green;
      case "worsening":
        return Colors.red;
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
      default:
        return Icons.horizontal_rule;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9), // Menyamakan background dengan halaman list
      appBar: AppBar(
        toolbarHeight: 80,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        title: const Text(
          'Riwayat HbA1c Lengkap',
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
            child: BlocConsumer<Hba1cCubit, Hba1cState>(
              listener: (context, state) {
                if (state is Hba1cDeleted) {
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
                      child: Text('Belum ada data HbA1c.'),
                    );
                  }

                  // --- LOGIKA PEMFILTERAN DATA ---
                  final now = DateTime.now();
                  final List<Hba1c> filteredRecords;

                  switch (_selectedFilter) {
                    case Hba1cFilter.day:
                      // Filter data yang tanggal tesnya sama dengan hari ini
                      filteredRecords = state.hba1cRecords.where((h) {
                        return h.testDate.year == now.year &&
                            h.testDate.month == now.month &&
                            h.testDate.day == now.day;
                      }).toList();
                      break;
                    case Hba1cFilter.week:
                      // Filter data dalam 7 hari terakhir
                      final oneWeekAgo = now.subtract(const Duration(days: 7));
                      filteredRecords = state.hba1cRecords
                          .where((h) => h.testDate.isAfter(oneWeekAgo))
                          .toList();
                      break;
                    case Hba1cFilter.month:
                      // Filter data dalam 30 hari terakhir
                      final oneMonthAgo = now.subtract(const Duration(days: 30));
                      filteredRecords = state.hba1cRecords
                          .where((h) => h.testDate.isAfter(oneMonthAgo))
                          .toList();
                      break;
                    case Hba1cFilter.year:
                      // Filter data dalam 365 hari terakhir
                      final oneYearAgo = now.subtract(const Duration(days: 365));
                      filteredRecords = state.hba1cRecords
                          .where((h) => h.testDate.isAfter(oneYearAgo))
                          .toList();
                      break;
                    case Hba1cFilter.all:
                    default:
                      // Tampilkan semua data
                      filteredRecords = state.hba1cRecords;
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                    itemCount: filteredRecords.length,
                    itemBuilder: (context, index) {
                      final h = filteredRecords[index];
                      return Dismissible(
                        key: Key(h.id!),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
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
                                  Container(
                                    color: const Color(0xFF0F67FE),
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                    child: Center(child: Text("${h.hba1cPercentage}%", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white))),
                                  ),
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
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Row(
                                      children: [
                                        Icon(_trendIcon(h.trend), color: _trendColor(h.trend)),
                                        const SizedBox(width: 4),
                                        Text(h.trend ?? "stable", style: TextStyle(color: _trendColor(h.trend), fontWeight: FontWeight.bold)),
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
                return const Center(child: Text('Terjadi kesalahan'));
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget untuk membangun baris filter
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
          _buildFilterOption(label: '1D', filter: Hba1cFilter.day),
          _buildFilterOption(label: '1W', filter: Hba1cFilter.week),
          _buildFilterOption(label: '1M', filter: Hba1cFilter.month),
          _buildFilterOption(label: '1Y', filter: Hba1cFilter.year),
          _buildFilterOption(label: 'All', filter: Hba1cFilter.all),
        ],
      ),
    );
  }

  // Helper widget untuk membuat setiap tombol filter
  Widget _buildFilterOption({required String label, required Hba1cFilter filter}) {
    final bool isActive = _selectedFilter == filter;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedFilter = filter;
          });
          // Tidak perlu memanggil fungsi filter di sini, karena UI akan
          // otomatis di-rebuild oleh setState dan logika filter ada di dalam builder.
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
