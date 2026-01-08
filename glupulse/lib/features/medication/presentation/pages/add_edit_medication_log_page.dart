import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:glupulse/app/theme/app_theme.dart';
import 'package:glupulse/features/medication/domain/entities/medication.dart';
import 'package:glupulse/features/medication/domain/entities/medication_log.dart';
import 'package:glupulse/features/medication/presentation/cubit/medication_cubit.dart';
import 'package:glupulse/features/medication/presentation/cubit/medication_log_cubit.dart';
import 'package:glupulse/features/medication/presentation/pages/add_edit_medication_page.dart';
import 'package:collection/collection.dart'; // Added Import for firstWhereOrNull

class AddEditMedicationLogPage extends StatefulWidget {
  final MedicationLog? log;
  final int? selectedMedicationId; // Parameter baru untuk Quick Select

  const AddEditMedicationLogPage({super.key, this.log, this.selectedMedicationId});

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

  // Fokus Node untuk Dose
  final FocusNode _doseFocusNode = FocusNode();

  final List<Map<String, String>> _reasons = [
    {'value': 'medication_schedule', 'label': 'Jadwal Rutin'},
    {'value': 'meal_bolus', 'label': 'Makan (Bolus)'},
    {'value': 'correction', 'label': 'Koreksi Gula'},
    {'value': 'basal', 'label': 'Basal'},
  ];

  @override
  void initState() {
    super.initState();
    // Pastikan timestamp dikonversi ke Waktu Lokal (toLocal) agar jamnya sesuai
    _timestamp = widget.log?.timestamp.toLocal() ?? DateTime.now();
    
    // Prioritas: 1. Dari Log (Edit), 2. Dari Quick Select, 3. Null
    if (widget.log != null) {
      _selectedMedicationId = widget.log!.medicationId;
      _doseController.text = widget.log!.doseAmount.toString();
      _reason = widget.log!.reason;
      _isPumpDelivery = widget.log!.isPumpDelivery;
      _durationController.text = widget.log!.deliveryDurationMinutes.toString();
      _notesController.text = widget.log!.notes ?? '';
    } else if (widget.selectedMedicationId != null) {
       _selectedMedicationId = widget.selectedMedicationId;
       // Jika ini entri baru dari Quick Select, kita bisa langsung fokus ke Dose nanti
       WidgetsBinding.instance.addPostFrameCallback((_) {
         _doseFocusNode.requestFocus();
       });
    }

    // Load medications to populate dropdown
    context.read<MedicationCubit>().fetchMedications();
  }

