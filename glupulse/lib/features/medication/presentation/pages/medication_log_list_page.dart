import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:glupulse/features/medication/domain/entities/medication_log.dart';
import 'package:glupulse/features/medication/presentation/cubit/medication_cubit.dart'; // Added Import
import 'package:glupulse/features/medication/presentation/cubit/medication_log_cubit.dart';
import 'package:glupulse/features/medication/presentation/pages/add_edit_medication_log_page.dart';
import 'package:glupulse/features/medication/presentation/pages/add_edit_medication_page.dart'; // Added Import for AddEditMedicationPage

class MedicationLogListPage extends StatefulWidget {
  const MedicationLogListPage({super.key});

  @override
  State<MedicationLogListPage> createState() => _MedicationLogListPageState();
}

class _MedicationLogListPageState extends State<MedicationLogListPage> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchLogs();
    // Load data obat langsung saat halaman dibuka agar sheet bawah siap
    context.read<MedicationCubit>().fetchMedications();
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Widget _buildDateSelector(List<MedicationLog> logs) {
    // Generate 30 hari terakhir + hari ini
    final dates = List.generate(30, (index) {
      return DateTime.now().subtract(Duration(days: index));
    }).reversed.toList();

    return SizedBox(
      height: 100, // Menambah tinggi agar kartu lebih panjang ke bawah
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 12), // Tambah padding bawah untuk ruang shadow
        // Agar otomatis scroll ke tanggal terakhir (hari ini)
        controller: ScrollController(initialScrollOffset: 60.0 * 28), 
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected = _isSameDay(date, _selectedDate);
          final hasLog = logs.any((log) => _isSameDay(log.timestamp, date));
          
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setStateInner) {
              bool _isCurrentlyPressed = false; // State lokal untuk efek tekan

              return GestureDetector(
                onTapDown: (_) {
                  setStateInner(() => _isCurrentlyPressed = true);
                },
                onTapUp: (_) {
                  setStateInner(() => _isCurrentlyPressed = false);
                  this.setState(() => _selectedDate = date); // Perbarui tanggal terpilih di parent state
                },
                onTapCancel: () {
                  setStateInner(() => _isCurrentlyPressed = false);
                },
                onTap: () {
                  // Jika hanya ingin onTap, tapi kita sudah pakai onTapUp untuk perubahan state
                  // Biarkan kosong atau panggil logika utama jika diperlukan
                },
                child: Container(
                  width: 60,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF0F67FE) : Colors.white, // Warna background untuk kartu yang terpilih
                    borderRadius: BorderRadius.circular(12),
                    border: isSelected 
                      ? null 
                      : Border.all(color: Colors.grey.shade300),
                    boxShadow: [ // Shadow konsisten untuk semua kartu
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1), // Sedikit lebih gelap agar terlihat
                        blurRadius: 6, // Sedikit lebih blur
                        offset: const Offset(0, 3), // Sedikit lebih offset
                      ),
                      if (_isCurrentlyPressed) // Shadow biru saat ditekan
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.6), // Warna biru untuk highlight
                          blurRadius: 10,
                          spreadRadius: 2, // Menyebar sedikit
                          offset: const Offset(0, 4),
                        ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('MMM').format(date), // Bulan (Jan, Feb)
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Colors.white70 : Colors.grey,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('d').format(date), // Tanggal (28)
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                      if (hasLog) ...[
                         const SizedBox(height: 4),
                         Container(
                                                  width: 6, // Lebar untuk kotak
                                                  height: 6, // Tinggi untuk kotak
                                                  decoration: BoxDecoration(
                                                    color: isSelected ? Colors.white : Colors.grey.shade400, // Putih jika dipilih, abu jika tidak
                                                    borderRadius: BorderRadius.circular(2), // Sudut melengkung
                                                  )                         )
                      ] else ...[
                         const SizedBox(height: 10), // Spacer agar tinggi teks tetap sejajar
                      ]
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _fetchLogs() async {
    context.read<MedicationLogCubit>().fetchMedicationLogs();
  }

  void _navigateToAddEditLog({MedicationLog? log, int? selectedMedicationId}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddEditMedicationLogPage(
          log: log,
          selectedMedicationId: selectedMedicationId,
        )
      ),
    );
    _fetchLogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      // FAB dihapus karena diganti Bottom Sheet yang bisa ditarik
      body: Stack(
        children: [
          // --- LAYER 1: KONTEN UTAMA (LOG LIST) ---
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.primary),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      Text(
                        'Medication Logs',
                        style: TextStyle(
                          fontSize: 20, 
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),

                    ],
                  ),
                ),
                
                // Date Selector (Filter Tanggal)
                BlocBuilder<MedicationLogCubit, MedicationLogState>(
                  builder: (context, state) {
                    return _buildDateSelector(state is MedicationLogLoaded ? state.logs : []);
                  },
                ),
                
                const SizedBox(height: 20),

                // List Log
                Expanded(
                  child: BlocConsumer<MedicationLogCubit, MedicationLogState>(
                    listener: (context, state) {
                       if (state is MedicationLogSuccess) {
                        _fetchLogs();
                      }
                    },
                    builder: (context, state) {
                      if (state is MedicationLogLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is MedicationLogLoaded) {
                        // FILTER LOGS BERDASARKAN TANGGAL
                        final filteredLogs = state.logs.where((log) {
                          return _isSameDay(log.timestamp, _selectedDate);
                        }).toList();

                        if (filteredLogs.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.history, size: 64, color: Colors.grey.shade300),
                                const SizedBox(height: 16),
                                Text(
                                  'Tidak ada catatan obat\npada tanggal ${DateFormat('d MMMM').format(_selectedDate)}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey.shade500),
                                ),
                              ],
                            ),
                          );
                        }

                        final sortedLogs = List.from(filteredLogs)
                          ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

                        return ListView.builder(
                          // Tambahkan padding bawah agar item terakhir tidak tertutup sheet
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 120), 
                          itemCount: sortedLogs.length,
                          itemBuilder: (context, index) {
                            final log = sortedLogs[index];
                            final isLast = index == sortedLogs.length - 1;
                            
                            // Logika untuk menyembunyikan jam yang sama
                            bool showTime = true;
                            if (index > 0) {
                              final prevLog = sortedLogs[index - 1];
                              final currentLogTime = DateFormat('hh:mm a').format(log.timestamp.toLocal());
                              final prevLogTime = DateFormat('hh:mm a').format(prevLog.timestamp.toLocal());
                              if (currentLogTime == prevLogTime) {
                                showTime = false;
                              }
                            }

                            return IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 1. KOLOM TIMELINE (Kotak & Garis) - DI KIRI
                                  SizedBox(
                                    width: 20, // Lebar area timeline kiri
                                    child: Column(
                                      children: [
                                        // Kotak Indikator (Hanya muncul jika jam ditampilkan/beda dari sebelumnya)
                                        if (showTime)
                                          Container(
                                            margin: const EdgeInsets.only(top: 4),
                                            width: 12,
                                            height: 12,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).colorScheme.primary,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                          ),
                                        // Garis Vertikal
                                        Expanded(
                                          child: Container(
                                            width: 2,
                                            // Jika showTime false, garis harus full dari atas (karena nyambung dari log jam sama sebelumnya)
                                            // Jika showTime true, garis mulai dari bawah kotak
                                            margin: EdgeInsets.only(top: showTime ? 0 : 0), 
                                            color: isLast 
                                              ? Colors.transparent 
                                              : Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // 2. KOLOM KONTEN (JAM & KARTU) - DI KANAN
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // --- BARIS JAM (Header) ---
                                        if (showTime)
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8, bottom: 8),
                                            child: Text(
                                              DateFormat('hh:mm a').format(log.timestamp.toLocal()),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Theme.of(context).colorScheme.primary
                                              ),
                                            ),
                                          ),

                                        // --- KARTU OBAT ---
                                        Padding(
                                          // Padding kiri agar tidak nempel garis, padding bawah antar item
                                          padding: const EdgeInsets.only(left: 12, bottom: 24), 
                                          child: Dismissible(
                                            key: Key(log.id!),
                                            direction: DismissDirection.endToStart,
                                            confirmDismiss: (_) async {
                                               return await showDialog(
                                                context: context,
                                                builder: (ctx) => AlertDialog(
                                                  title: const Text('Hapus Log'),
                                                  content: const Text('Hapus catatan obat ini?'),
                                                  actions: [
                                                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Tidak')),
                                                    TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Ya')),
                                                  ],
                                                ),
                                              );
                                            },
                                            onDismissed: (_) {
                                              context.read<MedicationLogCubit>().removeMedicationLog(log.id!);
                                            },
                                            background: Container(
                                              alignment: Alignment.centerRight,
                                              padding: const EdgeInsets.only(right: 20),
                                              decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(16)),
                                              child: const Icon(Icons.delete, color: Colors.white),
                                            ),
                                                                                        child: Card(
                                                                                          margin: EdgeInsets.zero, 
                                                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                                                                          elevation: 2,
                                                                                          color: Colors.white,
                                                                                          child: InkWell(
                                                                                            onTap: () => _navigateToAddEditLog(log: log),
                                                                                            borderRadius: BorderRadius.circular(16),
                                                                                            child: Row(
                                                                                              children: [
                                                                                                // --- IKON OBAT (KIRI) ---
                                                                                                Container(
                                                                                                  width: 80, // Lebar persegi
                                                                                                  height: 80, // Tinggi persegi
                                                                                                  margin: const EdgeInsets.all(12), // Jarak dari tepi kartu
                                                                                                  decoration: BoxDecoration(
                                                                                                    color: Colors.grey.shade200,
                                                                                                    borderRadius: BorderRadius.circular(16), // Sudut melengkung
                                                                                                  ),
                                                                                                  child: Center(
                                                                                                    child: Icon(
                                                                                                      Icons.medication_liquid,
                                                                                                      color: Colors.grey.shade700,
                                                                                                      size: 40,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                            
                                                                                                // --- DETAIL OBAT (KANAN) ---
                                                                                                Expanded(
                                                                                                  child: Padding(
                                                                                                    padding: const EdgeInsets.only(right: 16, top: 12, bottom: 12),
                                                                                                    child: Column(
                                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                                      children: [
                                                                                                        Text(
                                                                                                          log.medicationName ?? 'Obat #${log.medicationId}',
                                                                                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                                                                          maxLines: 1,
                                                                                                          overflow: TextOverflow.ellipsis,
                                                                                                        ),
                                                                                                        const SizedBox(height: 8),
                                                                                                        Row(
                                                                                                          children: [
                                                                                                            Text(
                                                                                                              '${log.doseAmount} Unit(s)',
                                                                                                              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                                                                                                            ),
                                                                                                            const SizedBox(width: 8),
                                                                                                            Flexible(
                                                                                                              child: Container(
                                                                                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                                                                                decoration: BoxDecoration(
                                                                                                                  color: Colors.blue.shade50,
                                                                                                                  borderRadius: BorderRadius.circular(4)
                                                                                                                ),
                                                                                                                child: Text(
                                                                                                                  log.reason.replaceAll('_', ' '),
                                                                                                                  style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.primary),
                                                                                                                  maxLines: 1,
                                                                                                                  overflow: TextOverflow.ellipsis,
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ],
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
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                      return const Center(child: Text('Something went wrong'));
                    },
                  ),
                ),
              ],
            ),
          ),

          // --- LAYER 2: PERSISTENT BOTTOM SHEET (PILIH OBAT) ---
          DraggableScrollableSheet(
            initialChildSize: 0.08, // Tinggi awal (mengintip)
            minChildSize: 0.08,    // Tinggi minimal saat dicollapse
            maxChildSize: 0.75,    // Tinggi maksimal saat ditarik
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // --- HEADER SHEET (Hanya Title & Icon) ---
                    SingleChildScrollView(
                      controller: scrollController, 
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        children: [
                          const SizedBox(height: 8), // Small space for visual breathing
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.keyboard_arrow_up, color: Theme.of(context).colorScheme.primary), // Icon di atas
                              const SizedBox(height: 4), // Jarak antara icon dan teks
                              Text(
                                'Catat Obat Baru',
                                style: TextStyle(
                                  fontSize: 16, 
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8), // Small space below title
                        ],
                      ),
                    ),

                    // --- LIST OBAT ---
                    Expanded(
                      child: BlocBuilder<MedicationCubit, MedicationState>(
                        builder: (context, state) {
                          if (state is MedicationLoading) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (state is MedicationLoaded) {
                            final meds = state.medications;
                            


                            return ListView.builder(
                              controller: scrollController, // PENTING: Sambungkan controller agar bisa discroll & didrag
                              itemCount: meds.length + 1,
                              padding: const EdgeInsets.only(top: 0, bottom: 20),
                              itemBuilder: (context, index) {
                                if (index == meds.length) {
                                  // Item terakhir: Tambah Obat Baru
                                  // Item terakhir: Tambah Obat Baru
                                  return InkWell(
                                    onTap: () async {
                                      await Navigator.of(context).push(
                                        MaterialPageRoute(builder: (_) => const AddEditMedicationPage())
                                      );
                                      if (context.mounted) context.read<MedicationCubit>().fetchMedications();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF0F67FE), // Keep blue background
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(Icons.add, color: Colors.white),
                                          ),
                                          const SizedBox(width: 12),
                                          const Text(
                                            'Tambahkan Obat Baru',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }

                                final med = meds[index];
                                return ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                                  leading: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
                                      shape: BoxShape.circle
                                    ),
                                    child: Icon(Icons.medication_liquid, color: Theme.of(context).colorScheme.primary),
                                  ),
                                  title: Text(med.displayName, style: const TextStyle(fontWeight: FontWeight.w600)),
                                  subtitle: Text(med.defaultDoseUnit ?? med.medicationType, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Tombol Edit Obat
                                      IconButton(
                                        icon: Icon(Icons.edit_outlined, color: Theme.of(context).colorScheme.primary),
                                        tooltip: 'Edit Obat',
                                        onPressed: () async {
                                          await Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) => AddEditMedicationPage(medication: med),
                                            )
                                          );
                                          if (context.mounted) {
                                            context.read<MedicationCubit>().fetchMedications();
                                          }
                                        },
                                      ),
                                      // Tombol Hapus
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline, color: Colors.grey),
                                        tooltip: 'Hapus Obat',
                                        onPressed: () async {
                                          final confirm = await showDialog<bool>(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title: const Text('Delete Medication?'),
                                              content: Text('Are you sure you want to delete "${med.displayName}"?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(ctx, false),
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () => Navigator.pop(ctx, true),
                                                  child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                                ),
                                              ],
                                            ),
                                          );

                                          if (confirm == true && context.mounted) {
                                            context.read<MedicationCubit>().deleteMedication(med.id!);
                                            await Future.delayed(const Duration(milliseconds: 500)); 
                                            if (context.mounted) {
                                              context.read<MedicationCubit>().fetchMedications();
                                            }
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  // Tap Kartu: Catat Log Penggunaan
                                  onTap: () => _navigateToAddEditLog(selectedMedicationId: med.id),
                                );
                              },
                            );
                          }
                          return ListView(
                            controller: scrollController,
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                            children: [
                              const Text(
                                'Belum ada Obat, Silakan Tambahkan Obat', 
                                textAlign: TextAlign.center
                              ),
                              const SizedBox(height: 20),
                              InkWell(
                                onTap: () async {
                                  await Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_) => const AddEditMedicationPage())
                                  );
                                  if (context.mounted) context.read<MedicationCubit>().fetchMedications();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF0F67FE), // Keep blue background
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.add, color: Colors.white),
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        'Tambahkan Obat Baru',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
