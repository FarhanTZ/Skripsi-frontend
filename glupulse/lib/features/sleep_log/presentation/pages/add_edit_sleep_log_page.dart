import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:glupulse/app/theme/app_theme.dart';
import 'package:glupulse/features/sleep_log/domain/entities/sleep_log.dart';
import 'package:glupulse/features/sleep_log/presentation/cubit/sleep_log_cubit.dart';


class AddEditSleepLogPage extends StatefulWidget {
  final SleepLog? sleepLog;

  const AddEditSleepLogPage({super.key, this.sleepLog});

  @override
  State<AddEditSleepLogPage> createState() => _AddEditSleepLogPageState();
}

class _AddEditSleepLogPageState extends State<AddEditSleepLogPage> {
  final _formKey = GlobalKey<FormState>();
  late DateTime _sleepDate;
  late DateTime _bedTime;
  late DateTime _wakeTime;
  
  // Controllers
  final _qualityRatingController = TextEditingController();
  final _trackerScoreController = TextEditingController();
  final _deepSleepController = TextEditingController();
  final _remSleepController = TextEditingController();
  final _lightSleepController = TextEditingController();
  final _awakeMinutesController = TextEditingController();
  final _averageHrvController = TextEditingController();
  final _restingHeartRateController = TextEditingController();
  final _notesController = TextEditingController();
  
  String _source = 'manual';

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _sleepDate = widget.sleepLog != null 
        ? DateTime.parse(widget.sleepLog!.sleepDate) 
        : DateTime(now.year, now.month, now.day);
    
    _bedTime = widget.sleepLog?.bedTime ?? DateTime(now.year, now.month, now.day, 22, 0);
    _wakeTime = widget.sleepLog?.wakeTime ?? DateTime(now.year, now.month, now.day + 1, 7, 0);