  @override
  void dispose() {
    _doseController.dispose();
    _durationController.dispose();
    _notesController.dispose();
    _doseFocusNode.dispose();
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
        toolbarHeight: 80,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        title: Text(widget.log == null ? 'Log Obat' : 'Edit Log'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
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
                  _buildSectionTitle('Nama Obat', isMandatory: true),
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

                       // KONDISI 1: Belum ada obat (Empty State)
                      if (medications.isEmpty && medState is MedicationLoaded) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.orange.shade200),
                            boxShadow: [
                              BoxShadow(color: Colors.orange.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))
                            ],
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.medication_liquid, size: 48, color: Colors.orange.shade300),
                              const SizedBox(height: 12),
                              const Text(
                                'Belum ada obat tersimpan',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Tambahkan obat ke database Anda dulu sebelum mencatat log.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                              ),
                              const SizedBox(height: 16),
                                                              ElevatedButton.icon(
                                                              onPressed: _navigateToAddMedication,
                                                              icon: const Icon(Icons.add),
                                                              label: const Text('Tambah Obat Baru'),
                                                              style: ElevatedButton.styleFrom(
                                                                backgroundColor: Theme.of(context).colorScheme.primary,
                                                                foregroundColor: Colors.white,
                                                              ),
                                                            ),                            ],
                          ),
                        );
                      }
                      
                      // KONDISI 2: Sudah ada obat (Dropdown Normal)
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              value: _selectedMedicationId,
                              isExpanded: true,
                              decoration: _inputDecoration(hintText: 'Pilih Obat...'),
                              items: medications.map((med) {
                                return DropdownMenuItem(
                                  value: med.id,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(med.displayName, style: const TextStyle(fontWeight: FontWeight.w600)),
                                      // DefaultDoseUnit tidak ditampilkan lagi
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() => _selectedMedicationId = value);
                              },
                              validator: (value) => value == null ? 'Wajib dipilih' : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          InkWell(
                            onTap: _navigateToAddMedication,
                            child: Container(
                              height: 56, // Match text field height roughly
                              width: 56,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary, // Solid Primary Color
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.add, color: Colors.white), // White Icon
                            ),
                          )
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // --- Dose Input (Autofocus) ---
                  _buildSectionTitle('Dosis', isMandatory: true),
                  BlocBuilder<MedicationCubit, MedicationState>(
                    builder: (context, medState) {
                      String doseUnit = 'Unit(s)';
                      if (medState is MedicationLoaded && _selectedMedicationId != null) {
                        final selectedMed = medState.medications.firstWhereOrNull(
                          (med) => med.id == _selectedMedicationId,
                        );
                        if (selectedMed != null && selectedMed.defaultDoseUnit != null) {
                          doseUnit = selectedMed.defaultDoseUnit!;
                        }
                      }
                      
                      return TextFormField(
                        controller: _doseController,
                        focusNode: _doseFocusNode, // Pasang FocusNode
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        // Hapus style font besar agar konsisten dengan field lain
                        decoration: _inputDecoration(hintText: '0.0').copyWith(
                          suffixText: doseUnit, // Dinamis dari unit obat
                          suffixStyle: TextStyle(
                            fontSize: 14, // Ukuran font suffix disesuaikan
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          // Gunakan padding standar dari _inputDecoration
                        ),
                        validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
                      );
                    },
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // --- Date & Time ---
                  _buildSectionTitle('Waktu', isMandatory: true),
                  InkWell(
                    onTap: () => _selectDateTime(context),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 12),
                          Text(
                            DateFormat('EEEE, d MMM yyyy  •  HH:mm').format(_timestamp.toLocal()),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          const Spacer(),
                          const Icon(Icons.arrow_drop_down, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),

                  // --- Reason (Choice Chips) ---
                  _buildSectionTitle('Alasan / Konteks'),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _reasons.map((r) {
                      final isSelected = _reason == r['value'];
                      return ChoiceChip(
                        label: Text(r['label']!),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) setState(() => _reason = r['value']!);
                        },
                        selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                        labelStyle: TextStyle(
                          color: isSelected ? Theme.of(context).colorScheme.primary : Colors.black87,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade300
                          )
                        ),
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 24),

                  // --- Pump Delivery ---
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                       color: Colors.white,
                       borderRadius: BorderRadius.circular(12),
                       border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      children: [
                        SwitchListTile(
                          title: const Text('Penggunaan Pompa Insulin?'),
                          subtitle: const Text('Hanya untuk pengguna pompa'),
                          value: _isPumpDelivery,
                          onChanged: (val) => setState(() => _isPumpDelivery = val),
                          activeColor: Theme.of(context).colorScheme.primary,
                          contentPadding: EdgeInsets.zero,
                        ),
                        
                        if (_isPumpDelivery) ...[
                          const Divider(),
                          const SizedBox(height: 8),
                          _buildSectionTitle('Durasi (Menit)'),
                          TextFormField(
                            controller: _durationController,
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration(hintText: '0'),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),

                  // --- Notes ---
                  _buildSectionTitle('Catatan Tambahan'),
                  TextFormField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: _inputDecoration(hintText: 'Efek samping, lokasi suntik, dll...'),
                  ),
                  const SizedBox(height: 40),

                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                      elevation: 4,
                    ),
                    child: Text(
                      widget.log == null ? 'SIMPAN LOG' : 'UPDATE LOG', 
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1)
                    ),
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

  Widget _buildSectionTitle(String title, {bool isMandatory = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RichText(
        text: TextSpan(
          text: title,
          style: const TextStyle(fontFamily: 'Poppins', color: Colors.black87, fontSize: 14, fontWeight: FontWeight.bold),
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