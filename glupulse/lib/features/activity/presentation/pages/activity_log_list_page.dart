import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glupulse/features/activity/domain/entities/activity_log.dart';
import 'package:glupulse/features/activity/domain/entities/activity_type.dart';
import 'package:glupulse/features/activity/presentation/cubit/activity_cubit.dart';
import 'package:glupulse/features/activity/presentation/cubit/activity_state.dart';
import 'package:glupulse/features/activity/presentation/pages/active_session_page.dart'; 
import 'package:glupulse/features/activity/presentation/pages/input_activity_page.dart';
import 'package:glupulse/features/activity/presentation/pages/activity_history_page.dart'; // Import History Page
import 'package:glupulse/injection_container.dart';
import 'package:intl/intl.dart';

class ActivityLogListPage extends StatelessWidget {
  final ActivityType activityType;

  const ActivityLogListPage({super.key, required this.activityType});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ActivityCubit>()
        ..fetchActivityLogs(filterCode: activityType.activityCode),
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F5F9),
        appBar: null, // Disable default AppBar
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => InputActivityPage(activityType: activityType),
                  ),
                );
                if (context.mounted) {
                  context.read<ActivityCubit>().fetchActivityLogs(
                      filterCode: activityType.activityCode);
                }
              },
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(Icons.add, color: Colors.white),
            );
          }
        ),
        body: SafeArea(
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
                    Text(
                      activityType.displayName,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              
              // --- Konten Utama (Expanded) ---
              Expanded(
                child: BlocConsumer<ActivityCubit, ActivityState>(
                  listener: (context, state) {
                    if (state is ActivityOperationSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                      context.read<ActivityCubit>().fetchActivityLogs(
                          filterCode: activityType.activityCode);
                    } else if (state is ActivityError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is ActivityLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ActivityLogsLoaded) {
                      if (state.activityLogs.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.directions_run, size: 64, color: Colors.grey[300]),
                              const SizedBox(height: 16),
                              const Text('No activity logs found.\nStart moving!', textAlign: TextAlign.center),
                            ],
                          ),
                        );
                      }
                      
                      // Sort by date descending
                      final allLogs = List<ActivityLog>.from(state.activityLogs)
                        ..sort((a, b) => b.activityTimestamp.compareTo(a.activityTimestamp));

                      final latestLog = allLogs.isNotEmpty ? allLogs.first : null;
                      
                      // Limit to 5 for this view
                      final displayLogs = allLogs.take(5).toList();

                      return ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                        itemCount: displayLogs.length + 1, // +1 for the header
                        itemBuilder: (context, index) {
                          // --- HEADER SECTION (Index 0) ---
                          if (index == 0) {
                            if (latestLog == null) return const SizedBox.shrink();
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24.0),
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
                                              text: latestLog.durationMinutes.toString(),
                                              style: const TextStyle(fontSize: 75),
                                            ),
                                            const TextSpan(
                                              text: ' min',
                                              style: TextStyle(
                                                  fontSize: 20, fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Icon(
                                        Icons.timer_outlined,
                                        color: _getIntensityColor(latestLog.intensity),
                                        size: 40,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Last Session (${DateFormat('d MMM, HH:mm').format(latestLog.activityTimestamp.toLocal())})',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  
                                  // --- CONTINUE SESSION BUTTON ---
                                  if (latestLog.activityTimestamp.day == DateTime.now().day &&
                                      latestLog.activityTimestamp.month == DateTime.now().month &&
                                      latestLog.activityTimestamp.year == DateTime.now().year) ...[
                                    const SizedBox(height: 16),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ActiveSessionPage(
                                              activityType: activityType,
                                              targetDurationMinutes: 0,
                                              resumeLog: latestLog,
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.add, size: 18),
                                      label: const Text('Lanjutkan Sesi Ini'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF0F67FE),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      ),
                                    ),
                                  ],

                                  const SizedBox(height: 24), // Spacing before list
                                  
                                  // --- History Header Row with See All ---
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Recent History',
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ActivityHistoryPage(activityType: activityType),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          'Lihat Semua',
                                          style: TextStyle(
                                            color: Theme.of(context).colorScheme.primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              ),
                            );
                          }

                          // --- LIST ITEMS (Index 1+) ---
                          final log = displayLogs[index - 1]; // Use displayLogs
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
                                  content: const Text('Are you sure you want to delete this activity log?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(ctx).pop(false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.of(ctx).pop(true),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            onDismissed: (direction) {
                              context.read<ActivityCubit>().deleteLog(log.activityId!);
                            },
                            child: Card(
                              margin: const EdgeInsets.only(bottom: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 3,
                              color: Colors.white,
                              shadowColor: Colors.black12,
                              child: InkWell(
                                onTap: () async {
                                  await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => InputActivityPage(
                                        activityType: activityType,
                                        activityLog: log,
                                      ),
                                    ),
                                  );
                                  if (context.mounted) {
                                    context.read<ActivityCubit>().fetchActivityLogs(
                                        filterCode: activityType.activityCode);
                                  }
                                },
                                borderRadius: BorderRadius.circular(20),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      // Row 1: Header (Date & Intensity Badge)
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.calendar_today_outlined,
                                                size: 14,
                                                color: Colors.grey[600],
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                DateFormat('EEEE, d MMM yyyy • HH:mm').format(log.activityTimestamp.toLocal()),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13,
                                                  color: Colors.grey[800],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: _getIntensityColor(log.intensity).withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(
                                                color: _getIntensityColor(log.intensity).withOpacity(0.3),
                                                width: 1
                                              ),
                                            ),
                                            child: Text(
                                              log.intensity.toUpperCase(),
                                              style: TextStyle(
                                                color: _getIntensityColor(log.intensity),
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      
                                      const Padding(
                                        padding: EdgeInsets.symmetric(vertical: 12.0),
                                        child: Divider(height: 1, thickness: 0.5),
                                      ),

                                      // Row 2: Main Metrics (Duration, Steps, Carbs)
                                      Row(
                                        children: [
                                          // Duration (Always there)
                                          Expanded(
                                            child: _buildMetricItem(
                                              context,
                                              Icons.timer_outlined,
                                              '${log.durationMinutes}',
                                              'Minutes',
                                              Theme.of(context).colorScheme.primary,
                                            ),
                                          ),
                                          // Vertical Divider
                                          Container(height: 30, width: 1, color: Colors.grey[200]),
                                          
                                          // Steps (If available)
                                          if (log.stepsCount != null && log.stepsCount! > 0) ...[
                                            Expanded(
                                              child: _buildMetricItem(
                                                context,
                                                Icons.directions_walk,
                                                '${log.stepsCount}',
                                                'Steps',
                                                Colors.orange,
                                              ),
                                            ),
                                            Container(height: 30, width: 1, color: Colors.grey[200]),
                                          ],

                                          // Carbs or Water (Priority to Carbs, then Water)
                                          if (log.preActivityCarbs != null && log.preActivityCarbs! > 0) ...[
                                            Expanded(
                                              child: _buildMetricItem(
                                                context,
                                                Icons.restaurant_menu,
                                                '${log.preActivityCarbs}g',
                                                'Carbs',
                                                Colors.blue,
                                              ),
                                            ),
                                          ] else if (log.waterIntakeMl != null && log.waterIntakeMl! > 0) ...[
                                             Expanded(
                                              child: _buildMetricItem(
                                                context,
                                                Icons.local_drink,
                                                '${log.waterIntakeMl}ml',
                                                'Water',
                                                Colors.blue,
                                              ),
                                            ),
                                          ] else ...[
                                             // Empty filler if no extra metrics
                                             const Spacer(), 
                                          ]
                                        ],
                                      ),

                                      // Row 3: Notes (Optional)
                                      if (log.notes != null && log.notes!.isNotEmpty) ...[
                                        const SizedBox(height: 12),
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[50],
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Icon(Icons.notes, size: 14, color: Colors.grey[400]),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  log.notes!,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 12,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
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
              ), // Expanded
            ], // Column children
          ), // Column
        ), // SafeArea
      ), // Scaffold
    ); // BlocProvider
  }

  Widget _buildMetricItem(BuildContext context, IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 10,
          ),
        ),
      ],
    );
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
}