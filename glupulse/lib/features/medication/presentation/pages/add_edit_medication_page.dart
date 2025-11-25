import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glupulse/features/medication/domain/entities/medication.dart';
import 'package:glupulse/features/medication/presentation/cubit/medication_cubit.dart';
import 'package:glupulse/app/theme/app_theme.dart';

class AddEditMedicationPage extends StatefulWidget {
  final Medication? medication;

  const AddEditMedicationPage({super.key, this.medication});

  @override
  State<AddEditMedicationPage> createState() => _AddEditMedicationPageState();
}

class _AddEditMedicationPageState extends State<AddEditMedicationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _unitController = TextEditingController();
  String _medicationType = 'OTHER_RX';
  bool _isActive = true;

  final List<Map<String, String>> _medicationTypes = [
    {'value': 'INSULIN', 'label': 'Insulin'},
    {'value': 'BIGUANIDE', 'label': 'Biguanide (Metformin)'},
    {'value': 'GLP', 'label': 'GLP-1 Agonist'},
    {'value': 'SGLT2', 'label': 'SGLT-2 Inhibitor'},
    {'value': 'DPP4', 'label': 'DPP-4 Inhibitor'},
    {'value': 'OTC', 'label': 'Over-The-Counter'},
    {'value': 'SUPPLEMENT', 'label': 'Supplement'},
    {'value': 'OTHER_RX', 'label': 'Other Prescription'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.medication != null) {
      _nameController.text = widget.medication!.displayName;
      _unitController.text = widget.medication!.defaultDoseUnit;
      _medicationType = widget.medication!.medicationType;
      _isActive = widget.medication!.isActive ?? true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final medication = Medication(
        id: widget.medication?.id,
        userId: widget.medication?.userId,
        displayName: _nameController.text,
        medicationType: _medicationType,
        defaultDoseUnit: _unitController.text,
        isActive: _isActive,
      );

      if (widget.medication == null) {
        context.read<MedicationCubit>().createMedication(medication);
      } else {
        context.read<MedicationCubit>().editMedication(medication);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      appBar: AppBar(
        title: Text(widget.medication == null ? 'Add Medication' : 'Edit Medication'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<MedicationCubit, MedicationState>(
        listener: (context, state) {
          if (state is MedicationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Medication saved successfully!')),
            );
            Navigator.of(context).pop(true); // Return true to indicate refresh needed
          } else if (state is MedicationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          if (state is MedicationLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Medication Name', isMandatory: true),
                  TextFormField(
                    controller: _nameController,
                    decoration: _inputDecoration(hintText: 'e.g. Metformin, Lantus'),
                    validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 24),

                  _buildSectionTitle('Type', isMandatory: true),
                  DropdownButtonFormField<String>(
                    value: _medicationType,
                    decoration: _inputDecoration(hintText: 'Select Type'),
                    items: _medicationTypes.map((type) {
                      return DropdownMenuItem(
                        value: type['value'],
                        child: Text(type['label']!),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) setState(() => _medicationType = value);
                    },
                  ),
                  const SizedBox(height: 24),

                  _buildSectionTitle('Default Dose Unit', isMandatory: true),
                  TextFormField(
                    controller: _unitController,
                    decoration: _inputDecoration(hintText: 'e.g. mg, units, pills'),
                    validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 24),

                  if (widget.medication != null)
                    SwitchListTile(
                      title: const Text('Is Active'),
                      value: _isActive,
                      onChanged: (val) => setState(() => _isActive = val),
                      activeColor: Theme.of(context).colorScheme.primary,
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
                    child: const Text('Save Medication', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
