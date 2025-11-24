import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:glupulse/features/health_event/domain/entities/health_event.dart';
import 'package:glupulse/features/health_event/presentation/cubit/health_event_cubit.dart';
import 'package:glupulse/features/health_event/presentation/pages/add_edit_health_event_page.dart';
import 'package:glupulse/injection_container.dart';

class HealthEventListPage extends StatefulWidget {
  const HealthEventListPage({super.key});

  @override
  State<HealthEventListPage> createState() => _HealthEventListPageState();
}

class _HealthEventListPageState extends State<HealthEventListPage> {
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
    _fetchHealthEventRecords(); // Refresh data after returning
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this record?'),
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () {
              context.read<HealthEventCubit>().deleteHealthEvent(id);
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Event Records'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navigateToAddEditPage(),
          ),
        ],
      ),
      body: BlocConsumer<HealthEventCubit, HealthEventState>(
        listener: (context, state) {
          if (state is HealthEventDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Health Event Record Deleted!')),
            );
            _fetchHealthEventRecords(); // Refresh after delete
          } else if (state is HealthEventError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          if (state is HealthEventLoading && !(state is HealthEventDeleted)) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HealthEventLoaded) {
            if (state.healthEventRecords.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('No Health Event records found.'),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Add New Health Event Record'),
                      onPressed: () => _navigateToAddEditPage(),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              itemCount: state.healthEventRecords.length,
              itemBuilder: (context, index) {
                final healthEvent = state.healthEventRecords[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text('Type: ${healthEvent.eventType}, Severity: ${healthEvent.severity}'),
                    subtitle: Text(
                        'Date: ${DateFormat('yyyy-MM-dd').format(healthEvent.eventDate)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _navigateToAddEditPage(healthEvent: healthEvent),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _confirmDelete(context, healthEvent.id!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is HealthEventError) {
            return const Center(
              child: Text('Tidak ada data ditemukan, silakan masukan data terlebih dahulu'),
            );
          }
          return const Center(child: Text('Press the + button to add a new Health Event record.'));
        },
      ),
    );
  }
}
