import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:glupulse/app/theme/app_theme.dart';
import 'package:glupulse/features/medication/domain/entities/medication.dart';
import 'package:glupulse/features/medication/domain/entities/medication_log.dart';
import 'package:glupulse/features/medication/presentation/cubit/medication_cubit.dart';
import 'package:glupulse/features/medication/presentation/cubit/medication_log_cubit.dart';
import 'package:glupulse/features/medication/presentation/pages/add_edit_medication_page.dart';

class AddEditMedicationLogPage extends StatefulWidget {
  final MedicationLog? log;

  const AddEditMedicationLogPage({super.key, this.log});

  @override
  State<AddEditMedicationLogPage> createState() => _AddEditMedicationLogPageState();
}

class _AddEditMedicationLogPageState extends State<AddEditMedicationLogPage> {
  final _formKey = GlobalKey<FormState>();
  late DateTime _timestamp;
  
  // Form fields
  int? _selectedMedicationId;
  final _doseController = TextEditingController();
  String _reason = 'medication_schedule';
  bool _isPumpDelivery = false;
  final _durationController = TextEditingController(text: '0');
  final _notesController = TextEditingController();

  final List<Map<String, String>> _reasons = [
    {'value': 'medication_schedule', 'label': 'Scheduled'},
    {'value': 'meal_bolus', 'label': 'Meal Bolus'},
    {'value': 'correction', 'label': 'Correction'},
    {'value': 'basal', 'label': 'Basal'},
  ];

  @override
  void initState() {
    super.initState();
    _timestamp = widget.log?.timestamp ?? DateTime.now();
    if (widget.log != null) {
      _selectedMedicationId = widget.log!.medicationId;
      _doseController.text = widget.log!.doseAmount.toString();
      _reason = widget.log!.reason;
      _isPumpDelivery = widget.log!.isPumpDelivery;
      _durationController.text = widget.log!.deliveryDurationMinutes.toString();
      _notesController.text = widget.log!.notes ?? '';
    }

    // Load medications to populate dropdown
    context.read<MedicationCubit>().fetchMedications();
  }

  @override
  void dispose() {
    _doseController.dispose();
    _durationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: _timestamp,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_timestamp),
    );
    if (time == null) return;

    setState(() {
      _timestamp = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final log = MedicationLog(
        id: widget.log?.id,
        userId: widget.log?.userId,
        medicationId: _selectedMedicationId!,
        timestamp: _timestamp,
        doseAmount: double.parse(_doseController.text),
        reason: _reason,
        isPumpDelivery: _isPumpDelivery,
        deliveryDurationMinutes: int.tryParse(_durationController.text) ?? 0,
        notes: _notesController.text,
      );

      if (widget.log == null) {
        context.read<MedicationLogCubit>().createMedicationLog(log);
      } else {
        context.read<MedicationLogCubit>().editMedicationLog(log);
      }
    }
  }

  void _navigateToAddMedication() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AddEditMedicationPage()),
    );
    if (result == true) {
      context.read<MedicationCubit>().fetchMedications();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      appBar: AppBar(
        title: Text(widget.log == null ? 'Log Medication' : 'Edit Log'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<MedicationLogCubit, MedicationLogState>(
        listener: (context, state) {
          if (state is MedicationLogSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Log saved successfully!')),
            );
            Navigator.of(context).pop();
          } else if (state is MedicationLogError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        builder: (context, logState) {
          if (logState is MedicationLogLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Medication Selection ---
                  _buildSectionTitle('Medication', isMandatory: true),
                  BlocBuilder<MedicationCubit, MedicationState>(
                    builder: (context, medState) {
                      if (medState is MedicationLoading) {
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: LinearProgressIndicator(),
                        );
                      }
                      
                      List<Medication> medications = [];
                      if (medState is MedicationLoaded) {
                        medications = medState.medications;
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (medications.isEmpty && medState is MedicationLoaded)
                             Container(
                               padding: const EdgeInsets.all(12),
                               decoration: BoxDecoration(
                                 color: Colors.orange.shade50,
                                 borderRadius: BorderRadius.circular(8),
                                 border: Border.all(color: Colors.orange.shade200)
                               ),
                               child: const Text('No medications found. Please add one first.', style: TextStyle(color: Colors.orange)),
                             ),
                          
                          const SizedBox(height: 8),
                          
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<int>(
                                  value: _selectedMedicationId,
                                  isExpanded: true,
                                  decoration: _inputDecoration(hintText: 'Select Medication'),
                                  items: medications.map((med) {
                                    return DropdownMenuItem(
                                      value: med.id,
                                      child: Text('${med.displayName} (${med.defaultDoseUnit})'),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() => _selectedMedicationId = value);
                                  },
                                  validator: (value) => value == null ? 'Required' : null,
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                onPressed: _navigateToAddMedication, 
                                icon: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(8)
                                  ),
                                  child: const Icon(Icons.add, color: Colors.white),
                                ),
                                tooltip: 'Add New Medication',
                              )
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // --- Date & Time ---
                  _buildSectionTitle('Time', isMandatory: true),
                  TextFormField(
                    readOnly: true,
                    decoration: _inputDecoration(hintText: DateFormat('yyyy-MM-dd HH:mm').format(_timestamp))
                        .copyWith(prefixIcon: const Icon(Icons.access_time)),
                    onTap: () => _selectDateTime(context),
                  ),
                  const SizedBox(height: 24),

                  // --- Dose & Reason ---
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle('Dose', isMandatory: true),
                            TextFormField(
                              controller: _doseController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: _inputDecoration(hintText: 'Amount'),
                              validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle('Reason'),
                            DropdownButtonFormField<String>(
                              value: _reason,
                              isExpanded: true,
                              decoration: _inputDecoration(hintText: 'Reason'),
                              items: _reasons.map((r) => DropdownMenuItem(value: r['value'], child: Text(r['label']!))).toList(),
                              onChanged: (val) => setState(() => _reason = val!),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // --- Pump Delivery ---
                  SwitchListTile(
                    title: const Text('Pump Delivery?'),
                    subtitle: const Text('Only for insulin pump users'),
                    value: _isPumpDelivery,
                    onChanged: (val) => setState(() => _isPumpDelivery = val),
                    activeColor: Theme.of(context).colorScheme.primary,
                    contentPadding: EdgeInsets.zero,
                  ),
                  
                  if (_isPumpDelivery) ...[
                    const SizedBox(height: 12),
                    _buildSectionTitle('Duration (Minutes)'),
                    TextFormField(
                      controller: _durationController,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration(hintText: '0'),
                    ),
                  ],
                  const SizedBox(height: 24),

                  // --- Notes ---
                  _buildSectionTitle('Notes'),
                  TextFormField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: _inputDecoration(hintText: 'Any side effects or context...'),
                  ),
                  const SizedBox(height: 40),

                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                    ),
                    child: Text(widget.log == null ? 'Save Log' : 'Update Log', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
          style: const TextStyle(fontFamily: 'Poppins', color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
          children: [
            if (isMandatory) const TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({required String hintText}) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Colors.grey.shade300)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Colors.grey.shade300)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}
