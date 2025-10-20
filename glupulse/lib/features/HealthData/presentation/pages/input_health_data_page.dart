import 'package:flutter/material.dart';
import 'package:glupulse/app/theme/app_theme.dart';
import 'dart:math';

class InputHealthDataPage extends StatefulWidget {
  const InputHealthDataPage({super.key});

  @override
  State<InputHealthDataPage> createState() => _InputHealthDataPageState();
}

class _InputHealthDataPageState extends State<InputHealthDataPage> {
  final _formKey = GlobalKey<FormState>();

  // Controller
  final _bloodSugarController = TextEditingController();
  final _systolicController = TextEditingController();
  final _diastolicController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _bmiController = TextEditingController();
  final _heartRateController = TextEditingController();
  final _notesController = TextEditingController();

  bool _isSmoker = false;
  bool _hasHeartDiseaseHistory = false;

  @override
  void dispose() {
    _bloodSugarController.dispose();
    _systolicController.dispose();
    _diastolicController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _bmiController.dispose();
    _heartRateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // Fungsi untuk menghitung BMI
  void _calculateBMI() {
    final weight = double.tryParse(_weightController.text);
    final height = double.tryParse(_heightController.text);

    if (weight != null && height != null && height > 0) {
      final bmi = weight / pow(height / 100, 2); // tinggi dalam cm
      _bmiController.text = bmi.toStringAsFixed(2);
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
        title: const Text(
          'Input Health Data',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                _buildSectionTitle('Berat & Tinggi Badan'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _weightController,
                        hintText: 'Berat (kg)',
                        icon: Icons.monitor_weight_outlined,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => _calculateBMI(),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        controller: _heightController,
                        hintText: 'Tinggi (cm)',
                        icon: Icons.height_outlined,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => _calculateBMI(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _bmiController,
                  hintText: 'BMI otomatis terhitung',
                  icon: Icons.calculate_outlined,
                  readOnly: true,
                ),

                const SizedBox(height: 24),
                _buildSectionTitle('Tekanan Darah (mmHg)'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _systolicController,
                        hintText: 'Sistolik (contoh: 120)',
                        icon: Icons.favorite_border,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        controller: _diastolicController,
                        hintText: 'Diastolik (contoh: 80)',
                        icon: Icons.favorite_border,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                _buildSectionTitle('Gula Darah (mg/dL)'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _bloodSugarController,
                  hintText: 'Contoh: 110',
                  icon: Icons.water_drop_outlined,
                  keyboardType: TextInputType.number,
                ),

                const SizedBox(height: 24),
                _buildSectionTitle('Detak Jantung (BPM)'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _heartRateController,
                  hintText: 'Contoh: 72',
                  icon: Icons.monitor_heart_outlined,
                  keyboardType: TextInputType.number,
                ),

                const SizedBox(height: 24),
                _buildSectionTitle('Catatan Tambahan'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _notesController,
                  hintText: 'Tambahkan catatan (opsional)',
                  icon: Icons.note_alt_outlined,
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                ),

                const SizedBox(height: 24),
                _buildSectionTitle('Informasi Tambahan'),
                const SizedBox(height: 8),
                _buildCheckboxTile(
                  title: 'Apakah Anda perokok?',
                  value: _isSmoker,
                  onChanged: (value) {
                    setState(() {
                      _isSmoker = value ?? false;
                    });
                  },
                ),
                const SizedBox(height: 12),
                _buildCheckboxTile(
                  title: 'Apakah ada riwayat penyakit jantung?',
                  value: _hasHeartDiseaseHistory,
                  onChanged: (value) {
                    setState(() {
                      _hasHeartDiseaseHistory = value ?? false;
                    });
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      backgroundColor: Colors.transparent,
                      child: _buildSuccessDialog(dialogContext),
                    );
                  },
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 5,
            ),
            child: const Text(
              'Simpan Data',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  // Dialog sukses
  Widget _buildSuccessDialog(BuildContext dialogContext) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(left: 20, top: 65, right: 20, bottom: 20),
          margin: const EdgeInsets.only(top: 45),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Success!',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Data Anda berhasil disimpan.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0, color: Colors.black54),
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implementasi logika untuk menyimpan data ke backend

                  // Buat objek atau map untuk menampung data yang akan dikembalikan
                  final healthData = {
                    'bloodSugar': _bloodSugarController.text,
                    'systolic': _systolicController.text,
                    'diastolic': _diastolicController.text,
                    'weight': _weightController.text,
                    'height': _heightController.text,
                    'bmi': _bmiController.text,
                    'heartRate': _heartRateController.text,
                  };

                  // Tutup dialog sukses
                  Navigator.of(dialogContext).pop();
                  // Kembali ke halaman sebelumnya dan kirim data
                  Navigator.of(context).pop(healthData);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                ),
                child: const Text('OK'),
              ),
            ],
          ),
        ),
        const Positioned(
          left: 20,
          right: 20,
          child: CircleAvatar(
            backgroundColor: Color(0xFF4CAF50),
            radius: 45,
            child: Icon(Icons.check, color: Colors.white, size: 50),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.black87,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    int maxLines = 1,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onChanged: onChanged,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: AppTheme.inputLabelColor),
        prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.primary),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide:
              BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
        ),
      ),
    );
  }

  Widget _buildCheckboxTile({
    required String title,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: Theme.of(context).colorScheme.primary,
              shape: const CircleBorder(),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
