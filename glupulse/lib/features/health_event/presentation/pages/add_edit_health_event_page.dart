import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:glupulse/features/health_event/domain/entities/health_event.dart';
import 'package:glupulse/app/theme/app_theme.dart';
import 'package:glupulse/features/health_event/presentation/cubit/health_event_cubit.dart';

class AddEditHealthEventPage extends StatefulWidget {
  final HealthEvent? healthEvent; // Optional for editing existing record

  const AddEditHealthEventPage({super.key, this.healthEvent});

  @override
  State<AddEditHealthEventPage> createState() => _AddEditHealthEventPageState();
}

class _AddEditHealthEventPageState extends State<AddEditHealthEventPage> {
  final _formKey = GlobalKey<FormState>();
  late DateTime _eventDate;
  late String _eventType;
  late String _severity;
  late TextEditingController _glucoseValueController;
  late TextEditingController _ketoneValueMmolController;
  late TextEditingController _symptomsController;
  late TextEditingController _treatmentsController;
  late bool _requiredMedicalAttention;
  late TextEditingController _notesController;

  final List<String> _eventTypes = [
    'hypoglycemia',
    'hyperglycemia',
    'illness',
    'other'
  ];
  final List<String> _severities = ['mild', 'moderate', 'severe', 'critical'];

  @override
  void initState() {
    super.initState();
    _eventDate = widget.healthEvent?.eventDate ?? DateTime.now();
    _eventType = widget.healthEvent?.eventType ?? _eventTypes.first;
    _severity = widget.healthEvent?.severity ?? _severities.first;
    _glucoseValueController = TextEditingController(
        text: widget.healthEvent?.glucoseValue?.toString() ?? '');
    _ketoneValueMmolController = TextEditingController(
        text: widget.healthEvent?.ketoneValueMmol?.toString() ?? '');
    _symptomsController = TextEditingController(
        text: widget.healthEvent?.symptoms.join(', ') ?? '');
    _treatmentsController = TextEditingController(
        text: widget.healthEvent?.treatments.join(', ') ?? '');
    _requiredMedicalAttention =
        widget.healthEvent?.requiredMedicalAttention ?? false;
    _notesController = TextEditingController(text: widget.healthEvent?.notes ?? '');
  }

