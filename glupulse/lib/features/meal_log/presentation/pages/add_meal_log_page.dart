import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:glupulse/features/meal_log/domain/entities/meal_log.dart';
import 'package:glupulse/features/meal_log/presentation/cubit/meal_log_cubit.dart';
import 'package:glupulse/features/Food/presentation/cubit/food_cubit.dart';
import 'package:glupulse/features/meal_log/presentation/pages/search_food_page.dart';
import 'package:glupulse/injection_container.dart';

class AddMealLogPage extends StatefulWidget {
  final MealLog? mealLog;

  const AddMealLogPage({super.key, this.mealLog});

  @override
  State<AddMealLogPage> createState() => _AddMealLogPageState();
}

class _AddMealLogPageState extends State<AddMealLogPage> {
  final _formKey = GlobalKey<FormState>();
  
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  int _selectedMealTypeId = 2;
  late TextEditingController _descriptionController;
  late TextEditingController _tagsController;
  
  // Local state untuk item makanan yang akan dikirim
  List<MealItem> _selectedItems = [];

  final List<Map<String, dynamic>> _mealTypes = [
    {'id': 1, 'name': 'Breakfast', 'icon': Icons.wb_sunny_outlined},
    {'id': 2, 'name': 'Lunch', 'icon': Icons.lunch_dining_outlined},
    {'id': 3, 'name': 'Dinner', 'icon': Icons.nightlight_round},
    {'id': 4, 'name': 'Snack', 'icon': Icons.local_cafe_outlined},
  ];

  @override
  void initState() {
    super.initState();
    final initialDate = widget.mealLog?.mealTimestamp ?? DateTime.now();
    _selectedDate = initialDate;
    _selectedTime = TimeOfDay.fromDateTime(initialDate);
    
    _selectedMealTypeId = widget.mealLog?.mealTypeId ?? 2;
    _descriptionController = TextEditingController(text: widget.mealLog?.description ?? '');
    _tagsController = TextEditingController(text: widget.mealLog?.tags?.join(', ') ?? '');
    
    // Jika edit mode, fetch detail lengkap dari server untuk mendapatkan items
    if (widget.mealLog?.mealId != null) {
      context.read<MealLogCubit>().getMealLog(widget.mealLog!.mealId!);
    } else if (widget.mealLog?.items != null) {
      // Fallback jika items entah bagaimana sudah ada (misal dari state sebelumnya)
      _selectedItems = List.from(widget.mealLog!.items!);
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }
  
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _selectedTime);
    if (picked != null) setState(() => _selectedTime = picked);
  }

  Future<void> _navigateAndAddFood() async {
    // Navigasi ke SearchFoodPage dan tunggu hasilnya
    final MealItem? result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<FoodCubit>(), // Provide FoodCubit for search
          child: const SearchFoodPage(),
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _selectedItems.add(result);
      });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final finalDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final tags = _tagsController.text.isNotEmpty
        ? _tagsController.text.split(',').map((e) => e.trim()).toList()
        : null;

    final mealLog = MealLog(
      mealId: widget.mealLog?.mealId, // Retain mealId for updates
      mealTimestamp: finalDateTime,
      mealTypeId: _selectedMealTypeId,
      description: _descriptionController.text,
      tags: tags,
      items: _selectedItems, // Send items for both create and update
    );

    if (widget.mealLog == null) {
      context.read<MealLogCubit>().addMealLog(mealLog);
    } else {
      context.read<MealLogCubit>().updateMealLog(mealLog);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(widget.mealLog == null ? 'New Meal Log' : 'Edit Meal Log'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _submit,
            child: const Text('Save', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          )
        ],
      ),
      body: BlocListener<MealLogCubit, MealLogState>(
        listener: (context, state) {
          if (state is MealLogDetailLoaded) {
            // Update state lokal saat detail berhasil diambil
            setState(() {
              _selectedItems = List.from(state.mealLog.items ?? []);
              // Update field lain juga untuk memastikan sinkronisasi data terbaru
              _selectedDate = state.mealLog.mealTimestamp;
              _selectedTime = TimeOfDay.fromDateTime(state.mealLog.mealTimestamp);
              _selectedMealTypeId = state.mealLog.mealTypeId;
              _descriptionController.text = state.mealLog.description ?? '';
              _tagsController.text = state.mealLog.tags?.join(', ') ?? '';
            });
          } else if (state is MealLogAdded || state is MealLogUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Meal log saved successfully!')),
            );
            Navigator.of(context).pop(); // Kembali ke list
          } else if (state is MealLogError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // --- Header (Date, Type, Desc) ---
              _buildSectionHeader('When & What'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: _pickDate,
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                                const SizedBox(width: 8),
                                Text(DateFormat('EEE, dd MMM').format(_selectedDate)),
                              ],
                            ),
                          ),
                        ),
                        Container(width: 1, height: 24, color: Colors.grey.shade300),
                        Expanded(
                          child: InkWell(
                            onTap: _pickTime,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(_selectedTime.format(context)),
                                const SizedBox(width: 8),
                                const Icon(Icons.access_time, size: 18, color: Colors.grey),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    // Meal Type Selector
                    SizedBox(
                      height: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _mealTypes.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final type = _mealTypes[index];
                          final isSelected = _selectedMealTypeId == type['id'];
                          return ChoiceChip(
                            label: Text(type['name']),
                            selected: isSelected,
                            onSelected: (val) => setState(() => _selectedMealTypeId = type['id']),
                            avatar: Icon(type['icon'], size: 16, color: isSelected ? Colors.white : Colors.grey),
                            selectedColor: Theme.of(context).colorScheme.primary,
                            labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        hintText: 'Description (Optional)',
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              _buildSectionHeader('Food Items'),
              const SizedBox(height: 12),
              
              // --- Food Items List ---
              if (_selectedItems.isEmpty)
                _buildEmptyItemsState()
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _selectedItems.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = _selectedItems[index];
                    return _buildFoodItemCard(item, index);
                  },
                ),

              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _navigateAndAddFood,
                icon: const Icon(Icons.add),
                label: const Text('Add Food Item'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              
              // Tag (Optional, bisa dihide kalau terlalu penuh)
              const SizedBox(height: 24),
              _buildSectionHeader('Tags'),
              const SizedBox(height: 8),
              TextField(
                controller: _tagsController,
                decoration: InputDecoration(
                  hintText: 'e.g. healthy, spicy',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyItemsState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, style: BorderStyle.solid), // Dashed border simulation
      ),
      child: Column(
        children: [
          Icon(Icons.fastfood_outlined, size: 40, color: Colors.grey.shade300),
          const SizedBox(height: 8),
          Text('No food items yet', style: TextStyle(color: Colors.grey.shade500)),
        ],
      ),
    );
  }

  Widget _buildFoodItemCard(MealItem item, int index) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.restaurant, color: Colors.orange.shade700, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.foodName, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('${item.calories} kcal • ${item.quantity}x', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
            onPressed: () {
              setState(() {
                _selectedItems.removeAt(index);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
    );
  }
}