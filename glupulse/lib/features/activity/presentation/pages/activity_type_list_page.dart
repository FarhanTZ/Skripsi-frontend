import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glupulse/features/activity/domain/entities/activity_type.dart';
import 'package:glupulse/features/activity/presentation/cubit/activity_cubit.dart';
import 'package:glupulse/features/activity/presentation/cubit/activity_state.dart';
import 'package:glupulse/features/activity/presentation/pages/activity_log_list_page.dart';

class ActivityTypeListPage extends StatefulWidget {
  const ActivityTypeListPage({super.key});

  @override
  State<ActivityTypeListPage> createState() => _ActivityTypeListPageState();
}

class _ActivityTypeListPageState extends State<ActivityTypeListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final Set<String> _selectedIntensities = {};

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    context.read<ActivityCubit>().fetchActivityTypes();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  void _toggleIntensityFilter(String intensity) {
    setState(() {
      if (_selectedIntensities.contains(intensity)) {
        _selectedIntensities.remove(intensity);
      } else {
        _selectedIntensities.add(intensity);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<ActivityCubit>(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F5F9),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                // --- Header Kustom ---
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
                        'Activity Types',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                
                // --- Search Bar ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search activity...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    ),
                  ),
                ),

                // --- Intensity Filter Buttons (3x1) ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      _buildFilterButton('LOW', Colors.green),
                      const SizedBox(width: 8),
                      _buildFilterButton('MODERATE', Colors.orange),
                      const SizedBox(width: 8),
                      _buildFilterButton('HIGH', Colors.red),
                    ],
                  ),
                ),

                BlocBuilder<ActivityCubit, ActivityState>(
                  builder: (context, state) {
                    if (state is ActivityLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ActivityTypesLoaded) {
                      List<ActivityType> filteredActivities = state.activityTypes.where((activity) {
                        final matchesSearch = activity.displayName.toLowerCase().contains(_searchQuery.toLowerCase());
                        final matchesFilter = _selectedIntensities.isEmpty || _selectedIntensities.contains(activity.intensityLevel.toUpperCase());
                        return matchesSearch && matchesFilter;
                      }).toList();
                      
                      if (filteredActivities.isEmpty) {
                         return Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Text(
                            _searchQuery.isNotEmpty 
                              ? 'No activities found for "$_searchQuery".' 
                              : 'No activities match the selected filters.',
                            textAlign: TextAlign.center,
                          ),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16.0),
                        itemCount: filteredActivities.length,
                        itemBuilder: (context, index) {
                          final type = filteredActivities[index];
                          final imageAsset = _getImageAssetForActivity(type.activityCode);

                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.only(bottom: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            color: Colors.white,
                            clipBehavior: Clip.antiAlias,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ActivityLogListPage(activityType: type),
                                  ),
                                );
                              },
                              child: SizedBox(
                                height: 200,
                                child: Row(
                                  children: [
                                    // LEFT SIDE: Content
                                    Expanded(
                                      flex: 3,
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            // Icon Container
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.grey.withValues(alpha: 0.2),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Icon(
                                                _getIconForActivity(type.activityCode),
                                                size: 24,
                                                color: Theme.of(context).colorScheme.primary,
                                              ),
                                            ),
                                            const Spacer(),
                                            // Activity Name
                                            Text(
                                              type.displayName,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 8),
                                            // Intensity Status
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: _getIntensityColor(type.intensityLevel).withValues(alpha: 0.1),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                type.intensityLevel,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                  color: _getIntensityColor(type.intensityLevel),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    
                                    // RIGHT SIDE: Image or Fallback
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        height: double.infinity,
                                        decoration: BoxDecoration(
                                          color: _getColorForActivity(type.activityCode).withValues(alpha: 0.05),
                                        ),
                                        child: imageAsset != null
                                            ? Image.asset(
                                                  imageAsset,
                                                  fit: BoxFit.cover, 
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return Center(
                                                      child: Icon(
                                                        _getIconForActivity(type.activityCode),
                                                        size: 50,
                                                        color: _getColorForActivity(type.activityCode).withValues(alpha: 0.5),
                                                      ),
                                                    );
                                                  },
                                                )
                                            : Center(
                                                child: Icon(
                                                  _getIconForActivity(type.activityCode),
                                                  size: 60,
                                                  color: _getColorForActivity(type.activityCode).withValues(alpha: 0.3),
                                                ),
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state is ActivityError) {
                      return Center(child: Text(state.message));
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton(String intensity, Color activeColor) {
    final bool isActive = _selectedIntensities.contains(intensity);
    return Expanded(
      child: GestureDetector(
        onTap: () => _toggleIntensityFilter(intensity),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? activeColor : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: isActive ? null : Border.all(color: Colors.grey.shade300),
            boxShadow: isActive 
              ? [BoxShadow(color: activeColor.withValues(alpha: 0.4), blurRadius: 8, offset: const Offset(0, 4))]
              : null,
          ),
          child: Text(
            intensity,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.grey.shade600,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  String? _getImageAssetForActivity(String code) {
    if (code == 'CALISTHENICS') {
      return 'assets/images/aktivity/Calisthenics.png';
    } else if (code == 'DANCE') {
      return 'assets/images/aktivity/Dancing.png';
    } else if (code == 'CYCLING_LIGHT' || code == 'CYCLING_INTENSE') {
      return 'assets/images/aktivity/Cyling.png';
    } else if (code == 'HIIT') {
      return 'assets/images/aktivity/High_Intensity_Interval_Training.jpg';
    } else if (code == 'HIKING') {
      return 'assets/images/aktivity/Hiking.png';
    } else if (code == 'HOUSEWORK') {
      return 'assets/images/aktivity/Household_Chores.png';
    } else if (code == 'MARTIAL_ARTS') {
      return 'assets/images/aktivity/Martial_arts _Boxing.png';
    } else if (code == 'OCCUPATIONAL') {
      return 'assets/images/aktivity/Occupational_Labor.png';
    } else if (code == 'RACKET_SPORTS') {
      return 'assets/images/aktivity/Raket Sports (Badminton, Tenis).png';
    }
    return null;
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
  
  Color _getColorForActivity(String code) {
      switch (code) {
      case 'RUNNING':
      case 'HIIT':
      case 'MARTIAL_ARTS':
        return Colors.red;
      case 'WALKING':
      case 'YOGA_PILATES':
      case 'HOUSEWORK':
        return Colors.green;
      case 'CYCLING_LIGHT':
      case 'CYCLING_INTENSE':
      case 'RACKET_SPORTS':
        return Colors.orange;
      case 'SWIMMING':
      case 'TEAM_SPORTS':
        return Colors.blue;
      case 'WEIGHT_LIFTING':
      case 'CALISTHENICS':
      case 'HIKING':
        return Colors.brown;
      case 'DANCE':
        return Colors.purple;
      default:
        return Colors.blueGrey;
    }
  }

  Color _getIntensityColor(String level) {
    switch (level.toUpperCase()) {
        case 'LOW':
          return Colors.green;
      case 'MODERATE':
        return Colors.orange;
      case 'HIGH':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}