  @override
  void dispose() {
    _glucoseValueController.dispose();
    _ketoneValueMmolController.dispose();
    _symptomsController.dispose();
    _treatmentsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _eventDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _eventDate) {
      setState(() {
        _eventDate = picked;
      });
    }
  }

  void _submitForm() {
    debugPrint('[_submitForm] method called.');
    if (_formKey.currentState!.validate()) {
      debugPrint('[_submitForm] Form validation successful.');
      final newHealthEvent = HealthEvent(
        id: widget.healthEvent?.id,
        eventDate: _eventDate,
        eventType: _eventType,
        severity: _severity,
        glucoseValue: int.tryParse(_glucoseValueController.text) ?? 0,
        ketoneValueMmol: double.tryParse(_ketoneValueMmolController.text) ?? 0.0,
        symptoms: _symptomsController.text
            .split(',')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList(),
        treatments: _treatmentsController.text
            .split(',')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList(),
        requiredMedicalAttention: _requiredMedicalAttention,
        notes: _notesController.text,
      );

      if (widget.healthEvent == null) {
        debugPrint('[_submitForm] Calling addHealthEvent with data: $newHealthEvent');
        context.read<HealthEventCubit>().addHealthEvent(newHealthEvent);
      } else {
        debugPrint('[_submitForm] Calling updateHealthEvent with data: $newHealthEvent');
        context.read<HealthEventCubit>().updateHealthEvent(newHealthEvent);
      }
    } else {
      debugPrint('[_submitForm] Form validation failed.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9), // Latar belakang abu-abu muda
      appBar: AppBar(
        toolbarHeight: 80,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        title: Text(widget.healthEvent == null
            ? 'Add Health Event'
            : 'Edit Health Event'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<HealthEventCubit, HealthEventState>(
        listener: (context, state) {
          if (state is HealthEventAdded) {
            debugPrint('[BlocConsumer] HealthEventAdded state received.');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Health Event Added Successfully!')),
            );
            Navigator.of(context).pop();
          } else if (state is HealthEventUpdated) {
            debugPrint('[BlocConsumer] HealthEventUpdated state received.');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Health Event Updated Successfully!')),
            );
            Navigator.of(context).pop();
          } else if (state is HealthEventError) {
            debugPrint('[BlocConsumer] HealthEventError state received: ${state.message}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          if (state is HealthEventLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Event Date', isMandatory: true),
                  _buildDateField(context),
                  const SizedBox(height: 24),

                  _buildSectionTitle('Event Type', isMandatory: true),
                  _buildDropdown(
                      value: _eventType,
                      items: _eventTypes,
                      onChanged: (value) => setState(() => _eventType = value!),
                      validator: (value) => (value == null || value.isEmpty) ? 'Please select an event type' : null),
                  const SizedBox(height: 24),

                  _buildSectionTitle('Severity', isMandatory: true),
                  _buildDropdown(
                      value: _severity,
                      items: _severities,
                      onChanged: (value) => setState(() => _severity = value!),
                      validator: (value) => (value == null || value.isEmpty) ? 'Please select a severity level' : null),
                  const SizedBox(height: 24),

                  _buildSectionTitle('Glucose Value (mg/dL)',
                      isMandatory: _eventType == 'hypoglycemia' || _eventType == 'hyperglycemia'),
                  _buildTextField(
                      controller: _glucoseValueController,
                      hintText: 'e.g., 120',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        bool isMandatory = _eventType == 'hypoglycemia' || _eventType == 'hyperglycemia';
                        if (isMandatory && (value == null || value.isEmpty)) {
                          return 'Glucose Value is mandatory for $_eventType';
                        }
                        if (value != null && value.isNotEmpty && int.tryParse(value) == null) {
                          return 'Please enter a valid integer';
                        }
                        return null;
                      }),
                  const SizedBox(height: 24),

                  _buildSectionTitle('Ketone Value (mmol)',
                      isMandatory: _eventType == 'hypoglycemia' || _eventType == 'hyperglycemia'),
                  _buildTextField(
                      controller: _ketoneValueMmolController,
                      hintText: 'e.g., 1.5',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        bool isMandatory = _eventType == 'hypoglycemia' || _eventType == 'hyperglycemia';
                        if (isMandatory && (value == null || value.isEmpty)) {
                          return 'Ketone Value is mandatory for $_eventType';
                        }
                        if (value != null && value.isNotEmpty && double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      }),
                  const SizedBox(height: 24),

                  _buildSectionTitle('Symptoms', isMandatory: true),
                  _buildTextField(
                      controller: _symptomsController,
                      hintText: 'e.g., fever, nausea (comma-separated)',
                      maxLines: 3,
                      validator: (value) => (value == null || value.isEmpty) ? 'Please enter symptoms' : null),
                  const SizedBox(height: 24),

                  _buildSectionTitle('Treatments', isMandatory: true),
                  _buildTextField(
                      controller: _treatmentsController,
                      hintText: 'e.g., ibuprofen, fluids (comma-separated)',
                      maxLines: 3,
                      validator: (value) => (value == null || value.isEmpty) ? 'Please enter treatments' : null),
                  const SizedBox(height: 24),

                  _buildSectionTitle('Notes'),
                  _buildTextField(controller: _notesController, hintText: 'Additional notes...', maxLines: 3),
                  const SizedBox(height: 24),

                  _buildSettingSwitchTile(
                      title: 'Required Medical Attention',
                      value: _requiredMedicalAttention,
                      onChanged: (value) => setState(() => _requiredMedicalAttention = value)),
                  const SizedBox(height: 40),

                  Center(
                    child: ElevatedButton(
                      onPressed: state is HealthEventLoading ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 5,
                      ),
                      child: state is HealthEventLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              widget.healthEvent == null ? 'Add Event' : 'Update Event',
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

  // --- WIDGET HELPERS (Copied from edit_health_profile_page.dart) ---

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
        hintText: DateFormat('yyyy-MM-dd').format(_eventDate),
      ).copyWith(
        prefixIcon: const Icon(Icons.calendar_today),
      ),
      onTap: () => _selectDate(context),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: _inputDecoration(hintText: ''),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
      isExpanded: true,
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

  Widget _buildSettingSwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
