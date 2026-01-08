import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:glupulse/features/meal_log/domain/entities/meal_log.dart';
import 'package:glupulse/features/meal_log/presentation/cubit/meal_log_cubit.dart';
import 'package:glupulse/features/Food/presentation/cubit/food_cubit.dart';
import 'package:glupulse/features/meal_log/presentation/pages/search_food_page.dart';
import 'package:glupulse/features/meal_log/presentation/pages/manual_food_input_page.dart';
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
    
    if (widget.mealLog != null) {
      // Jika edit mode, gunakan timestamp dari data yang ada, dikonversi ke lokal
      final localTime = widget.mealLog!.mealTimestamp.toLocal();
      _selectedDate = localTime;
      _selectedTime = TimeOfDay.fromDateTime(localTime);
    } else {
      // Jika mode tambah baru, gunakan waktu sekarang
      final now = DateTime.now();
      _selectedDate = now;
      _selectedTime = TimeOfDay.fromDateTime(now);
    }
    
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

  Widget _buildCustomHeader() {
    final String titleText = widget.mealLog == null ? 'New Meal Log' : 'Edit Meal Log';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Back Button
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          // Title
          Text(
            titleText,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          // Save Button
          Align(
            alignment: Alignment.centerRight,
            child: BlocBuilder<MealLogCubit, MealLogState>(
              builder: (context, state) {
                if (state is MealLogLoading) {
                  return const Padding(
                    padding: EdgeInsets.only(right: 16.0), // Adjust padding if needed
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                }
                return TextButton(
                  onPressed: _submit, // Ensure _submit is accessible
                  child: const Text('Save', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                );
              },
            ),
          ),
        ],
      ),
    );
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
    // Tampilkan dialog pilihan: Search atau Manual
    final method = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const Text(
                  'Add Food Item',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose how you want to add food',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
                const SizedBox(height: 24),
                _buildSelectionCard(
                  context,
                  icon: Icons.search_rounded,
                  color: Colors.blue,
                  title: 'Search Database',
                  subtitle: 'Find foods from our extensive database',
                  onTap: () => Navigator.pop(context, 'search'),
                ),
                const SizedBox(height: 12),
                _buildSelectionCard(
                  context,
                  icon: Icons.edit_note_rounded,
                  color: Colors.orange,
                  title: 'Input Manually',
                  subtitle: 'Enter nutrition details yourself',
                  onTap: () => Navigator.pop(context, 'manual'),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );

    if (method == null) return; // User dismissed sheet

    MealItem? result;

    if (method == 'search') {
      // Navigasi ke SearchFoodPage
      final dynamic navResult = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<FoodCubit>(),
            child: const SearchFoodPage(),
          ),
        ),
      );
      if (navResult is MealItem) {
        result = navResult;
      }
    } else if (method == 'manual') {
      // Navigasi ke ManualFoodInputPage
      final dynamic navResult = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const ManualFoodInputPage(),
        ),
      );
      if (navResult is MealItem) {
        result = navResult;
      }
    }

    if (result != null) {
      setState(() {
        _selectedItems.add(result!);
      });
    }
  }

  void _submit() {
    debugPrint('Save button pressed'); // Debug log

    if (!_formKey.currentState!.validate()) {
      debugPrint('Form validation failed');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fix the errors in the form.')),
      );
      return;
    }

    debugPrint('Form validation passed. Preparing data...');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saving...')),
    );

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
      if (mealLog.mealId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Meal ID is missing for update.')),
        );
        return;
      }
      context.read<MealLogCubit>().updateMealLog(mealLog);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            _buildCustomHeader(), // Custom Header
            Expanded(
              child: BlocListener<MealLogCubit, MealLogState>(
                listener: (context, state) {
                  print('UI LISTENER: Received state $state');
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
                    print('UI LISTENER: Success state received. Popping...');
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
                                                const SizedBox(height: 16),
                                                Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: _buildSectionHeader('Tags'),
                                                ),
                                                const SizedBox(height: 8),
                                                TextField(
                                                  controller: _tagsController,
                                                  decoration: InputDecoration(
                                                    hintText: 'e.g. healthy, spicy',
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                                                  ),
                                                ),                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      _buildSectionHeader('Food Items'),
                      const SizedBox(height: 12),

                      // --- Nutrition Summary ---
                      if (_selectedItems.isNotEmpty) ...[
                        _buildNutritionSummary(),
                        const SizedBox(height: 16),
                      ],
                      
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
                                    FilledButton.icon(
                                      onPressed: _navigateAndAddFood,
                                      icon: const Icon(Icons.add),
                                      label: const Text('Add Food Item'),
                                      style: FilledButton.styleFrom(
                                        minimumSize: const Size(double.infinity, 48),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        foregroundColor: Colors.white, // Ensure icon and text are white for contrast
                                      ),
                                    ),                      
                                          ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionSummary() {
    double totalCal = 0;
    double totalCarbs = 0;
    double totalProt = 0;
    double totalFat = 0;
    double totalFiber = 0;
    double totalSugar = 0;

    for (var item in _selectedItems) {
      final qty = item.quantity;
      totalCal += (item.calories ?? 0) * qty;
      totalCarbs += (item.carbsGrams ?? 0) * qty;
      totalProt += (item.proteinGrams ?? 0) * qty;
      totalFat += (item.fatGrams ?? 0) * qty;
      totalFiber += (item.fiberGrams ?? 0) * qty;
      totalSugar += (item.sugarGrams ?? 0) * qty;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMacroItem('Calories', '${totalCal.toStringAsFixed(0)} kcal'),
              _buildMacroItem('Carbs', '${totalCarbs.toStringAsFixed(1)} g'),
              _buildMacroItem('Protein', '${totalProt.toStringAsFixed(1)} g'),
              _buildMacroItem('Fat', '${totalFat.toStringAsFixed(1)} g'),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMacroItem('Fiber', '${totalFiber.toStringAsFixed(1)} g'),
              _buildMacroItem('Sugar', '${totalSugar.toStringAsFixed(1)} g'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
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
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon Makanan
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.restaurant_menu, color: Colors.orange.shade700, size: 24),
              ),
              const SizedBox(width: 12),
              
              // Nama & Kalori
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.foodName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      // Removed maxLines and overflow to allow text to wrap
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.local_fire_department, size: 14, color: Colors.orange),
                        const SizedBox(width: 4),
                        Text(
                          '${((item.calories ?? 0) * item.quantity).toStringAsFixed(0)} kcal',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Quantity Controls
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () async {
                        if (_selectedItems[index].quantity == 1) {
                          final bool confirmDelete = await showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Delete Item?'),
                              content: Text('Remove "${_selectedItems[index].foodName}"?'),
                              actions: [
                                TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
                                TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
                              ],
                            ),
                          ) ?? false;

                          if (confirmDelete) {
                            setState(() {
                              _selectedItems.removeAt(index);
                            });
                          }
                        } else {
                          setState(() {
                            _selectedItems[index] = _selectedItems[index].copyWith(quantity: _selectedItems[index].quantity - 1);
                          });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.remove, size: 18, color: Colors.grey.shade700),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item.quantity.toStringAsFixed(0),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(width: 4),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _selectedItems[index] = _selectedItems[index].copyWith(quantity: _selectedItems[index].quantity + 1);
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.add, size: 18, color: Colors.green.shade700),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 12),

          // Macros Detail
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDetailItem('Carbs', '${((item.carbsGrams ?? 0) * item.quantity).toStringAsFixed(1)}g', Colors.blue),
              _buildDetailItem('Protein', '${((item.proteinGrams ?? 0) * item.quantity).toStringAsFixed(1)}g', Colors.green),
              _buildDetailItem('Fat', '${((item.fatGrams ?? 0) * item.quantity).toStringAsFixed(1)}g', Colors.orange),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
    );
  }

  Widget _buildSelectionCard(BuildContext context,
      {required IconData icon,
      required Color color,
      required String title,
      required String subtitle,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}
