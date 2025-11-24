import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:glupulse/features/hba1c/domain/entities/hba1c.dart';
import 'package:glupulse/app/theme/app_theme.dart';
import 'package:glupulse/features/hba1c/presentation/cubit/hba1c_cubit.dart';
import 'package:glupulse/injection_container.dart';

class AddEditHba1cPage extends StatefulWidget {
  final Hba1c? hba1c; // Optional for editing existing record

  const AddEditHba1cPage({super.key, this.hba1c});

  @override
  State<AddEditHba1cPage> createState() => _AddEditHba1cPageState();
}

class _AddEditHba1cPageState extends State<AddEditHba1cPage> {
  final _formKey = GlobalKey<FormState>();
  late DateTime _testDate;
  late TextEditingController _hba1cPercentageController;
  late TextEditingController _estimatedAvgGlucoseController;
  late bool _treatmentChanged;
  late TextEditingController _medicationChangesController;
  late TextEditingController _dietChangesController;
  late TextEditingController _activityChangesController;
  late TextEditingController _notesController;
  late TextEditingController _documentUrlController;

  @override
  void initState() {
    super.initState();
    _testDate = widget.hba1c?.testDate ?? DateTime.now();
    _hba1cPercentageController = TextEditingController(
        text: widget.hba1c?.hba1cPercentage.toString() ?? '');
    _estimatedAvgGlucoseController = TextEditingController(
        text: widget.hba1c?.estimatedAvgGlucose?.toString() ?? '');
    _treatmentChanged = widget.hba1c?.treatmentChanged ?? false;
    _medicationChangesController =
        TextEditingController(text: widget.hba1c?.medicationChanges ?? '');
    _dietChangesController =
        TextEditingController(text: widget.hba1c?.dietChanges ?? '');
    _activityChangesController =
        TextEditingController(text: widget.hba1c?.activityChanges ?? '');
    _notesController = TextEditingController(text: widget.hba1c?.notes ?? '');
    _documentUrlController =
        TextEditingController(text: widget.hba1c?.documentUrl ?? '');
  }

  @override
  void dispose() {
    _hba1cPercentageController.dispose();
    _estimatedAvgGlucoseController.dispose();
    _medicationChangesController.dispose();
    _dietChangesController.dispose();
    _activityChangesController.dispose();
    _notesController.dispose();
    _documentUrlController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _testDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _testDate) {
      setState(() {
        _testDate = picked;
      });
    }
  }

  void _submitForm() {
    print('[_submitForm] method called.');
    if (_formKey.currentState!.validate()) {
      print('[_submitForm] Form validation successful.');
      final newHba1c = Hba1c(
        id: widget.hba1c?.id,
        testDate: _testDate,
        hba1cPercentage: double.parse(_hba1cPercentageController.text),
        estimatedAvgGlucose:
            int.tryParse(_estimatedAvgGlucoseController.text),
        treatmentChanged: _treatmentChanged,
        medicationChanges: _medicationChangesController.text.isEmpty
            ? null
            : _medicationChangesController.text,
        dietChanges: _dietChangesController.text.isEmpty
            ? null
            : _dietChangesController.text,
        activityChanges: _activityChangesController.text.isEmpty
            ? null
            : _activityChangesController.text,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        documentUrl: _documentUrlController.text.isEmpty
            ? null
            : _documentUrlController.text,
      );

      if (widget.hba1c == null) {
        print('[_submitForm] Calling addHba1c with data: $newHba1c');
        context.read<Hba1cCubit>().addHba1c(newHba1c);
      } else {
        // Validasi penting untuk operasi update
        if (newHba1c.id == null) {
          print('[_submitForm] Error: ID is null for an update operation.');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: Cannot update record without an ID.')),
          );
          return; // Hentikan eksekusi jika ID null
        }
        print('[_submitForm] Calling updateHba1c with data: $newHba1c');
        context.read<Hba1cCubit>().updateHba1c(newHba1c);
      }
    } else {
      print('[_submitForm] Form validation failed.');
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
        title: Text(widget.hba1c == null ? 'Add Hba1c Record' : 'Edit Hba1c Record'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<Hba1cCubit, Hba1cState>(
        listener: (context, state) {
          if (state is Hba1cAdded) {
            print('[BlocConsumer] Hba1cAdded state received.');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Hba1c Record Added Successfully!')),
            );
            Navigator.of(context).pop();
          } else if (state is Hba1cUpdated) {
            print('[BlocConsumer] Hba1cUpdated state received.');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Hba1c Record Updated Successfully!')),
            );
            Navigator.of(context).pop();
          } else if (state is Hba1cError) {
            print('[BlocConsumer] Hba1cError state received: ${state.message}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          if (state is Hba1cLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Test Date', isMandatory: true),
                  _buildDateField(context),
                  const SizedBox(height: 24),

                  _buildSectionTitle('Hba1c Percentage (%)', isMandatory: true),
                  _buildTextField(
                      controller: _hba1cPercentageController,
                      hintText: 'e.g., 7.5',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter Hba1c percentage';
                        if (double.tryParse(value) == null) return 'Please enter a valid number';
                        return null;
                      }),
                  const SizedBox(height: 24),

                  _buildSectionTitle('Estimated Average Glucose'),
                  _buildTextField(
                      controller: _estimatedAvgGlucoseController,
                      hintText: 'e.g., 169',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != null && value.isNotEmpty && int.tryParse(value) == null) {
                          return 'Please enter a valid integer';
                        }
                        return null;
                      }),
                  const SizedBox(height: 24),

                  _buildSectionTitle('Medication Changes'),
                  _buildTextField(controller: _medicationChangesController, hintText: 'e.g., increased metformin', maxLines: 3),
                  const SizedBox(height: 24),

                  _buildSectionTitle('Diet Changes'),
                  _buildTextField(controller: _dietChangesController, hintText: 'e.g., reduced sugar intake', maxLines: 3),
                  const SizedBox(height: 24),

                  _buildSectionTitle('Activity Changes'),
                  _buildTextField(controller: _activityChangesController, hintText: 'e.g., started walking 30 mins/day', maxLines: 3),
                  const SizedBox(height: 24),

                  _buildSectionTitle('Notes'),
                  _buildTextField(controller: _notesController, hintText: 'Additional notes...', maxLines: 3),
                  const SizedBox(height: 24),

                  _buildSectionTitle('Document URL'),
                  _buildTextField(controller: _documentUrlController, hintText: 'https://example.com/doc.pdf'),
                  const SizedBox(height: 24),

                  _buildSettingSwitchTile(
                      title: 'Treatment Changed',
                      value: _treatmentChanged,
                      onChanged: (value) => setState(() => _treatmentChanged = value)),
                  const SizedBox(height: 40),

                  Center(
                    child: ElevatedButton(
                      onPressed: state is Hba1cLoading ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 5,
                      ),
                      child: state is Hba1cLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              widget.hba1c == null ? 'Add Record' : 'Update Record',
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
        hintText: DateFormat('yyyy-MM-dd').format(_testDate),
      ).copyWith(
        prefixIcon: const Icon(Icons.calendar_today),
      ),
      onTap: () => _selectDate(context),
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