    if (widget.sleepLog != null) {
      _qualityRatingController.text = widget.sleepLog!.qualityRating?.toString() ?? '';
      _trackerScoreController.text = widget.sleepLog!.trackerScore?.toString() ?? '';
      _deepSleepController.text = widget.sleepLog!.deepSleepMinutes?.toString() ?? '';
      _remSleepController.text = widget.sleepLog!.remSleepMinutes?.toString() ?? '';
      _lightSleepController.text = widget.sleepLog!.lightSleepMinutes?.toString() ?? '';
      _awakeMinutesController.text = widget.sleepLog!.awakeMinutes?.toString() ?? '';
      _averageHrvController.text = widget.sleepLog!.averageHrv?.toString() ?? '';
      _restingHeartRateController.text = widget.sleepLog!.restingHeartRate?.toString() ?? '';
      _notesController.text = widget.sleepLog!.notes ?? '';
      _source = widget.sleepLog!.source ?? 'manual';
    }
  }

  @override
  void dispose() {
    _qualityRatingController.dispose();
    _trackerScoreController.dispose();
    _deepSleepController.dispose();
    _remSleepController.dispose();
    _lightSleepController.dispose();
    _awakeMinutesController.dispose();
    _averageHrvController.dispose();
    _restingHeartRateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _sleepDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _sleepDate) {
      setState(() {
        _sleepDate = picked;
        // Adjust bedTime and wakeTime dates if needed, but for now keep them independent or linked?
        // Usually sleep date is the date the sleep started or the main date.
        // Let's keep it simple.
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isBedTime) async {
    final initialTime = TimeOfDay.fromDateTime(isBedTime ? _bedTime : _wakeTime);
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null) {
      setState(() {
        final baseDate = isBedTime ? _bedTime : _wakeTime;
        final newDateTime = DateTime(
          baseDate.year,
          baseDate.month,
          baseDate.day,
          picked.hour,
          picked.minute,
        );
        
        if (isBedTime) {
          _bedTime = newDateTime;
        } else {
          _wakeTime = newDateTime;
        }
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final sleepLog = SleepLog(
        id: widget.sleepLog?.id,
        userId: widget.sleepLog?.userId,
        sleepDate: DateFormat('yyyy-MM-dd').format(_sleepDate),
        bedTime: _bedTime,
        wakeTime: _wakeTime,
        qualityRating: int.tryParse(_qualityRatingController.text),
        trackerScore: int.tryParse(_trackerScoreController.text),
        deepSleepMinutes: int.tryParse(_deepSleepController.text),
        remSleepMinutes: int.tryParse(_remSleepController.text),
        lightSleepMinutes: int.tryParse(_lightSleepController.text),
        awakeMinutes: int.tryParse(_awakeMinutesController.text),
        averageHrv: int.tryParse(_averageHrvController.text),
        restingHeartRate: int.tryParse(_restingHeartRateController.text),
        source: _source,
        notes: _notesController.text,
        // tags: [], // Implement tags if needed
      );

      if (widget.sleepLog == null) {
        context.read<SleepLogCubit>().addSleepLog(sleepLog);
      } else {
        context.read<SleepLogCubit>().updateSleepLog(sleepLog);
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
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
        title: Text(widget.sleepLog == null ? 'Log Sleep' : 'Edit Sleep Log'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<SleepLogCubit, SleepLogState>(
        listener: (context, state) {
          if (state is SleepLogAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Sleep Log added successfully!')),
            );
            Navigator.of(context).pop();
          } else if (state is SleepLogUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Sleep Log updated successfully!')),
            );
            Navigator.of(context).pop();
          } else if (state is SleepLogError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          if (state is SleepLogLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Sleep Date', isMandatory: true),
                  _buildDateField(context),
                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle('Bed Time', isMandatory: true),
                            _buildTimeField(context, true),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle('Wake Time', isMandatory: true),
                            _buildTimeField(context, false),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  _buildSectionTitle('Quality Rating (1-5)'),
                  _buildTextField(
                    controller: _qualityRatingController,
                    hintText: 'e.g. 4',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        final rating = int.tryParse(value);
                        if (rating == null || rating < 1 || rating > 5) {
                          return 'Enter 1-5';
                        }
                      }
                      return null;
                    }
                  ),
                  const SizedBox(height: 24),

                  _buildSectionTitle('Tracker Score (0-100)'),
                  _buildTextField(
                    controller: _trackerScoreController,
                    hintText: 'e.g. 85',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        final score = int.tryParse(value);
                        if (score == null || score < 0 || score > 100) {
                          return 'Enter 0-100';
                        }
                      }
                      return null;
                    }
                  ),
                  const SizedBox(height: 24),

                  _buildSectionTitle('Sleep Stages (Minutes)'),
                  Row(
                    children: [
                      Expanded(child: _buildTextField(controller: _deepSleepController, hintText: 'Deep', keyboardType: TextInputType.number)),
                      const SizedBox(width: 8),
                      Expanded(child: _buildTextField(controller: _remSleepController, hintText: 'REM', keyboardType: TextInputType.number)),
                      const SizedBox(width: 8),
                      Expanded(child: _buildTextField(controller: _lightSleepController, hintText: 'Light', keyboardType: TextInputType.number)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(controller: _awakeMinutesController, hintText: 'Awake Minutes', keyboardType: TextInputType.number),
                  const SizedBox(height: 24),

                  _buildSectionTitle('Biometrics'),
                  Row(
                    children: [
                      Expanded(child: _buildTextField(controller: _averageHrvController, hintText: 'Avg HRV', keyboardType: TextInputType.number)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildTextField(controller: _restingHeartRateController, hintText: 'Resting HR', keyboardType: TextInputType.number)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  _buildSectionTitle('Notes'),
                  _buildTextField(controller: _notesController, hintText: 'How did you sleep?', maxLines: 3),
                  const SizedBox(height: 24),

                  _buildSectionTitle('Source'),
                  DropdownButtonFormField<String>(
                    value: _source,
                    decoration: _inputDecoration(hintText: 'Select Source'),
                    items: const [
                      DropdownMenuItem(value: 'manual', child: Text('Manual Entry')),
                      DropdownMenuItem(value: 'wearable_sync', child: Text('Wearable Sync')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _source = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 40),

                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    child: Text(
                      widget.sleepLog == null ? 'Save Log' : 'Update Log',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
        hintText: DateFormat('yyyy-MM-dd').format(_sleepDate),
      ).copyWith(
        prefixIcon: const Icon(Icons.calendar_today),
      ),
      onTap: () => _selectDate(context),
    );
  }

  Widget _buildTimeField(BuildContext context, bool isBedTime) {
    final time = isBedTime ? _bedTime : _wakeTime;
    return TextFormField(
      readOnly: true,
      decoration: _inputDecoration(
        hintText: DateFormat('HH:mm').format(time),
      ).copyWith(
        prefixIcon: const Icon(Icons.access_time),
      ),
      onTap: () => _selectTime(context, isBedTime),
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}
