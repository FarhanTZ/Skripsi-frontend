import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glupulse/features/recommendation/presentation/cubit/recommendation_cubit.dart';
import 'package:glupulse/features/recommendation/presentation/pages/recommendation_page.dart';

class AddRecommendationPage extends StatefulWidget {
  const AddRecommendationPage({super.key});

  @override
  State<AddRecommendationPage> createState() => _AddRecommendationPageState();
}

class _AddRecommendationPageState extends State<AddRecommendationPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController _foodPreferencesController = TextEditingController();
  final TextEditingController _activityPreferencesController = TextEditingController();
  final TextEditingController _insightsController = TextEditingController();

  // Meal Type Dropdown
  String? _selectedMealType;
  final List<String> _mealTypes = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];

  // For multi-selects
  bool _includeFood = true;
  bool _includeActivity = true;
  bool _includeInsights = true;

  List<String> _selectedFoodCategories = [];
  List<String> _selectedActivityTypes = [];

  final List<String> _allFoodCategories = ['MEDITERRANEAN', 'VEGETABLES', 'LOW_CARB', 'HIGH_PROTEIN', 'DAIRY_FREE', 'GLUTEN_FREE'];
  final List<String> _allActivityTypes = ['YOGA', 'WALKING', 'SWIMMING', 'RUNNING', 'STRENGTH', 'CYCLING'];

  @override
  void dispose() {
    _foodPreferencesController.dispose();
    _activityPreferencesController.dispose();
    _insightsController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Process data
      List<String> selectedTypes = [];
      if (_includeFood) selectedTypes.add("food");
      if (_includeActivity) selectedTypes.add("activity");
      if (_includeInsights) selectedTypes.add("insights");

      if (selectedTypes.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one recommendation type.')),
        );
        return;
      }

      final data = {
        "type": selectedTypes,
        "meal_type": _selectedMealType ?? "Any",
        "food_category_code": _selectedFoodCategories,
        "food_preferences": _foodPreferencesController.text,
        "activity_type_code": _selectedActivityTypes,
        "activity_preferences": _activityPreferencesController.text,
        "insights": _insightsController.text,
      };

      context.read<RecommendationCubit>().fetchRecommendation(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return BlocListener<RecommendationCubit, RecommendationState>(
      listener: (context, state) {
        if (state is RecommendationLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(child: CircularProgressIndicator()),
          );
        } else if (state is RecommendationLoaded) {
          Navigator.of(context).pop(); // Dismiss loading dialog
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => RecommendationPage(recommendation: state.recommendation),
            ),
          );
        } else if (state is RecommendationError) {
          Navigator.of(context).pop(); // Dismiss loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F5F9), // Light grey/blue background
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text('Personalized Advice', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, const Color(0xFFF2F5F9)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'What do you need help with?',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Select the areas you want our AI to analyze for you.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                
                // --- Type Selection Cards ---
                Row(
                  children: [
                    _buildTypeSelectionCard(
                      icon: Icons.restaurant_menu_rounded,
                      label: 'Food',
                      isSelected: _includeFood,
                      onTap: () => setState(() => _includeFood = !_includeFood),
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 12),
                    _buildTypeSelectionCard(
                      icon: Icons.directions_run_rounded,
                      label: 'Activity',
                      isSelected: _includeActivity,
                      onTap: () => setState(() => _includeActivity = !_includeActivity),
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 12),
                    _buildTypeSelectionCard(
                      icon: Icons.lightbulb_outline_rounded,
                      label: 'Insights',
                      isSelected: _includeInsights,
                      onTap: () => setState(() => _includeInsights = !_includeInsights),
                      color: Colors.purple,
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),

                // --- Food Section ---
                AnimatedCrossFade(
                  firstChild: Container(),
                  secondChild: Column(
                    children: [
                      _buildSectionCard(
                        title: 'Dietary Preferences',
                        icon: Icons.restaurant,
                        iconColor: Colors.orange,
                        children: [
                          DropdownButtonFormField<String>(
                            value: _selectedMealType,
                            decoration: _inputDecoration('Meal Type', Icons.access_time_filled),
                            items: _mealTypes.map((type) {
                              return DropdownMenuItem(value: type, child: Text(type));
                            }).toList(),
                            onChanged: (val) => setState(() => _selectedMealType = val),
                          ),
                          const SizedBox(height: 16),
                          _buildMultiSelectChips(
                            label: 'Preferred Categories',
                            allOptions: _allFoodCategories,
                            selectedOptions: _selectedFoodCategories,
                            color: Colors.orange,
                            onSelectionChanged: (newSelection) {
                              setState(() => _selectedFoodCategories = newSelection);
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _foodPreferencesController,
                            decoration: _inputDecoration('Specific preferences (e.g. Vegetarian)', Icons.notes),
                            maxLines: 2,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                  crossFadeState: _includeFood ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                ),

                // --- Activity Section ---
                AnimatedCrossFade(
                  firstChild: Container(),
                  secondChild: Column(
                    children: [
                      _buildSectionCard(
                        title: 'Activity Goals',
                        icon: Icons.fitness_center,
                        iconColor: Colors.blue,
                        children: [
                           _buildMultiSelectChips(
                            label: 'Interested Activities',
                            allOptions: _allActivityTypes,
                            selectedOptions: _selectedActivityTypes,
                            color: Colors.blue,
                            onSelectionChanged: (newSelection) {
                              setState(() => _selectedActivityTypes = newSelection);
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _activityPreferencesController,
                            decoration: _inputDecoration('Activity Preferences (e.g. Low impact)', Icons.notes),
                            maxLines: 2,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                  crossFadeState: _includeActivity ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                ),

                // --- Insights Section ---
                 AnimatedCrossFade(
                  firstChild: Container(),
                  secondChild: _buildSectionCard(
                    title: 'Specific Question',
                    icon: Icons.help_outline,
                    iconColor: Colors.purple,
                    children: [
                      TextFormField(
                        controller: _insightsController,
                        decoration: _inputDecoration('Ask about your health (e.g. How to lower A1c?)', Icons.question_answer),
                        maxLines: 4,
                      ),
                    ],
                  ),
                  crossFadeState: _includeInsights ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                ),

                const SizedBox(height: 30),

                // --- Submit Button ---
                Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryColor, primaryColor.withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text(
                      'Generate Recommendations',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildTypeSelectionCard({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? color : Colors.grey.shade300,
              width: 2,
            ),
            boxShadow: isSelected
                ? [BoxShadow(color: color.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))]
                : [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))],
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? Colors.white : color, size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required IconData icon, required Color iconColor, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildMultiSelectChips({
    required String label,
    required List<String> allOptions,
    required List<String> selectedOptions,
    required ValueChanged<List<String>> onSelectionChanged,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: allOptions.map((option) {
            final isSelected = selectedOptions.contains(option);
            return InkWell(
              onTap: () {
                final newSelection = List<String>.from(selectedOptions);
                if (isSelected) {
                  newSelection.remove(option);
                } else {
                  newSelection.add(option);
                }
                onSelectionChanged(newSelection);
              },
              borderRadius: BorderRadius.circular(20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? color.withOpacity(0.1) : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? color : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    color: isSelected ? color : Colors.grey.shade700,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      alignLabelWithHint: true,
      prefixIcon: Icon(icon, color: Colors.grey.shade400, size: 20),
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}
