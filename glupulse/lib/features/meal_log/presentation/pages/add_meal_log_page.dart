import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:glupulse/features/meal_log/domain/entities/meal_log.dart';
import 'package:glupulse/app/theme/app_theme.dart';
import 'package:glupulse/features/meal_log/presentation/cubit/meal_log_cubit.dart';

class AddMealLogPage extends StatefulWidget {
  final MealLog? mealLog;

  const AddMealLogPage({super.key, this.mealLog});

  @override
  State<AddMealLogPage> createState() => _AddMealLogPageState();
}

class _AddMealLogPageState extends State<AddMealLogPage> {
  final _formKey = GlobalKey<FormState>();
  late DateTime _mealTimestamp;
  late TimeOfDay _mealTime;
  late TextEditingController _descriptionController;
  late TextEditingController _tagsController;
  int _selectedMealTypeId = 2; // Default Lunch

  // Hardcoded meal types for now
  final List<Map<String, dynamic>> _mealTypes = [
    {'id': 1, 'name': 'Breakfast'},
    {'id': 2, 'name': 'Lunch'},
    {'id': 3, 'name': 'Dinner'},
    {'id': 4, 'name': 'Snack'},
  ];

  @override
  void initState() {
    super.initState();
    _mealTimestamp = widget.mealLog?.mealTimestamp ?? DateTime.now();
    _mealTime = TimeOfDay.fromDateTime(_mealTimestamp);
    _descriptionController = TextEditingController(text: widget.mealLog?.description ?? '');
    _tagsController = TextEditingController(text: widget.mealLog?.tags?.join(', ') ?? '');
    _selectedMealTypeId = widget.mealLog?.mealTypeId ?? 2;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _mealTimestamp,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _mealTimestamp = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _mealTime.hour,
          _mealTime.minute,
        );
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _mealTime,
    );
    if (picked != null) {
      setState(() {
        _mealTime = picked;
        _mealTimestamp = DateTime(
          _mealTimestamp.year,
          _mealTimestamp.month,
          _mealTimestamp.day,
          _mealTime.hour,
          _mealTime.minute,
        );
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final tagsList = _tagsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final newMealLog = MealLog(
        mealId: widget.mealLog?.mealId,
        mealTimestamp: _mealTimestamp,
        mealTypeId: _selectedMealTypeId,
        description: _descriptionController.text,
        tags: tagsList.isEmpty ? null : tagsList,
        items: const [], // Empty items for initial creation
      );

      if (widget.mealLog == null) {
        context.read<MealLogCubit>().addMealLog(newMealLog);
      } else {
         if (newMealLog.mealId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: Cannot update record without an ID.')),
          );
          return;
        }
        context.read<MealLogCubit>().updateMealLog(newMealLog);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      appBar: AppBar(
        toolbarHeight: 80,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        title: Text(widget.mealLog == null ? 'Log Meal' : 'Edit Meal Log'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<MealLogCubit, MealLogState>(
        listener: (context, state) {
          if (state is MealLogAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Meal Log Created Successfully!')),
            );
            Navigator.of(context).pop();
          } else if (state is MealLogUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Meal Log Updated Successfully!')),
            );
            Navigator.of(context).pop();
          } else if (state is MealLogError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          if (state is MealLogLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Date & Time', isMandatory: true),
                  Row(
                    children: [
                      Expanded(child: _buildDateField(context)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildTimeField(context)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  _buildSectionTitle('Meal Type', isMandatory: true),
                  _buildMealTypeDropdown(),
                  const SizedBox(height: 24),

                  _buildSectionTitle('Description', isMandatory: true),
                  _buildTextField(
                    controller: _descriptionController,
                    hintText: 'e.g., Grilled Chicken Salad',
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Please enter a description' : null,
                  ),
                  const SizedBox(height: 24),

                  _buildSectionTitle('Tags'),
                  _buildTextField(
                    controller: _tagsController,
                    hintText: 'e.g., homemade, high-protein (comma separated)',
                  ),
                  const SizedBox(height: 40),

                  Center(
                    child: ElevatedButton(
                      onPressed: state is MealLogLoading ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 5,
                      ),
                      child: state is MealLogLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              widget.mealLog == null ? 'Create Log' : 'Update Log',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title, {bool isMandatory = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: RichText(
        text: TextSpan(
          text: title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          children: [
            if (isMandatory)
              const TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: _inputDecoration(hintText: hintText),
      validator: validator,
    );
  }

  Widget _buildDateField(BuildContext context) {
    return TextFormField(
      readOnly: true,
      decoration: _inputDecoration(
        hintText: DateFormat('yyyy-MM-dd').format(_mealTimestamp),
      ).copyWith(
        prefixIcon: const Icon(Icons.calendar_today),
      ),
      onTap: () => _selectDate(context),
    );
  }

  Widget _buildTimeField(BuildContext context) {
    return TextFormField(
      readOnly: true,
      decoration: _inputDecoration(
        hintText: _mealTime.format(context),
      ).copyWith(
        prefixIcon: const Icon(Icons.access_time),
      ),
      onTap: () => _selectTime(context),
    );
  }

  Widget _buildMealTypeDropdown() {
    return DropdownButtonFormField<int>(
      value: _selectedMealTypeId,
      items: _mealTypes.map((type) {
        return DropdownMenuItem<int>(
          value: type['id'],
          child: Text(type['name']),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedMealTypeId = value;
          });
        }
      },
      decoration: _inputDecoration(hintText: 'Select Meal Type'),
    );
  }

  InputDecoration _inputDecoration({required String hintText}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: AppTheme.inputLabelColor, fontSize: 14),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: Colors.red.shade700, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: Colors.red.shade700, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}
