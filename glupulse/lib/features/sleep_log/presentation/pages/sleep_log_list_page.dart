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
  @override
  void initState() {
    super.initState();
    _fetchSleepLogs();
  }

  Future<void> _fetchSleepLogs() async {
    context.read<SleepLogCubit>().getSleepLogs();
  }

  void _navigateToAddEditPage({SleepLog? sleepLog}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddEditSleepLogPage(sleepLog: sleepLog),
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
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const Text(
                    'Sleep Logs',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
             // Decoration Line
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 10,
                  width: MediaQuery.of(context).size.width / 2.2,
                  decoration: const BoxDecoration(
                      color: Color(0xFF0F67FE),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10), bottomRight: Radius.circular(10))),
                ),
              ),
            ),

            // List
            Expanded(
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
                  if (state is SleepLogLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is SleepLogLoaded) {
                    if (state.sleepLogs.isEmpty) {
                      return const Center(
                        child: Text('No sleep logs found. Add one!'),
                      );
                    }

                    // Sort by date descending
                    final sortedLogs = List.from(state.sleepLogs)
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
                            margin: const EdgeInsets.only(bottom: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 2,
                            child: InkWell(
                              onTap: () => _navigateToAddEditPage(sleepLog: log),
                              borderRadius: BorderRadius.circular(16),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          DateFormat('EEE, dd MMM yyyy').format(log.bedTime),
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: _getQualityColor(log.qualityRating),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            'Quality: ${log.qualityRating}/5',
                                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.bedtime, size: 16, color: Colors.indigo),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${DateFormat('HH:mm').format(log.bedTime)} - ${DateFormat('HH:mm').format(log.wakeTime)}',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        const Spacer(),
                                        const Icon(Icons.access_time, size: 16, color: Colors.grey),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${hours}h ${minutes}m',
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    if (log.notes != null && log.notes!.isNotEmpty) ...[
                                      const Divider(height: 16),
                                      Text(
                                        log.notes!,
                                        style: const TextStyle(color: Colors.grey, fontSize: 12, fontStyle: FontStyle.italic),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
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
                  return const Center(child: Text('Something went wrong'));
                },
              ),
            ),
          ],
        ),
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
