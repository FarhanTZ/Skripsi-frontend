import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:glupulse/features/sleep_log/domain/entities/sleep_log.dart';
import 'package:glupulse/features/sleep_log/presentation/cubit/sleep_log_cubit.dart';
import 'package:glupulse/features/sleep_log/presentation/pages/add_edit_sleep_log_page.dart';

class SleepLogListPage extends StatefulWidget {
  const SleepLogListPage({super.key});

  @override
  State<SleepLogListPage> createState() => _SleepLogListPageState();
}

class _SleepLogListPageState extends State<SleepLogListPage> {
  DateTime _selectedDate = DateTime.now(); // Controls month and year for the calendar view
  int? _selectedDay; // Null means all days in the month are selected

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now().day; // Initialize selected day to today's day
    _fetchSleepLogs();
  }

  Future<void> _fetchSleepLogs() async {
    context.read<SleepLogCubit>().getSleepLogs();
  }

  void _navigateToAddEditPage({SleepLog? sleepLog}) async {
    DateTime? initialDate;
    
    // Jika menambah baru (sleepLog == null) dan ada tanggal yang dipilih di kalender
    if (sleepLog == null && _selectedDay != null) {
      initialDate = DateTime(_selectedDate.year, _selectedDate.month, _selectedDay!);
    }

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddEditSleepLogPage(
          sleepLog: sleepLog,
          initialDate: initialDate, // Kirim tanggal yang dipilih
        ),
      ),
    );
    _fetchSleepLogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddEditPage(),
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        // Bungkus seluruh body dengan BlocConsumer agar Kalender juga bisa akses data
        child: BlocConsumer<SleepLogCubit, SleepLogState>(
          listener: (context, state) {
            if (state is SleepLogDeleted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sleep Log deleted successfully')),
              );
              _fetchSleepLogs();
            } else if (state is SleepLogError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            List<SleepLog> allLogs = [];
            if (state is SleepLogLoaded) {
              allLogs = state.sleepLogs;
            }

            return Column(
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
                        'Sleep Logs',
                        style: TextStyle(
                          fontSize: 20, 
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                _buildMonthYearPicker(), // Month/year picker
                const SizedBox(height: 20),
                
                // Calendar Grid (Sekarang menerima data logs untuk indikator biru)
                _buildCalendarGrid(allLogs), 
                
                const SizedBox(height: 10),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'History Sleep',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (state is SleepLogLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } 
                      
                      // Filter logs by selected month, year, and day
                      final filteredLogs = allLogs.where((log) {
                        bool matchesMonthYear = log.bedTime.year == _selectedDate.year &&
                                                log.bedTime.month == _selectedDate.month;
                        bool matchesDay = _selectedDay == null || log.bedTime.day == _selectedDay;
                        return matchesMonthYear && matchesDay;
                      }).toList();

                      if (filteredLogs.isEmpty && state is SleepLogLoaded) {
                        return Center(
                          child: Text(
                            _selectedDay == null
                              ? 'No sleep logs for ${DateFormat('MMMM yyyy').format(_selectedDate)}.'
                              : 'No logs on ${DateFormat('d MMM').format(DateTime(_selectedDate.year, _selectedDate.month, _selectedDay!))}.',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        );
                      } else if (state is! SleepLogLoaded && state is! SleepLogLoading) {
                         return const Center(child: Text('No data loaded'));
                      }

                      // Sort by date descending
                      final sortedLogs = List.from(filteredLogs)
                        ..sort((a, b) => b.bedTime.compareTo(a.bedTime));

                      return ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                        itemCount: sortedLogs.length,
                        itemBuilder: (context, index) {
                          final log = sortedLogs[index];
                          final duration = log.wakeTime.difference(log.bedTime);
                          final hours = duration.inHours;
                          final minutes = duration.inMinutes % 60;

                          return Dismissible(
                            key: Key(log.id!),
                            direction: DismissDirection.endToStart,
                            confirmDismiss: (direction) async {
                              return await showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Confirm Delete'),
                                  content: const Text('Are you sure you want to delete this sleep log?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(ctx).pop(false),
                                      child: const Text('No'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.of(ctx).pop(true),
                                      child: const Text('Yes'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            onDismissed: (direction) {
                              context.read<SleepLogCubit>().deleteSleepLog(log.id!);
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
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              elevation: 2,
                              color: Colors.white,
                              child: InkWell(
                                onTap: () => _navigateToAddEditPage(sleepLog: log),
                                borderRadius: BorderRadius.circular(15),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    children: [
                                      // Date Box
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          children: [
                                            Text(
                                              DateFormat('dd').format(log.bedTime),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Theme.of(context).colorScheme.primary,
                                              ),
                                            ),
                                            Text(
                                              DateFormat('MMM').format(log.bedTime),
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Theme.of(context).colorScheme.primary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      
                                      // Details
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.bedtime, size: 14, color: Colors.grey[600]),
                                                const SizedBox(width: 4),
                                                Text(
                                                  '${DateFormat('HH:mm').format(log.bedTime)} - ${DateFormat('HH:mm').format(log.wakeTime)}',
                                                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                                ),
                                                const Spacer(),
                                                // Quality Badge Small
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: _getQualityColor(log.qualityRating).withOpacity(0.1),
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                  child: Text(
                                                    'Quality: ${log.qualityRating ?? "-"}/5',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.bold,
                                                      color: _getQualityColor(log.qualityRating),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '${hours}h ${minutes}m Sleep',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold, 
                                                fontSize: 16,
                                                color: Theme.of(context).colorScheme.primary,
                                              ),
                                            ),
                                            if (log.notes != null && log.notes!.isNotEmpty)
                                              Text(
                                                log.notes!,
                                                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMonthYearPicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat('MMMM yyyy').format(_selectedDate),
            style: TextStyle(
              fontSize: 22, 
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ), 
          ),
          Row(
            mainAxisSize: MainAxisSize.min, // Ensures this inner row takes minimal space
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left, size: 30, color: Theme.of(context).colorScheme.primary),
                onPressed: () {
                  setState(() {
                    _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1);
                    _selectedDay = null; // Clear day selection when changing month
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.chevron_right, size: 30, color: Theme.of(context).colorScheme.primary),
                onPressed: () {
                  setState(() {
                    _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1);
                    _selectedDay = null; // Clear day selection when changing month
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  // Updated to accept logs for displaying indicators
  Widget _buildCalendarGrid(List<SleepLog> logs) {
    final daysInMonth = DateTime(_selectedDate.year, _selectedDate.month + 1, 0).day;
    final firstDayOfMonth = DateTime(_selectedDate.year, _selectedDate.month, 1);
    final startingWeekday = firstDayOfMonth.weekday; // 1 = Mon, 7 = Sun.
    final leadingEmptyDays = (startingWeekday == 7) ? 6 : startingWeekday - 1; 
    final firstDayOfPrevMonth = DateTime(_selectedDate.year, _selectedDate.month - 1, 1);
    final daysInPrevMonth = DateTime(firstDayOfPrevMonth.year, firstDayOfPrevMonth.month + 1, 0).day;
    final totalGridCells = (leadingEmptyDays + daysInMonth + 6) ~/ 7 * 7; 

    const selectedBlueColor = Color(0xFF0F67FE);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          // Headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                .map((day) => Text(
                      day,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: totalGridCells,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 0,
              crossAxisSpacing: 0,
            ),
            itemBuilder: (context, index) {
              final int dayOfMonth;
              final Color textColor;
              final bool isCurrentMonth;
              final bool selectable;

              if (index < leadingEmptyDays) {
                // Days from previous month
                dayOfMonth = daysInPrevMonth - leadingEmptyDays + index + 1;
                textColor = Colors.grey.shade400;
                isCurrentMonth = false;
                selectable = false;
              } else if (index >= leadingEmptyDays && index < leadingEmptyDays + daysInMonth) {
                // Days from current month
                dayOfMonth = index - leadingEmptyDays + 1;
                textColor = Theme.of(context).colorScheme.primary; // Changed to primary
                isCurrentMonth = true;
                selectable = true;
              } else {
                // Days from next month
                dayOfMonth = index - (leadingEmptyDays + daysInMonth) + 1;
                textColor = Colors.grey.shade400;
                isCurrentMonth = false;
                selectable = false;
              }


              
              final now = DateTime.now();
              final isToday = isCurrentMonth && now.year == _selectedDate.year && 
                              now.month == _selectedDate.month && 
                              now.day == dayOfMonth;

              // Check if date is in the future
              bool isFutureDate = false;
              if (isCurrentMonth) {
                final dateToCheck = DateTime(_selectedDate.year, _selectedDate.month, dayOfMonth);
                final todayStart = DateTime(now.year, now.month, now.day);
                if (dateToCheck.isAfter(todayStart)) {
                  isFutureDate = true;
                }
              }
              
              // Disable selection for future dates
              final bool finalSelectable = selectable && !isFutureDate;
              
              // Adjust text color for future dates
              final Color finalTextColor = isFutureDate ? Colors.grey.shade300 : textColor;


              final isSelected = finalSelectable && dayOfMonth == _selectedDay && isCurrentMonth;

              // Check if there is a log for this day
              bool hasLog = false;
              if (isCurrentMonth) {
                hasLog = logs.any((log) => 
                  log.bedTime.year == _selectedDate.year && 
                  log.bedTime.month == _selectedDate.month && 
                  log.bedTime.day == dayOfMonth
                );
              }

              return GestureDetector(
                onTap: finalSelectable ? () {
                  setState(() {
                    if (_selectedDay == dayOfMonth) {
                      _selectedDay = null; // Toggle selection
                    } else {
                      _selectedDay = dayOfMonth;
                    }
                  });
                } : null,
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? selectedBlueColor 
                        : (isToday 
                            ? selectedBlueColor.withOpacity(0.1) 
                            : (isCurrentMonth ? Colors.white : Colors.transparent)),
                    borderRadius: BorderRadius.circular(8),
                    border: isToday && !isSelected ? Border.all(color: selectedBlueColor, width: 1.5) : null,
                    boxShadow: isSelected ? [
                      BoxShadow(
                        color: selectedBlueColor.withOpacity(0.4),
                        blurRadius: 8,
                        spreadRadius: 2,
                        offset: const Offset(0, 2),
                      )
                    ] : null,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        '$dayOfMonth',
                        style: TextStyle(
                          color: isSelected 
                              ? Colors.white 
                              : finalTextColor, 
                          fontWeight: (isSelected || isToday) ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      // INDIKATOR TITIK BIRU (Blue Dot)
                      if (hasLog && !isSelected) // Don't show dot if selected (background is already blue)
                        Positioned(
                          bottom: 6,
                          child: Container(
                            width: 4,
                            height: 4,
                            decoration: const BoxDecoration(
                              color: Color(0xFF0F67FE), // Blue color
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      if (hasLog && isSelected) // Show white dot if background is blue
                        Positioned(
                          bottom: 6,
                          child: Container(
                            width: 4,
                            height: 4,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Color _getQualityColor(int? rating) {
    if (rating == null) return Colors.grey;
    if (rating >= 4) return Colors.green;
    if (rating == 3) return Colors.orange;
    return Colors.red;
  }
}
