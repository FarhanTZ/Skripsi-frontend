import 'package:flutter/material.dart';
import 'package:glupulse/app/theme/app_theme.dart';

class InputHealthDataPage extends StatefulWidget {
  const InputHealthDataPage({super.key});

  @override
  State<InputHealthDataPage> createState() => _InputHealthDataPageState();
}

class _InputHealthDataPageState extends State<InputHealthDataPage> {
  final _bloodSugarController = TextEditingController();
  final _systolicController = TextEditingController();
  final _diastolicController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSmoker = false;
  bool _hasHeartDiseaseHistory = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Mengubah warna background agar konsisten
      backgroundColor: const Color(0xFFF2F5F9),
      appBar: AppBar(
        toolbarHeight: 80, // Menambah tinggi AppBar
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30), // Membuat lengkungan di bawah
          ),
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
        iconTheme: const IconThemeData(color: Colors.white), // Warna ikon kembali
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
                _buildSectionTitle('Gula Darah (mg/dL)'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _bloodSugarController,
                  hintText: 'Contoh: 110',
                  icon: Icons.water_drop_outlined,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Tekanan Darah (mmHg)'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _systolicController,
                        hintText: 'Sistolik (Contoh: 120)',
                        icon: Icons.favorite_border,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        controller: _diastolicController,
                        hintText: 'Diastolik (Contoh: 80)',
                        icon: Icons.favorite_border,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Informasi Tambahan'),
                const SizedBox(height: 8),
                _buildCheckboxTile(
                  title: 'Are you a smoker?',
                  value: _isSmoker,
                  onChanged: (value) {
                    setState(() {
                      _isSmoker = value ?? false;
                    });
                  },
                ),
                const SizedBox(height: 12),
                _buildCheckboxTile(
                  title: 'Do you have a history of heart disease?',
                  value: _hasHeartDiseaseHistory,
                  onChanged: (value) {
                    setState(() {
                      _hasHeartDiseaseHistory = value ?? false;
                    });
                  },
                ),
                const SizedBox(height: 16), // Memberi jarak di akhir list sebelum tombol
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SafeArea( // Memastikan tombol tidak terlalu ke bawah pada perangkat dengan notch
          child: ElevatedButton(
          onPressed: () {
            // TODO: Implementasi logika penyimpanan data
            if (_formKey.currentState!.validate()) {
              // Menampilkan pop-up dialog
              showDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  // Menggunakan Dialog kustom untuk tampilan yang lebih modern
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    elevation: 0,
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
          child: const Text('Simpan Data',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  // Widget untuk membangun konten dialog kustom
  Widget _buildSuccessDialog(BuildContext dialogContext) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        // Konten utama dialog
        Container(
          padding: const EdgeInsets.only(
            left: 20,
            top: 65, // Memberi ruang untuk ikon di atas
            right: 20,
            bottom: 20,
          ),
          margin: const EdgeInsets.only(top: 45),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Membuat dialog menjadi sepadat kontennya
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
                  Navigator.of(dialogContext).pop(); // Tutup dialog
                  Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
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
        // Ikon centang di atas dialog
        const Positioned(
          left: 20,
          right: 20,
          child: CircleAvatar(
            backgroundColor: Color(0xFF4CAF50), // Warna hijau untuk sukses
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
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
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
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
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
      // Membuat seluruh baris dapat di-tap
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
              shape: const CircleBorder(), // Membuat checkbox berbentuk lingkaran
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(title,
                  style: const TextStyle(
                      color: Colors.black87, fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      ),
    );
  }
}