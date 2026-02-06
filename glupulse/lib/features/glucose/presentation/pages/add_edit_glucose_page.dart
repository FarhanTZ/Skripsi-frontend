import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glupulse/app/theme/app_theme.dart';
import 'package:glupulse/features/glucose/domain/entities/glucose.dart';
import 'package:glupulse/features/glucose/presentation/cubit/glucose_cubit.dart';
import 'package:intl/intl.dart';

class InputGlucosePage extends StatefulWidget {
  final Glucose? glucose;

  const InputGlucosePage({super.key, this.glucose});

  @override
  State<InputGlucosePage> createState() => _InputGlucosePageState();
}

class _InputGlucosePageState extends State<InputGlucosePage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _glucoseValueController = TextEditingController();
  final _notesController = TextEditingController();
  final _deviceNameController = TextEditingController(); // Controller untuk device name
  final _deviceIdController = TextEditingController(); // Controller untuk device ID
  
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _selectedReadingType = 'random';
  String _selectedSource = 'manual';
  List<String> _selectedSymptoms = [];

  final List<String> _readingTypes = [
    'fasting',
    'pre_meal',
    'post_meal_1h',
    'post_meal_2h',
    'bedtime',
    'overnight',
    'random',
    'exercise',
    'sick_day'
  ];

  final List<String> _sources = [
    'manual',
    'cgm',
    'glucose_meter',
    'lab_test'
  ];

  final List<String> _commonSymptoms = [
    'dizziness',
    'fatigue',
    'thirst',
    'hunger',
    'sweating',
    'headache',
    'nausea',
    'blurred_vision'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.glucose != null) {
      _glucoseValueController.text = widget.glucose!.glucoseValue.toString();
      _notesController.text = widget.glucose!.notes ?? '';
      _deviceNameController.text = widget.glucose!.deviceName ?? ''; // Isi device name jika ada
      _deviceIdController.text = widget.glucose!.deviceId ?? ''; // Isi device ID jika ada
      _selectedDate = widget.glucose!.readingTimestamp;
      _selectedTime = TimeOfDay.fromDateTime(widget.glucose!.readingTimestamp);
      _selectedReadingType = widget.glucose!.readingType;
      _selectedSource = widget.glucose!.source;
      _selectedSymptoms = List.from(widget.glucose!.symptoms ?? []);
    }
  }

  @override
  void dispose() {
    _glucoseValueController.dispose();
    _notesController.dispose();
    _deviceNameController.dispose(); // Jangan lupa dispose controller baru
    _deviceIdController.dispose(); // Jangan lupa dispose controller baru
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _saveGlucose() {
    if (_formKey.currentState!.validate()) {
      final DateTime finalDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      final glucoseValue = int.parse(_glucoseValueController.text);

      final glucose = Glucose(
        readingId: widget.glucose?.readingId, // Pass ID for update
        userId: widget.glucose?.userId,
        glucoseValue: glucoseValue,
        readingTimestamp: finalDateTime,
        readingType: _selectedReadingType,
        source: _selectedSource,
        notes: _notesController.text,
        deviceName: _deviceNameController.text.isNotEmpty ? _deviceNameController.text : null,
        deviceId: _deviceIdController.text.isNotEmpty ? _deviceIdController.text : null,
        symptoms: _selectedSymptoms,
      );

      if (widget.glucose == null) {
        context.read<GlucoseCubit>().addGlucose(glucose);
      } else {
        context.read<GlucoseCubit>().updateGlucose(glucose);
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      appBar: AppBar(
        toolbarHeight: 80,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
        title: Text(
          widget.glucose == null ? 'Input Glucose' : 'Edit Glucose',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                _buildSectionTitle('Glucose Reading'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _glucoseValueController,
                  hintText: 'Value (mg/dL)',
                  icon: Icons.water_drop_outlined,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter glucose value';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),
                _buildSectionTitle('Date & Time'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectDate(context),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.calendar_today,
                                color: Theme.of(context).colorScheme.primary),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none),
                          ),
                          child: Text(
                            DateFormat('yyyy-MM-dd').format(_selectedDate),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectTime(context),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.access_time,
                                color: Theme.of(context).colorScheme.primary),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none),
                          ),
                          child: Text(
                            _selectedTime.format(context),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                _buildSectionTitle('Reading Type'),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedReadingType,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedReadingType = newValue!;
                    });
                  },
                  items: _readingTypes
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value.replaceAll('_', ' ').toUpperCase()),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.category,
                        color: Theme.of(context).colorScheme.primary),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none),
                  ),
                ),

                const SizedBox(height: 24),
                _buildSectionTitle('Source'),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedSource,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedSource = newValue!;
                    });
                  },
                  items: _sources.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value.replaceAll('_', ' ').toUpperCase()),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.source,
                        color: Theme.of(context).colorScheme.primary),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none),
                  ),
                ),

                // --- Conditional Device Name Field ---
                if (_selectedSource == 'cgm' || _selectedSource == 'glucose_meter') ...[
                  const SizedBox(height: 24),
                  _buildSectionTitle('Device Name (Optional)'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _deviceNameController,
                    hintText: 'e.g., Accu-Chek Guide',
                    icon: Icons.devices,
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Device ID (Optional)'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _deviceIdController,
                    hintText: 'e.g., Test123',
                    icon: Icons.tag,
                  ),
                ],

                const SizedBox(height: 24),
                _buildSectionTitle('Symptoms'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: _commonSymptoms.map((symptom) {
                    final isSelected = _selectedSymptoms.contains(symptom);
                    return FilterChip(
                      label: Text(symptom.replaceAll('_', ' ')),
                      selected: isSelected,
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            _selectedSymptoms.add(symptom);
                          } else {
                            _selectedSymptoms.remove(symptom);
                          }
                        });
                      },
                      selectedColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                      checkmarkColor: Theme.of(context).colorScheme.primary,
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),
                _buildSectionTitle('Notes'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _notesController,
                  hintText: 'Additional notes (optional)',
                  icon: Icons.note_alt_outlined,
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: _saveGlucose,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 5,
            ),
            child: const Text(
              'Save Glucose Data',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.black87,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: AppTheme.inputLabelColor),
        prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.primary),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide:
              BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
        ),
      ),
    );
  }
}
