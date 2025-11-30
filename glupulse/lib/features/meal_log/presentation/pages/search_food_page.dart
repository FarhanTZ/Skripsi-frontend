import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glupulse/features/meal_log/domain/entities/meal_log.dart'; // Untuk MealItem
import 'package:glupulse/features/Food/presentation/cubit/food_cubit.dart';

class SearchFoodPage extends StatefulWidget {
  const SearchFoodPage({super.key});

  @override
  State<SearchFoodPage> createState() => _SearchFoodPageState();
}

class _SearchFoodPageState extends State<SearchFoodPage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    // Trigger load makanan awal
    context.read<FoodCubit>().fetchFoods();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Search food...',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          onChanged: (val) {
            setState(() => _query = val.toLowerCase());
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note),
            tooltip: 'Input Manual',
            onPressed: () => _showManualInputForm(context),
          ),
        ],
      ),
      body: BlocBuilder<FoodCubit, FoodState>(
        builder: (context, state) {
          if (state is FoodLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FoodLoaded) {
            final foods = state.foods.where((food) {
              return food.foodName.toLowerCase().contains(_query);
            }).toList();

            if (foods.isEmpty) {
              return _buildEmptyState();
            }

            return ListView.builder(
              itemCount: foods.length,
              itemBuilder: (context, index) {
                final food = foods[index];
                return ListTile(
                  title: Text(food.foodName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${food.calories} kcal • ${food.carbsGrams}g carbs'),
                  trailing: const Icon(Icons.add_circle_outline, color: Colors.green),
                  onTap: () {
                    // Konversi Food entity (dari FoodCubit) ke MealItem (untuk MealLog)
                    final mealItem = MealItem(
                      foodName: food.foodName,
                      foodId: food.foodId,
                      quantity: 1, // Default 1 serving
                      calories: food.calories,
                      carbsGrams: food.carbsGrams,
                      proteinGrams: food.proteinGrams,
                      fatGrams: food.fatGrams,
                      servingSize: '1 serving', // Placeholder
                      servingSizeGrams: 100, // Placeholder standard
                    );
                    // Kembalikan item yang dipilih ke halaman sebelumnya
                    Navigator.of(context).pop(mealItem);
                  },
                );
              },
            );
          } else if (state is FoodError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showManualInputForm(BuildContext context) {
    final nameController = TextEditingController();
    final calController = TextEditingController();
    final carbController = TextEditingController();
    final protController = TextEditingController();
    final fatController = TextEditingController();
    final fiberController = TextEditingController();
    final sugarController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Custom Food'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Food Name *'),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: TextField(controller: calController, decoration: const InputDecoration(labelText: 'Calories'), keyboardType: TextInputType.number)),
                  const SizedBox(width: 8),
                  Expanded(child: TextField(controller: carbController, decoration: const InputDecoration(labelText: 'Carbs (g)'), keyboardType: TextInputType.number)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: TextField(controller: protController, decoration: const InputDecoration(labelText: 'Protein (g)'), keyboardType: TextInputType.number)),
                  const SizedBox(width: 8),
                  Expanded(child: TextField(controller: fatController, decoration: const InputDecoration(labelText: 'Fat (g)'), keyboardType: TextInputType.number)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: TextField(controller: fiberController, decoration: const InputDecoration(labelText: 'Fiber (g)'), keyboardType: TextInputType.number)),
                  const SizedBox(width: 8),
                  Expanded(child: TextField(controller: sugarController, decoration: const InputDecoration(labelText: 'Sugar (g)'), keyboardType: TextInputType.number)),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isEmpty) return;
              
              final item = MealItem(
                foodName: nameController.text,
                // foodId null menandakan manual/custom food
                quantity: 1,
                calories: num.tryParse(calController.text),
                carbsGrams: num.tryParse(carbController.text),
                proteinGrams: num.tryParse(protController.text),
                fatGrams: num.tryParse(fatController.text),
                fiberGrams: num.tryParse(fiberController.text),
                sugarGrams: num.tryParse(sugarController.text),
                servingSize: '1 serving',
                servingSizeGrams: 100,
              );
              Navigator.pop(ctx); // Tutup dialog
              Navigator.pop(context, item); // Kembali ke AddMealLogPage dengan item
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('No food found', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => _showManualInputForm(context),
            icon: const Icon(Icons.edit_note),
            label: const Text('Add Manually'),
          ),
        ],
      ),
    );
  }
}
