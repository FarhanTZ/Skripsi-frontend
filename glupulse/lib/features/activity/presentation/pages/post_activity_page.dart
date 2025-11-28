import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glupulse/features/activity/domain/entities/activity_log.dart';
import 'package:glupulse/features/activity/domain/entities/activity_type.dart';
import 'package:glupulse/features/activity/presentation/cubit/activity_cubit.dart';
import 'package:glupulse/features/activity/presentation/cubit/activity_state.dart';
import 'package:glupulse/injection_container.dart';
import 'package:intl/intl.dart';

class PostActivityPage extends StatefulWidget {
  final ActivityType activityType;
  final int actualDurationMinutes;
  final int preActivityCarbs;
  final String? resumeLogId; // Jika ada, berarti update log ini
  final ActivityLog? initialLog; // Data lama untuk pre-fill

  const PostActivityPage({
    super.key,
    required this.activityType,
    required this.actualDurationMinutes,
    this.preActivityCarbs = 0,
    this.resumeLogId,
    this.initialLog,
  });

  @override
  State<PostActivityPage> createState() => _PostActivityPageState();
}

class _PostActivityPageState extends State<PostActivityPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _notesController;
  late TextEditingController _stepsController;
  late TextEditingController _durationController;
  late TextEditingController _waterController;
  late TextEditingController _issueDescriptionController;

  String _selectedIntensity = 'moderate';
  int _perceivedExertion = 5;
  final List<String> _intensityLevels = ['low', 'moderate', 'high'];
  final DateTime _finishedTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: widget.initialLog?.notes ?? '');
    _stepsController = TextEditingController(text: widget.initialLog?.stepsCount?.toString() ?? '');
    _waterController = TextEditingController(text: widget.initialLog?.waterIntakeMl?.toString() ?? '');
    _issueDescriptionController = TextEditingController(text: widget.initialLog?.issueDescription ?? '');
    _durationController = TextEditingController(text: widget.actualDurationMinutes.toString());

    // Default intensity
    if (widget.initialLog != null) {
       _selectedIntensity = widget.initialLog!.intensity;
       _perceivedExertion = widget.initialLog!.perceivedExertion ?? 5;
    } else if (_intensityLevels.contains(widget.activityType.intensityLevel.toLowerCase())) {
      _selectedIntensity = widget.activityType.intensityLevel.toLowerCase();
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    _stepsController.dispose();
    _durationController.dispose();
    _waterController.dispose();
    _issueDescriptionController.dispose();
    super.dispose();
  }

  void _saveLog(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final log = ActivityLog(
        activityId: widget.resumeLogId, // Penting untuk update
        userId: widget.initialLog?.userId, // Pertahankan user ID jika ada
        activityTimestamp: _finishedTime, // Update timestamp ke waktu selesai sesi terakhir? Atau pertahankan awal? Biasanya update ke 'sekarang'.
        activityCode: widget.activityType.activityCode,
        intensity: _selectedIntensity,
        durationMinutes: int.parse(_durationController.text),
        perceivedExertion: _perceivedExertion,
        stepsCount: int.tryParse(_stepsController.text),
        preActivityCarbs: widget.preActivityCarbs,
        waterIntakeMl: int.tryParse(_waterController.text),
        issueDescription: _issueDescriptionController.text.isNotEmpty 
            ? _issueDescriptionController.text 
            : null,
        notes: _notesController.text,
        source: 'manual',
      );

      if (widget.resumeLogId != null) {
        context.read<ActivityCubit>().updateLog(log);
      } else {
        context.read<ActivityCubit>().addLog(log);
      }
    }
  }

  bool _isStepBased(String code) {
    const stepBasedCodes = {
      'WALKING', 'RUNNING', 'HIKING', 'DANCE', 'TEAM_SPORTS', 
      'RACKET_SPORTS', 'HOUSEWORK', 'OCCUPATIONAL',
    };
    return stepBasedCodes.contains(code);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ActivityCubit>(),
      child: BlocConsumer<ActivityCubit, ActivityState>(
        listener: (context, state) {
          if (state is ActivityOperationSuccess) {
            // Pop PostActivityPage
            Navigator.of(context).pop(); 
            // Pop InputActivityPage to return to ActivityLogListPage
            if (Navigator.canPop(context)) {
              Navigator.of(context).pop();
            }
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
              title: const Text('Activity Summary', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              backgroundColor: Theme.of(context).colorScheme.primary,
              iconTheme: const IconThemeData(color: Colors.white),
              automaticallyImplyLeading: false, // Prevent going back to timer
            ),
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Summary Header
                      Center(
                        child: Column(
                          children: [
                            Text(
                              widget.activityType.displayName,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              DateFormat('EEEE, d MMM yyyy • HH:mm').format(_finishedTime),
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Duration Field (Editable)
                      _buildSectionTitle('Duration (Minutes)'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _durationController,
                        keyboardType: TextInputType.number,
                        decoration: _inputDecoration(context, Icons.timer),
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),

                      const SizedBox(height: 24),

                      // Intensity
                      _buildSectionTitle('Intensity Level'),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedIntensity,
                        decoration: _inputDecoration(context, Icons.speed),
                        items: _intensityLevels.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value[0].toUpperCase() + value.substring(1)),
                          );
                        }).toList(),
                        onChanged: (newValue) => setState(() => _selectedIntensity = newValue!),
                      ),

                      const SizedBox(height: 24),

                      // Metrics (Optional)
                      _buildSectionTitle('Metrics'),
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
                      
                      // WATER INTAKE INPUT
                      TextFormField(
                        controller: _waterController,
                        keyboardType: TextInputType.number,
                        decoration: _inputDecoration(context, Icons.local_drink)
                            .copyWith(
                              labelText: 'Water Intake (ml)',
                              hintText: 'Optional (e.g., 500)',
                            ),
                      ),
                      const SizedBox(height: 16),

                      InputDecorator(
                        decoration: _inputDecoration(context, Icons.bolt)
                            .copyWith(labelText: 'Perceived Exertion (1-10)'),
                        child: Column(
                          children: [
                            Slider(
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
                            Text(
                              _getExertionLabel(_perceivedExertion),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Notes
                      _buildSectionTitle('Notes'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _notesController,
                        maxLines: 3,
                        decoration: _inputDecoration(context, Icons.note)
                            .copyWith(hintText: 'How did it feel?'),
                      ),

                      const SizedBox(height: 24),
                      // Issue Description
                      _buildSectionTitle('Issue Description (Optional)'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _issueDescriptionController,
                        maxLines: 2,
                        decoration: _inputDecoration(context, Icons.warning)
                            .copyWith(hintText: 'Any issues (e.g., injury, unusual fatigue)?'),
                      ),
                      
                      const SizedBox(height: 32),

                      ElevatedButton(
                        onPressed: state is ActivityLoading ? null : () => _saveLog(context),
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
                            : const Text('Simpan Activity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

  String _getExertionLabel(int value) {
    if (value <= 3) return 'Ringan / Santai';
    if (value <= 6) return 'Sedang / Agak Lelah';
    if (value <= 8) return 'Berat / Sulit Bicara';
    return 'Maksimal / Sangat Lelah';
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.black87,
        fontSize: 16,
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
