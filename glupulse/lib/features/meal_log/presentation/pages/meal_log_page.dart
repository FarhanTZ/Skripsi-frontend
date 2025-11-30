import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:glupulse/features/meal_log/domain/entities/meal_log.dart';
import 'package:glupulse/features/meal_log/presentation/cubit/meal_log_cubit.dart';
import 'package:glupulse/injection_container.dart';
import 'package:glupulse/features/meal_log/presentation/pages/add_meal_log_page.dart';
// import 'package:glupulse/features/meal_log/presentation/pages/meal_log_detail_page.dart'; // REMOVED

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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is MealLogLoading || 
              state is MealLogInitial || 
              state is MealLogAdded || 
              state is MealLogUpdated || 
              state is MealLogDetailLoaded) {
            // Jika state detail loaded (kembali dari edit tanpa save),
            // kita perlu me-refresh list agar kembali ke state MealLogLoaded
            if (state is MealLogDetailLoaded) {
               // Panggil refresh di frame berikutnya agar tidak error saat build
               WidgetsBinding.instance.addPostFrameCallback((_) {
                 _refreshMealLogs(context);
               });
            }
            return const Center(child: CircularProgressIndicator());
          } else if (state is MealLogLoaded) {
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
                  final sortedLogs = List<MealLog>.from(state.mealLogs)
                    ..sort((a, b) => b.mealTimestamp.compareTo(a.mealTimestamp));
                  
                  return _buildMealLogCard(context, sortedLogs[index]);
                },
              ),
            );
          } else if (state is MealLogError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load meals',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _refreshMealLogs(context),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  )
                ],
              ),
            );
          }
          return const Center(child: Text('Unknown state'));
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Navigasi ke halaman tambah, dan refresh saat kembali
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<MealLogCubit>(),
                child: const AddMealLogPage(),
              ),
            ),
          );
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

    // Menentukan Warna & Ikon berdasarkan Tipe Makan
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

    return Card(
      elevation: 0, // Flat style modern
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          // Navigasi ke Edit Mode (reuse AddMealLogPage)
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<MealLogCubit>(),
                child: AddMealLogPage(mealLog: log),
              ),
            ),
          );
          // Refresh list setelah kembali (jika ada update)
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
                  // Icon Box
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: typeColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(typeIcon, color: typeColor, size: 24),
                  ),
                  const SizedBox(width: 12),
                  // Title & Date
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
                  // Time
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
              // Description
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
              // Macros Row (Calories, Carbs, Protein, Fat)
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