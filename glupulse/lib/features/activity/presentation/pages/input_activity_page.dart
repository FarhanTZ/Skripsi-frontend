import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glupulse/features/activity/domain/entities/activity_log.dart';
import 'package:glupulse/features/activity/domain/entities/activity_type.dart';
import 'package:glupulse/features/activity/presentation/cubit/activity_cubit.dart';
import 'package:glupulse/features/activity/presentation/cubit/activity_state.dart';
import 'package:glupulse/features/activity/presentation/pages/active_session_page.dart'; // Import Halaman Baru
import 'package:glupulse/injection_container.dart';
import 'package:intl/intl.dart';

class InputActivityPage extends StatefulWidget {
  final ActivityType activityType;
  final ActivityLog? activityLog;

  const InputActivityPage({
    super.key,
    required this.activityType,
    this.activityLog,
  });

  @override
  State<InputActivityPage> createState() => _InputActivityPageState();
}

class _InputActivityPageState extends State<InputActivityPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _durationController;
  late TextEditingController _notesController;
  late TextEditingController _stepsController;
  late TextEditingController _carbsController;
  late TextEditingController _waterController; // New for Edit
  late TextEditingController _issueController; // New for Edit

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _selectedIntensity = 'moderate';
  int _perceivedExertion = 5;

  final List<String> _intensityLevels = ['low', 'moderate', 'high'];

  @override
  void initState() {
    super.initState();
    _durationController = TextEditingController();
    _notesController = TextEditingController();
    _stepsController = TextEditingController();
    _carbsController = TextEditingController();
    _waterController = TextEditingController(); // Init
    _issueController = TextEditingController(); // Init

    // Set default intensity from ActivityType
    if (_intensityLevels.contains(widget.activityType.intensityLevel.toLowerCase())) {
      _selectedIntensity = widget.activityType.intensityLevel.toLowerCase();
    }

    if (widget.activityLog != null) {
      final log = widget.activityLog!;
      _durationController.text = log.durationMinutes.toString();
      _notesController.text = log.notes ?? '';
      _stepsController.text = log.stepsCount?.toString() ?? '';
      _carbsController.text = log.preActivityCarbs?.toString() ?? '';
      _waterController.text = log.waterIntakeMl?.toString() ?? ''; // Load
      _issueController.text = log.issueDescription ?? ''; // Load
      
      _selectedDate = log.activityTimestamp;
      _selectedTime = TimeOfDay.fromDateTime(log.activityTimestamp);
      _selectedIntensity = log.intensity;
      _perceivedExertion = log.perceivedExertion ?? 5;
    }
  }

  @override
  void dispose() {
    _durationController.dispose();
    _notesController.dispose();
    _stepsController.dispose();
    _carbsController.dispose();
    _waterController.dispose(); // Dispose
    _issueController.dispose(); // Dispose
    super.dispose();
  }

  // ... (kode date picker tetap sama) ...

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


  void _onMainActionPressed(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      // JIKA LOG BARU -> START SESSION
      if (widget.activityLog == null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ActiveSessionPage(
              activityType: widget.activityType,
              targetDurationMinutes: int.parse(_durationController.text),
              preActivityCarbs: int.tryParse(_carbsController.text) ?? 0,
            ),
          ),
        );
      } 
      // JIKA EDIT LOG LAMA -> LANGSUNG UPDATE (Manual)
      else {
        final DateTime finalDateTime = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          _selectedTime.hour,
          _selectedTime.minute,
        );

        final log = ActivityLog(
          activityId: widget.activityLog?.activityId,
          userId: widget.activityLog?.userId,
          activityTimestamp: finalDateTime,
          activityCode: widget.activityType.activityCode,
          intensity: _selectedIntensity,
          durationMinutes: int.parse(_durationController.text),
          perceivedExertion: _perceivedExertion,
          stepsCount: int.tryParse(_stepsController.text),
          preActivityCarbs: int.tryParse(_carbsController.text),
          waterIntakeMl: int.tryParse(_waterController.text),
          issueDescription: _issueController.text.isNotEmpty ? _issueController.text : null,
          notes: _notesController.text,
          source: 'manual',
        );

        context.read<ActivityCubit>().updateLog(log);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ActivityCubit>(),
      child: BlocConsumer<ActivityCubit, ActivityState>(
        listener: (context, state) {
          if (state is ActivityOperationSuccess) {
            Navigator.pop(context);
          } else if (state is ActivityError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          final isManual = widget.activityLog != null;

          return Scaffold(
            backgroundColor: const Color(0xFFF2F5F9),
            appBar: AppBar(
              title: Text(
                isManual ? 'Edit Activity' : 'Setup Activity',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
              iconTheme: const IconThemeData(color: Colors.white),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
            ),
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        widget.activityType.displayName,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      
                      // --- JIKA MANUAL (Edit) TAMPILKAN DATE/TIME ---
                      if (isManual) ...[
                        _buildSectionTitle(context, 'Date & Time'),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () => _selectDate(context),
                                child: InputDecorator(
                                  decoration: _inputDecoration(context, Icons.calendar_today),
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
                                  decoration: _inputDecoration(context, Icons.access_time),
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
                      ],

                      // --- TARGET DURATION (Selalu Ada) ---
                      _buildSectionTitle(context, isManual ? 'Details' : 'Target Duration'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _durationController,
                        keyboardType: TextInputType.number,
                        decoration: _inputDecoration(context, Icons.timer)
                            .copyWith(hintText: 'Duration (minutes)'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter duration';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Enter a valid number';
                          }
                          return null;
                        },
                      ),

                      // --- INPUT PRE-ACTIVITY CARBS (Optional) ---
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _carbsController,
                        keyboardType: TextInputType.number,
                        decoration: _inputDecoration(context, Icons.restaurant)
                            .copyWith(
                              labelText: 'Pre-Activity Carbs (grams)',
                              hintText: 'Optional (e.g., 15)',
                            ),
                      ),
                      
                      // --- SEMUA FIELD DI BAWAH INI HANYA MUNCUL JIKA MODE MANUAL (Edit Log Lama) ---
                      if (isManual) ...[
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedIntensity,
                          decoration: _inputDecoration(context, Icons.speed),
                          items: _intensityLevels.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value[0].toUpperCase() + value.substring(1)),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedIntensity = newValue!;
                            });
                          },
                        ),
                        
                        const SizedBox(height: 24),
                        _buildSectionTitle(context, 'Metrics (Optional)'),
                        const SizedBox(height: 8),
                        if (_isStepBased(widget.activityType.activityCode)) ...[
                          TextFormField(
                            controller: _stepsController,
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration(context, Icons.directions_walk)
                                .copyWith(hintText: 'Steps Count'),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // --- WATER INTAKE ---
                        TextFormField(
                          controller: _waterController,
                          keyboardType: TextInputType.number,
                          decoration: _inputDecoration(context, Icons.local_drink)
                              .copyWith(labelText: 'Water Intake (ml)', hintText: 'e.g., 500'),
                        ),
                        const SizedBox(height: 16),

                        InputDecorator(
                          decoration: _inputDecoration(context, Icons.bolt)
                              .copyWith(labelText: 'Perceived Exertion (1-10)'),
                          child: Slider(
                            value: _perceivedExertion.toDouble(),
                            min: 1,
                            max: 10,
                            divisions: 9,
                            label: _perceivedExertion.toString(),
                            onChanged: (double value) {
                              setState(() {
                                _perceivedExertion = value.toInt();
                              });
                            },
                          ),
                        ),

                        const SizedBox(height: 24),
                        // --- ISSUE DESCRIPTION ---
                        _buildSectionTitle(context, 'Issue Description'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _issueController,
                          maxLines: 2,
                          decoration: _inputDecoration(context, Icons.warning)
                              .copyWith(hintText: 'Any issues (e.g., injury)?'),
                        ),

                        const SizedBox(height: 24),
                        _buildSectionTitle(context, 'Notes'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _notesController,
                          maxLines: 3,
                          decoration: _inputDecoration(context, Icons.note)
                              .copyWith(hintText: 'Add notes...'),
                        ),
                      ], // END IF MANUAL
                      
                      const SizedBox(height: 32),
                      
                      // --- TOMBOL UTAMA ---
                      ElevatedButton(
                        onPressed: state is ActivityLoading
                            ? null
                            : () => _onMainActionPressed(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isManual ? Theme.of(context).colorScheme.primary : Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: state is ActivityLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                                isManual ? 'Update Activity' : 'START ACTIVITY',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  bool _isStepBased(String code) {
    const stepBasedCodes = {
      'WALKING',
      'RUNNING',
      'HIKING',
      'DANCE',
      'TEAM_SPORTS',
      'RACKET_SPORTS',
      'HOUSEWORK',
      'OCCUPATIONAL',
    };
    return stepBasedCodes.contains(code);
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.black87,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  InputDecoration _inputDecoration(BuildContext context, IconData icon) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.primary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }
}
