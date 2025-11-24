import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:glupulse/features/hba1c/domain/entities/hba1c.dart';
import 'package:glupulse/features/hba1c/presentation/cubit/hba1c_cubit.dart';
import 'package:glupulse/features/hba1c/presentation/pages/add_edit_hba1c_page.dart';
import 'package:glupulse/injection_container.dart';

class Hba1cListPage extends StatefulWidget {
  const Hba1cListPage({super.key});

  @override
  State<Hba1cListPage> createState() => _Hba1cListPageState();
}

class _Hba1cListPageState extends State<Hba1cListPage> {
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
    _fetchHba1cRecords(); // Refresh data after returning
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
              context.read<Hba1cCubit>().deleteHba1c(id);
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
        title: const Text('Hba1c Records'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navigateToAddEditPage(),
          ),
        ],
      ),
      body: BlocConsumer<Hba1cCubit, Hba1cState>(
        listener: (context, state) {
          if (state is Hba1cUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Hba1c Record Updated!')),
            );
            // Refresh sudah ditangani oleh _navigateToAddEditPage
          } else if (state is Hba1cDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Hba1c Record Deleted!')),
            );
            _fetchHba1cRecords(); // Refresh after delete
          } else if (state is Hba1cError) {
            _fetchHba1cRecords(); // Muat ulang data sebelumnya jika terjadi error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          // Tampilkan loading hanya jika state saat ini adalah Hba1cLoading
          // dan state sebelumnya bukan Hba1cLoaded (untuk menghindari kedipan saat refresh).
          // Atau jika state adalah Hba1cLoading dan belum ada data yang dimuat.
          if (state is Hba1cLoading && state is! Hba1cLoaded) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is Hba1cLoaded) {
            if (state.hba1cRecords.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('No Hba1c records found.'),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Add New Hba1c Record'),
                      onPressed: () => _navigateToAddEditPage(),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              itemCount: state.hba1cRecords.length,
              itemBuilder: (context, index) {
                final hba1c = state.hba1cRecords[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text('Hba1c: ${hba1c.hba1cPercentage}%'),
                    subtitle: Text(
                        'Date: ${DateFormat('yyyy-MM-dd').format(hba1c.testDate)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          // Nonaktifkan tombol jika ID null untuk mencegah error
                          onPressed: hba1c.id == null
                              ? null
                              : () => _navigateToAddEditPage(hba1c: hba1c),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          // Nonaktifkan tombol dan lakukan pengecekan null sebelum memanggil confirmDelete
                          onPressed: hba1c.id == null
                              ? null
                              : () => _confirmDelete(context, hba1c.id!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is Hba1cError) {
            return Center(
              child: Text('Failed to load Hba1c records: ${state.message}'),
            );
          }
          return const Center(child: Text('Press the + button to add a new Hba1c record.'));
        },
      ),
    );
  }
}
