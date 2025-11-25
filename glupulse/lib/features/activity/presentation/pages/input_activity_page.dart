import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glupulse/app/theme/app_theme.dart';
import 'package:glupulse/features/activity/domain/entities/activity_log.dart';
import 'package:glupulse/features/activity/domain/entities/activity_type.dart';
import 'package:glupulse/features/activity/presentation/cubit/activity_cubit.dart';
import 'package:glupulse/features/activity/presentation/cubit/activity_state.dart';
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

    if (widget.activityLog != null) {
      final log = widget.activityLog!;
      _durationController.text = log.durationMinutes.toString();
      _notesController.text = log.notes ?? '';
      _stepsController.text = log.stepsCount?.toString() ?? '';
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

  void _saveActivity(BuildContext context) {
    if (_formKey.currentState!.validate()) {
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
        notes: _notesController.text,
        source: 'manual',
      );

      if (widget.activityLog == null) {
        context.read<ActivityCubit>().addLog(log);
      } else {
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
          return Scaffold(
            backgroundColor: const Color(0xFFF2F5F9),
            appBar: AppBar(
              title: Text(
                widget.activityLog == null ? 'Log Activity' : 'Edit Activity',
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
                      _buildSectionTitle(context, 'Details'),
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
                      TextFormField(
                        controller: _stepsController,
                        keyboardType: TextInputType.number,
                        decoration: _inputDecoration(context, Icons.directions_walk)
                            .copyWith(hintText: 'Steps Count'),
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
                      _buildSectionTitle(context, 'Notes'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _notesController,
                        maxLines: 3,
                        decoration: _inputDecoration(context, Icons.note)
                            .copyWith(hintText: 'Add notes...'),
                      ),
                      
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: state is ActivityLoading
                            ? null
                            : () => _saveActivity(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: state is ActivityLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                'Save Activity',
                                style: TextStyle(
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
