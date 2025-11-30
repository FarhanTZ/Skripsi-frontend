import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:glupulse/features/meal_log/domain/entities/meal_log.dart';
import 'package:glupulse/features/meal_log/presentation/cubit/meal_log_cubit.dart';
import 'package:glupulse/features/meal_log/presentation/pages/add_meal_log_page.dart';
import 'package:glupulse/injection_container.dart';

class MealLogPage extends StatelessWidget {
  const MealLogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MealLogCubit>()..getMealLogs(),
      child: const MealLogView(),
    );
  }
}

class MealLogView extends StatefulWidget {
  const MealLogView({super.key});

  @override
  State<MealLogView> createState() => _MealLogViewState();
}

class _MealLogViewState extends State<MealLogView> {
  Future<void> _refreshMealLogs(BuildContext context) async {
    print('MEAL_LOG_PAGE: _refreshMealLogs called');
    await context.read<MealLogCubit>().getMealLogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light grey background
      appBar: AppBar(
        title: const Text(
          'Meal History',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: BlocConsumer<MealLogCubit, MealLogState>(
        listener: (context, state) {
          if (state is MealLogError) {
            // Jangan tampilkan SnackBar jika errornya karena format respons (biasanya data kosong)
            if (!state.message.contains('Respons dari server bukan format yang diharapkan')) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          }
        },
        builder: (context, state) {
          print('MEAL_LOG_PAGE: Builder state: $state');
          
          // Handle Loading States (termasuk state transisi seperti Added/Updated/DetailLoaded)
          if (state is MealLogLoading || 
              state is MealLogInitial || 
              state is MealLogAdded || 
              state is MealLogUpdated || 
              state is MealLogDetailLoaded ||
              state is MealLogDeleted) {
            
            // Jika state DetailLoaded (kembali tanpa save) atau Updated/Added (sukses save),
            // kita perlu paksa refresh agar kembali ke list terbaru.
            if (state is MealLogDetailLoaded || state is MealLogUpdated || state is MealLogAdded || state is MealLogDeleted) {
               WidgetsBinding.instance.addPostFrameCallback((_) {
                 _refreshMealLogs(context);
               });
            }
            
            return const Center(child: CircularProgressIndicator());
          } 
          
          // Handle Loaded State
          else if (state is MealLogLoaded) {
            if (state.mealLogs.isEmpty) {
              return _buildEmptyState();
            }
            return RefreshIndicator(
              onRefresh: () => _refreshMealLogs(context),
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.mealLogs.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  // Sorting log terbaru di atas
                  final sortedLogs = List<MealLog>.from(state.mealLogs)
                    ..sort((a, b) => b.mealTimestamp.compareTo(a.mealTimestamp));
                  
                  return _buildMealLogCard(context, sortedLogs[index]);
                },
              ),
            );
          } 
          
          // Handle Error State
          else if (state is MealLogError) {
            return Center(
              child: Text(
                'Belum ada data meal log silakan masukan terlebih dahulu',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
            );
          }
          
          return const Center(child: Text('Unknown state'));
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          print('MEAL_LOG_PAGE: Navigating to Add Page...');
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<MealLogCubit>(),
                child: const AddMealLogPage(),
              ),
            ),
          );
          print('MEAL_LOG_PAGE: Returned from Add Page.');
          if (context.mounted) {
            _refreshMealLogs(context);
          }
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Log Meal'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant_menu, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'No meals logged yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Track your nutrition by adding a meal.',
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildMealLogCard(BuildContext context, MealLog log) {
    final dateFormat = DateFormat('EEE, dd MMM');
    final timeFormat = DateFormat('HH:mm');
    final dateString = dateFormat.format(log.mealTimestamp);
    final timeString = timeFormat.format(log.mealTimestamp);

    Color typeColor;
    IconData typeIcon;
    String typeName;

    switch (log.mealTypeId) {
      case 1: // Breakfast
        typeColor = Colors.orange;
        typeIcon = Icons.wb_sunny_outlined;
        typeName = 'Breakfast';
        break;
      case 2: // Lunch
        typeColor = Colors.blue;
        typeIcon = Icons.lunch_dining_outlined;
        typeName = 'Lunch';
        break;
      case 3: // Dinner
        typeColor = Colors.indigo;
        typeIcon = Icons.nightlight_round;
        typeName = 'Dinner';
        break;
      case 4: // Snack
        typeColor = Colors.green;
        typeIcon = Icons.local_cafe_outlined;
        typeName = 'Snack';
        break;
      default:
        typeColor = Colors.grey;
        typeIcon = Icons.restaurant;
        typeName = 'Meal';
    }

    return Dismissible(
      key: Key(log.mealId ?? UniqueKey().toString()),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Confirm Delete'),
            content: const Text('Are you sure you want to delete this meal log?'),
            actions: <Widget>[
              TextButton(
                child: const Text('No'),
                onPressed: () => Navigator.of(ctx).pop(false),
              ),
              TextButton(
                child: const Text('Yes'),
                onPressed: () => Navigator.of(ctx).pop(true),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        if (log.mealId != null) {
          context.read<MealLogCubit>().deleteMealLog(log.mealId!);
        }
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () async {
            print('MEAL_LOG_PAGE: Navigating to Edit Page for ${log.mealId}');
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<MealLogCubit>(),
                  child: AddMealLogPage(mealLog: log),
                ),
              ),
            );
            print('MEAL_LOG_PAGE: Returned from Edit Page.');
            if (context.mounted) {
              _refreshMealLogs(context);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: typeColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(typeIcon, color: typeColor, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            typeName,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: typeColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            dateString,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      timeString,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Text(
                  log.description ?? 'No description provided',
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildMacroInfo('Cal', '${log.totalCalories ?? 0}'),
                    _buildMacroInfo('Carbs', '${log.totalCarbsGrams ?? 0}g'),
                    _buildMacroInfo('Prot', '${log.totalProteinGrams ?? 0}g'),
                    _buildMacroInfo('Fat', '${log.totalFatGrams ?? 0}g'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMacroInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),
      ],
    );
  }
}
