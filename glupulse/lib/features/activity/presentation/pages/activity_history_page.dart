import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glupulse/features/activity/domain/entities/activity_log.dart';
import 'package:glupulse/features/activity/domain/entities/activity_type.dart';
import 'package:glupulse/features/activity/presentation/cubit/activity_cubit.dart';
import 'package:glupulse/features/activity/presentation/cubit/activity_state.dart';
import 'package:glupulse/features/activity/presentation/pages/input_activity_page.dart';
import 'package:glupulse/injection_container.dart';
import 'package:intl/intl.dart';

class ActivityHistoryPage extends StatefulWidget {
  final ActivityType activityType;

  const ActivityHistoryPage({super.key, required this.activityType});

  @override
  State<ActivityHistoryPage> createState() => _ActivityHistoryPageState();
}

class _ActivityHistoryPageState extends State<ActivityHistoryPage> {
  DateTime _selectedDate = DateTime.now(); // Filter Bulan & Tahun
  bool _isMonthFilterActive = true; // Toggle state for Month Filter
  final Set<String> _selectedIntensities = {}; // Filter Intensitas

  @override
  void initState() {
    super.initState();
    // Fetch logs specific to this activity type
    context.read<ActivityCubit>().fetchActivityLogs(filterCode: widget.activityType.activityCode);
  }

  void _toggleIntensityFilter(String intensity) {
    setState(() {
      if (_selectedIntensities.contains(intensity)) {
        _selectedIntensities.remove(intensity);
      } else {
        _selectedIntensities.add(intensity);
      }
    });
  }

  Color _getIntensityColor(String intensity) {
    switch (intensity.toLowerCase()) {
      case 'low':
        return Colors.green;
      case 'moderate':
        return Colors.orange;
      case 'high':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      appBar: AppBar(
        title: Text(
          '${widget.activityType.displayName} History',
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          // --- Filter Bulan & Tahun (From GlucoseListPage) ---
          _buildDateSelector(),
          
          const SizedBox(height: 8),
          
          // --- Filter Intensitas (From ActivityTypeListPage) ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                _buildFilterButton('LOW', Colors.green),
                const SizedBox(width: 8),
                _buildFilterButton('MODERATE', Colors.orange),
                const SizedBox(width: 8),
                _buildFilterButton('HIGH', Colors.red),
              ],
            ),
          ),

          Expanded(
            child: BlocBuilder<ActivityCubit, ActivityState>(
              builder: (context, state) {
                if (state is ActivityLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ActivityLogsLoaded) {
                  // --- LOGIKA FILTER ---
                  List<ActivityLog> filteredLogs = state.activityLogs.where((log) {
                    // 1. Filter by Activity Code (Already done by fetch, but good to be safe)
                    if (log.activityCode != widget.activityType.activityCode) return false;

                    // 2. Filter by Month & Year (Only if active)
                    bool matchesDate = true;
                    if (_isMonthFilterActive) {
                        matchesDate = log.activityTimestamp.month == _selectedDate.month &&
                                      log.activityTimestamp.year == _selectedDate.year;
                    }
                    
                    // 3. Filter by Intensity
                    final matchesIntensity = _selectedIntensities.isEmpty || 
                                             _selectedIntensities.contains(log.intensity.toUpperCase());

                    return matchesDate && matchesIntensity;
                  }).toList();

                  // Sort descending
                  filteredLogs.sort((a, b) => b.activityTimestamp.compareTo(a.activityTimestamp));

                  if (filteredLogs.isEmpty) {
                    // Show clearer message if filter is active
                    if (_isMonthFilterActive) {
                       return Center(
                        child: Text(
                          'No logs found for ${DateFormat('MMMM yyyy').format(_selectedDate)}.',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      );
                    }
                    return Center(
                      child: Text(
                        'No logs found.',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredLogs.length,
                    itemBuilder: (context, index) {
                      final log = filteredLogs[index];
                      return Dismissible(
                        key: Key(log.activityId!),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Delete Log'),
                              content: const Text('Are you sure?'),
                              actions: [
                                TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
                                TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Delete')),
                              ],
                            ),
                          );
                        },
                        onDismissed: (direction) {
                          context.read<ActivityCubit>().deleteLog(log.activityId!);
                        },
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          elevation: 2,
                          color: Colors.white,
                          child: InkWell(
                            onTap: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => InputActivityPage(
                                    activityType: widget.activityType,
                                    activityLog: log,
                                  ),
                                ),
                              );
                              if (context.mounted) {
                                context.read<ActivityCubit>().fetchActivityLogs(
                                    filterCode: widget.activityType.activityCode);
                              }
                            },
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
                                          DateFormat('dd').format(log.activityTimestamp),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Theme.of(context).colorScheme.primary,
                                          ),
                                        ),
                                        Text(
                                          DateFormat('MMM').format(log.activityTimestamp),
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
                                            Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                                            const SizedBox(width: 4),
                                            Text(
                                              DateFormat('HH:mm').format(log.activityTimestamp),
                                              style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                            ),
                                            const Spacer(),
                                            // Intensity Badge Small
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: _getIntensityColor(log.intensity).withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                log.intensity.toUpperCase(),
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: _getIntensityColor(log.intensity),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${log.durationMinutes} Minutes',
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                        ),
                                        if (log.stepsCount != null && log.stepsCount! > 0)
                                          Text(
                                            '${log.stepsCount} steps',
                                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
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
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  setState(() {
                    _selectedDate = DateTime(_selectedDate.year - 1, _selectedDate.month);
                    // Keeping filter active/inactive state same when changing year? 
                    // Usually user wants to see specific year data, so maybe keep active or activate it.
                    // Let's keep it as is.
                  });
                },
              ),
              Text(
                DateFormat('yyyy').format(_selectedDate),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  setState(() {
                    _selectedDate = DateTime(_selectedDate.year + 1, _selectedDate.month);
                  });
                },
              ),
            ],
          ),
        ),
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 12,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            itemBuilder: (context, index) {
              final monthIndex = index + 1;
              // Highlight only if filter is active AND matches month
              final isSelected = _isMonthFilterActive && monthIndex == _selectedDate.month;
              final date = DateTime(_selectedDate.year, monthIndex);
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      // Toggle OFF if tapping same selected month
                      _isMonthFilterActive = false;
                    } else {
                      // Select new month and Activate filter
                      _selectedDate = DateTime(_selectedDate.year, monthIndex);
                      _isMonthFilterActive = true;
                    }
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: isSelected ? null : Border.all(color: Colors.grey.shade300),
                  ),
                  child: Center(
                    child: Text(
                      DateFormat('MMM').format(date),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey.shade700,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterButton(String intensity, Color activeColor) {
    final bool isActive = _selectedIntensities.contains(intensity);
    return Expanded(
      child: GestureDetector(
        onTap: () => _toggleIntensityFilter(intensity),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? activeColor : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: isActive ? null : Border.all(color: Colors.grey.shade300),
            boxShadow: isActive 
              ? [BoxShadow(color: activeColor.withOpacity(0.4), blurRadius: 4, offset: const Offset(0, 2))]
              : null,
          ),
          child: Text(
            intensity,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.grey.shade600,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ),
      ),
    );
  }
}