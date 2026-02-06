import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:glupulse/features/sleep_log/domain/entities/sleep_log.dart';
import 'package:glupulse/features/sleep_log/presentation/cubit/sleep_log_cubit.dart';

class AddEditSleepLogPage extends StatefulWidget {
  final SleepLog? sleepLog;
  final DateTime? initialDate;

  const AddEditSleepLogPage({super.key, this.sleepLog, this.initialDate});

  @override
  State<AddEditSleepLogPage> createState() => _AddEditSleepLogPageState();
}

class _AddEditSleepLogPageState extends State<AddEditSleepLogPage> {
  final _formKey = GlobalKey<FormState>();
  late DateTime _sleepDate;
  late DateTime _bedTime;
  late DateTime _wakeTime;
  
  // Controllers
  final _notesController = TextEditingController();
  
  // Advanced Controllers
  final _trackerScoreController = TextEditingController();
  final _deepSleepController = TextEditingController();
  final _remSleepController = TextEditingController();
  final _lightSleepController = TextEditingController();
  final _awakeMinutesController = TextEditingController();
  final _averageHrvController = TextEditingController();
  final _restingHeartRateController = TextEditingController();
  
  double _qualityRating = 3.0; // Default middle
  bool _isAdvancedExpanded = false;
  String _source = 'manual';

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    
    // Default: Sleep Date from widget.initialDate or yesterday/today
    if (widget.sleepLog != null) {
       _sleepDate = DateTime.parse(widget.sleepLog!.sleepDate);
    } else if (widget.initialDate != null) {
       _sleepDate = widget.initialDate!;
    } else {
       _sleepDate = DateTime(now.year, now.month, now.day);
    }
    
    // Bed time default 10 PM on Sleep Date
    _bedTime = widget.sleepLog?.bedTime.toLocal() ?? 
        DateTime(_sleepDate.year, _sleepDate.month, _sleepDate.day, 22, 0);
    
    // Wake time default 7 AM next day
    _wakeTime = widget.sleepLog?.wakeTime.toLocal() ?? 
        DateTime(_sleepDate.year, _sleepDate.month, _sleepDate.day + 1, 7, 0);

    if (widget.sleepLog != null) {
      _qualityRating = (widget.sleepLog!.qualityRating ?? 3).toDouble();
      _notesController.text = widget.sleepLog!.notes ?? '';
      
      // Advanced Fields
      _trackerScoreController.text = widget.sleepLog!.trackerScore?.toString() ?? '';
      _deepSleepController.text = widget.sleepLog!.deepSleepMinutes?.toString() ?? '';
      _remSleepController.text = widget.sleepLog!.remSleepMinutes?.toString() ?? '';
      _lightSleepController.text = widget.sleepLog!.lightSleepMinutes?.toString() ?? '';
      _awakeMinutesController.text = widget.sleepLog!.awakeMinutes?.toString() ?? '';
      _averageHrvController.text = widget.sleepLog!.averageHrv?.toString() ?? '';
      _restingHeartRateController.text = widget.sleepLog!.restingHeartRate?.toString() ?? '';
      _source = widget.sleepLog!.source ?? 'manual';
      
      // Auto expand if there is advanced data
      if (_trackerScoreController.text.isNotEmpty || _deepSleepController.text.isNotEmpty) {
        _isAdvancedExpanded = true;
      }
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    _trackerScoreController.dispose();
    _deepSleepController.dispose();
    _remSleepController.dispose();
    _lightSleepController.dispose();
    _awakeMinutesController.dispose();
    _averageHrvController.dispose();
    _restingHeartRateController.dispose();
    super.dispose();
  }

  String _calculateDuration() {
    final diff = _wakeTime.difference(_bedTime);
    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;
    return '${hours}h ${minutes}m';
  }

