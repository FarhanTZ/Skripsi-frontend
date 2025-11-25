import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:glupulse/features/medication/domain/entities/medication_log.dart';
import 'package:glupulse/features/medication/presentation/cubit/medication_log_cubit.dart';
import 'package:glupulse/features/medication/presentation/pages/add_edit_medication_log_page.dart';

class MedicationLogListPage extends StatefulWidget {
  const MedicationLogListPage({super.key});

  @override
  State<MedicationLogListPage> createState() => _MedicationLogListPageState();
}

class _MedicationLogListPageState extends State<MedicationLogListPage> {
  @override
  void initState() {
    super.initState();
    _fetchLogs();
  }

  Future<void> _fetchLogs() async {
    context.read<MedicationLogCubit>().fetchMedicationLogs();
  }

  void _navigateToAddEditLog({MedicationLog? log}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => AddEditMedicationLogPage(log: log)),
    );
    _fetchLogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddEditLog(),
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
                    'Medication Logs',
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
              child: BlocConsumer<MedicationLogCubit, MedicationLogState>(
                listener: (context, state) {
                   if (state is MedicationLogSuccess) {
                     // If delete happened
                    _fetchLogs();
                  }
                },
                builder: (context, state) {
                  if (state is MedicationLogLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is MedicationLogLoaded) {
                    if (state.logs.isEmpty) {
                      return const Center(child: Text('No logs found.'));
                    }

                    final sortedLogs = List.from(state.logs)
                      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                      itemCount: sortedLogs.length,
                      itemBuilder: (context, index) {
                        final log = sortedLogs[index];
                        return Dismissible(
                          key: Key(log.id!),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (_) async {
                             return await showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Confirm Delete'),
                                content: const Text('Delete this log?'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('No')),
                                  TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Yes')),
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
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(16)),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          child: Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 2,
                            child: ListTile(
                              onTap: () => _navigateToAddEditLog(log: log),
                              contentPadding: const EdgeInsets.all(16),
                              title: Text(
                                log.medicationName ?? 'Medication #${log.medicationId}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text('${log.doseAmount} (Reason: ${log.reason.replaceAll('_', ' ')})'),
                                  Text(DateFormat('MMM dd, yyyy HH:mm').format(log.timestamp), style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                ],
                              ),
                              trailing: const Icon(Icons.chevron_right),
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
}
