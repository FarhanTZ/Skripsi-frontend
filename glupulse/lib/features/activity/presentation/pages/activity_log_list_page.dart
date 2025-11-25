import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glupulse/features/activity/domain/entities/activity_log.dart';
import 'package:glupulse/features/activity/domain/entities/activity_type.dart';
import 'package:glupulse/features/activity/presentation/cubit/activity_cubit.dart';
import 'package:glupulse/features/activity/presentation/cubit/activity_state.dart';
import 'package:glupulse/features/activity/presentation/pages/input_activity_page.dart';
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
        appBar: AppBar(
          title: Text(
            activityType.displayName,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          iconTheme: const IconThemeData(color: Colors.white),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
        ),
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
        body: BlocConsumer<ActivityCubit, ActivityState>(
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
                return const Center(
                  child: Text('No activity logs found. Start moving!'),
                );
              }
              
              // Sort by date descending
              final logs = List<ActivityLog>.from(state.activityLogs)
                ..sort((a, b) => b.activityTimestamp.compareTo(a.activityTimestamp));

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  final log = logs[index];
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
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 2,
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
                        borderRadius: BorderRadius.circular(15),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.history,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      DateFormat('EEE, dd MMM yyyy • HH:mm').format(log.activityTimestamp),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${log.durationMinutes} mins • ${log.intensity.toUpperCase()}',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 13,
                                      ),
                                    ),
                                    if (log.notes != null && log.notes!.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        log.notes!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.grey[500],
                                          fontStyle: FontStyle.italic,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              Icon(Icons.chevron_right, color: Colors.grey[400]),
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
    );
  }
}
