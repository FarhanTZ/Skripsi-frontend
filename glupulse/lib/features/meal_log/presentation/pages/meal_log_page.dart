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
  DateTime _selectedDate = DateTime.now();

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Widget _buildDateSelector(List<MealLog> logs) {
    // Generate 30 hari terakhir + hari ini
    final dates = List.generate(30, (index) {
      return DateTime.now().subtract(Duration(days: index));
    }).reversed.toList();

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
        controller: ScrollController(initialScrollOffset: 60.0 * 28),
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected = _isSameDay(date, _selectedDate);
          final hasLog = logs.any((log) => _isSameDay(log.mealTimestamp, date));

          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setStateInner) {
              bool isCurrentlyPressed = false;

              return GestureDetector(
                onTapDown: (_) {
                  setStateInner(() => isCurrentlyPressed = true);
                },
                onTapUp: (_) {
                  setStateInner(() => isCurrentlyPressed = false);
                  setState(() => _selectedDate = date);
                },
                onTapCancel: () {
                  setStateInner(() => isCurrentlyPressed = false);
                },
                child: Container(
                  width: 60,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF0F67FE) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: isSelected
                        ? null
                        : Border.all(color: Colors.grey.shade300),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                      if (isCurrentlyPressed)
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.6),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: const Offset(0, 4),
                        ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('EEE').format(date),
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Colors.white70 : Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('d').format(date),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                      if (hasLog) ...[
                        const SizedBox(height: 4),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white
                                : Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        )
                      ] else ...[
                        const SizedBox(height: 10),
                      ]
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _refreshMealLogs(BuildContext context) async {
    print('MEAL_LOG_PAGE: _refreshMealLogs called');
    await context.read<MealLogCubit>().getMealLogs();
  }

  Widget _buildCustomHeader() {
    return Column(
      children: [
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
                'Meal History',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            _buildCustomHeader(),
            Expanded(
              child: BlocConsumer<MealLogCubit, MealLogState>(
                listener: (context, state) {
                  if (state is MealLogError) {
                    if (!state.message.contains(
                        'Respons dari server bukan format yang diharapkan')) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    }
                  }
                },
                builder: (context, state) {
                  print('MEAL_LOG_PAGE: Builder state: $state');

                  if (state is MealLogLoading ||
                      state is MealLogInitial ||
                      state is MealLogAdded ||
                      state is MealLogUpdated ||
                      state is MealLogDetailLoaded ||
                      state is MealLogDeleted) {
                    if (state is MealLogDetailLoaded ||
                        state is MealLogUpdated ||
                        state is MealLogAdded ||
                        state is MealLogDeleted) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _refreshMealLogs(context);
                      });
                    }

                    return const Center(child: CircularProgressIndicator());
                  } else if (state is MealLogLoaded) {
                    final filteredLogs = state.mealLogs.where((log) {
                      return _isSameDay(log.mealTimestamp, _selectedDate);
                    }).toList();

                    final sortedLogs = List<MealLog>.from(filteredLogs)
                      ..sort(
                          (a, b) => b.mealTimestamp.compareTo(a.mealTimestamp));

                    return Column(
                      children: [
                        _buildDateSelector(state.mealLogs),
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: () => _refreshMealLogs(context),
                            child: ListView.separated(
                              padding:
                                  const EdgeInsets.only(top: 0, bottom: 16),
                              itemCount:
                                  sortedLogs.length + (sortedLogs.isEmpty ? 2 : 1),
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 16),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: Text(
                                          'Daily Nutrition',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      _buildNutritionSummary(sortedLogs),
                                      const SizedBox(height: 24),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: Text(
                                          "Today's Meals",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                    ],
                                  );
                                }

                                if (sortedLogs.isEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 32.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.restaurant_menu,
                                            size: 64,
                                            color: Colors.grey.shade300),
                                        const SizedBox(height: 16),
                                        Text(
                                          'No meals logged for ${DateFormat('d MMMM').format(_selectedDate)}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey.shade600,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: _buildMealLogCard(
                                      context, sortedLogs[index - 1]),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  } else if (state is MealLogError) {
                    return Center(
                      child: Text(
                        'Belum ada data meal log silakan masukan terlebih dahulu',
                        style: TextStyle(
                            fontSize: 16, color: Colors.grey.shade600),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  return const Center(child: Text('Unknown state'));
                },
              ),
            ),
          ],
        ),
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
                  children: [
                    Expanded(child: _buildMacroInfo('Cal', '${log.totalCalories ?? 0}', alignment: CrossAxisAlignment.start, labelColor: Colors.orange)),
                    Expanded(child: _buildMacroInfo('Carbs', '${log.totalCarbsGrams ?? 0}g', alignment: CrossAxisAlignment.center, labelColor: Colors.blue)),
                    Expanded(child: _buildMacroInfo('Prot', '${log.totalProteinGrams ?? 0}g', alignment: CrossAxisAlignment.end, labelColor: Colors.purple)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _buildMacroInfo('Fat', '${log.totalFatGrams ?? 0}g', alignment: CrossAxisAlignment.start, labelColor: Colors.red)),
                    Expanded(child: _buildMacroInfo('Fiber', '${log.totalFiberGrams ?? 0}g', alignment: CrossAxisAlignment.center, labelColor: Colors.green)),
                    Expanded(child: _buildMacroInfo('Sugar', '${log.totalSugarGrams ?? 0}g', alignment: CrossAxisAlignment.end, labelColor: Colors.pink)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMacroInfo(String label, String value, {CrossAxisAlignment alignment = CrossAxisAlignment.start, required Color labelColor}) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 11, color: labelColor),
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

  Widget _buildNutritionSummary(List<MealLog> logs) {
    double totalCalories = 0;
    double totalCarbs = 0;
    double totalProtein = 0;
    double totalFat = 0;
    double totalFiber = 0;
    double totalSugar = 0;

    for (var log in logs) {
      totalCalories += (log.totalCalories ?? 0).toDouble();
      totalCarbs += (log.totalCarbsGrams ?? 0).toDouble();
      totalProtein += (log.totalProteinGrams ?? 0).toDouble();
      totalFat += (log.totalFatGrams ?? 0).toDouble();
      totalFiber += (log.totalFiberGrams ?? 0).toDouble();
      totalSugar += (log.totalSugarGrams ?? 0).toDouble();
    }

    return SizedBox(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildNutritionCard(
              'Calories', totalCalories.toStringAsFixed(0), 'kcal', Colors.orange),
          const SizedBox(width: 12),
          _buildNutritionCard(
              'Carbs', totalCarbs.toStringAsFixed(1), 'g', Colors.blue),
          const SizedBox(width: 12),
          _buildNutritionCard(
              'Protein', totalProtein.toStringAsFixed(1), 'g', Colors.purple),
          const SizedBox(width: 12),
          _buildNutritionCard(
              'Fat', totalFat.toStringAsFixed(1), 'g', Colors.red),
          const SizedBox(width: 12),
          _buildNutritionCard(
              'Fiber', totalFiber.toStringAsFixed(1), 'g', Colors.green),
          const SizedBox(width: 12),
          _buildNutritionCard(
              'Sugar', totalSugar.toStringAsFixed(1), 'g', Colors.pink),
        ],
      ),
    );
  }

  Widget _buildNutritionCard(
      String label, String value, String unit, Color color) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            unit,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
