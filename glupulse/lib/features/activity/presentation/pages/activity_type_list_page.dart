import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glupulse/features/activity/presentation/cubit/activity_cubit.dart';
import 'package:glupulse/features/activity/presentation/cubit/activity_state.dart';
import 'package:glupulse/features/activity/presentation/pages/activity_log_list_page.dart';
import 'package:glupulse/injection_container.dart';

class ActivityTypeListPage extends StatelessWidget {
  const ActivityTypeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ActivityCubit>()..fetchActivityTypes(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F5F9),
        appBar: AppBar(
          title: const Text(
            'Activity Types',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          iconTheme: const IconThemeData(color: Colors.white),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
        ),
        body: BlocBuilder<ActivityCubit, ActivityState>(
          builder: (context, state) {
            if (state is ActivityLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ActivityTypesLoaded) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: state.activityTypes.length,
                  itemBuilder: (context, index) {
                    final type = state.activityTypes[index];
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ActivityLogListPage(activityType: type),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(15),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _getIconForActivity(type.activityCode),
                                size: 40,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                type.displayName,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                type.intensityLevel,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            } else if (state is ActivityError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  IconData _getIconForActivity(String code) {
    switch (code) {
      case 'RUNNING':
        return Icons.directions_run;
      case 'WALKING':
        return Icons.directions_walk;
      case 'CYCLING_LIGHT':
      case 'CYCLING_INTENSE':
        return Icons.directions_bike;
      case 'SWIMMING':
        return Icons.pool;
      case 'YOGA_PILATES':
        return Icons.self_improvement;
      case 'WEIGHT_LIFTING':
        return Icons.fitness_center;
      case 'HIIT':
        return Icons.timer;
      case 'DANCE':
        return Icons.music_note;
      case 'HIKING':
        return Icons.hiking;
      case 'TEAM_SPORTS':
        return Icons.sports_basketball;
      case 'RACKET_SPORTS':
        return Icons.sports_tennis;
      case 'MARTIAL_ARTS':
        return Icons.sports_mma;
      case 'HOUSEWORK':
        return Icons.cleaning_services;
      case 'OCCUPATIONAL':
        return Icons.work;
      case 'CALISTHENICS':
        return Icons.accessibility_new;
      default:
        return Icons.sports;
    }
  }
}