  Future<void> _selectTime(BuildContext context, bool isBedTime) async {
    final initialTime = TimeOfDay.fromDateTime(isBedTime ? _bedTime : _wakeTime);
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null) {
      setState(() {
        // Logic to handle dates intelligently
        // If BedTime > WakeTime, assume BedTime is previous day
        
        DateTime baseDate = _sleepDate; // Default to sleep date
        
        // Simple logic: Apply time to today/yesterday logic relative to sleep date
        // Usually sleep date is the "night of".
        // BedTime usually on SleepDate (night). WakeTime usually on SleepDate + 1 (morning).
        
        
        // Update the specific variable
        if (isBedTime) {
          // Keep the date part of _bedTime if possible or reset to relative? 
          // Simplest: Apply HH:MM to the existing _bedTime's date
          _bedTime = DateTime(_bedTime.year, _bedTime.month, _bedTime.day, picked.hour, picked.minute);
        } else {
          _wakeTime = DateTime(_wakeTime.year, _wakeTime.month, _wakeTime.day, picked.hour, picked.minute);
        }
      });
    }
  }
  
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _sleepDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _sleepDate = picked;
        // Reset bed/wake times to align with new date
        _bedTime = DateTime(picked.year, picked.month, picked.day, _bedTime.hour, _bedTime.minute);
        _wakeTime = DateTime(picked.year, picked.month, picked.day + 1, _wakeTime.hour, _wakeTime.minute);
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
        qualityRating: _qualityRating.toInt(),
        trackerScore: int.tryParse(_trackerScoreController.text),
        deepSleepMinutes: int.tryParse(_deepSleepController.text),
        remSleepMinutes: int.tryParse(_remSleepController.text),
        lightSleepMinutes: int.tryParse(_lightSleepController.text),
        awakeMinutes: int.tryParse(_awakeMinutesController.text),
        averageHrv: int.tryParse(_averageHrvController.text),
        restingHeartRate: int.tryParse(_restingHeartRateController.text),
        source: _source,
        notes: _notesController.text,
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
        title: Text(widget.sleepLog == null ? 'Catat Tidur' : 'Edit Tidur'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<SleepLogCubit, SleepLogState>(
        listener: (context, state) {
          if (state is SleepLogAdded || state is SleepLogUpdated) {
            Navigator.of(context).pop();
          } else if (state is SleepLogError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // --- CARD UTAMA (TANGGAL & WAKTU) ---
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
                    ),
                    child: Column(
                      children: [
                        // Tanggal Tidur
                        InkWell(
                          onTap: () => _selectDate(context),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.calendar_today, size: 18, color: Theme.of(context).colorScheme.primary),
                              const SizedBox(width: 8),
                              Text(
                                DateFormat('EEEE, d MMMM yyyy').format(_sleepDate),
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Divider(),
                        ),
                        
                        // Jam Tidur & Bangun
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildTimeBox('Mulai Tidur', _bedTime, true),
                            const Icon(Icons.arrow_forward, color: Colors.grey),
                            _buildTimeBox('Bangun', _wakeTime, false),
                          ],
                        ),
                        const SizedBox(height: 20),
                        
                        // Total Durasi (Auto Calculated)
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.access_time_filled, size: 18, color: Colors.blue),
                              const SizedBox(width: 8),
                              Text(
                                _calculateDuration(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold, 
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.primary
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),

                  // --- CARD KUALITAS & NOTES ---
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Kualitas Tidur', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Slider(
                                value: _qualityRating,
                                min: 1,
                                max: 5,
                                divisions: 4,
                                label: _qualityRating.toInt().toString(),
                                onChanged: (val) => setState(() => _qualityRating = val),
                              ),
                            ),
                            Text(
                              '${_qualityRating.toInt()}/5', 
                              style: TextStyle(
                                fontWeight: FontWeight.bold, 
                                fontSize: 18,
                                color: Theme.of(context).colorScheme.primary
                              )
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text('Catatan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _notesController,
                          decoration: InputDecoration(
                            hintText: 'Mimpi indah? Sering terbangun?',
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          ),
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // --- ADVANCED EXPANDABLE ---
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
                    ),
                    child: ExpansionTile(
                      title: const Text('Data Lanjutan (Optional)', style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: const Text('Deep sleep, REM, HRV, dll.', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      initiallyExpanded: _isAdvancedExpanded,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(child: _buildCompactField(_deepSleepController, 'Deep (min)', Icons.bed)),
                                  const SizedBox(width: 12),
                                  Expanded(child: _buildCompactField(_remSleepController, 'REM (min)', Icons.psychology)),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(child: _buildCompactField(_lightSleepController, 'Light (min)', Icons.light_mode)),
                                  const SizedBox(width: 12),
                                  Expanded(child: _buildCompactField(_awakeMinutesController, 'Awake (min)', Icons.visibility)),
                                ],
                              ),
                              const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider()),
                              Row(
                                children: [
                                  Expanded(child: _buildCompactField(_averageHrvController, 'HRV (ms)', Icons.monitor_heart)),
                                  const SizedBox(width: 12),
                                  Expanded(child: _buildCompactField(_restingHeartRateController, 'Rest HR (bpm)', Icons.favorite)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // --- TOMBOL SIMPAN ---
                  ElevatedButton(
                    onPressed: state is SleepLogLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 4,
                    ),
                    child: state is SleepLogLoading 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('SIMPAN DATA', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeBox(String label, DateTime time, bool isBedTime) {
    return GestureDetector(
      onTap: () => _selectTime(context, isBedTime),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              DateFormat('HH:mm').format(time),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactField(TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 18, color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}