import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glupulse/features/meal_log/presentation/cubit/meal_log_cubit.dart';
import 'package:glupulse/features/meal_log/presentation/pages/add_meal_log_page.dart';
import 'package:glupulse/injection_container.dart';

class MealLogPage extends StatelessWidget {
  const MealLogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MealLogCubit>()..getMealLogs(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Meal Logs')),
        body: BlocBuilder<MealLogCubit, MealLogState>(
          builder: (context, state) {
            if (state is MealLogLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MealLogLoaded) {
              if (state.mealLogs.isEmpty) {
                return const Center(child: Text('No meal logs found.'));
              }
              return ListView.builder(
                itemCount: state.mealLogs.length,
                itemBuilder: (context, index) {
                  final log = state.mealLogs[index];
                  return ListTile(
                    title: Text(log.description ?? 'No description'),
                    subtitle: Text('${log.mealTimestamp}'),
                  );
                },
              );
            } else if (state is MealLogError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: Text('Welcome to Meal Log'));
          },
        ),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<MealLogCubit>(),
                      child: const AddMealLogPage(),
                    ),
                  ),
                ).then((_) => context.read<MealLogCubit>().getMealLogs());
              },
              child: const Icon(Icons.add),
            );
          }
        ),
      ),
    );
  }
}
