import 'package:flutter/material.dart';
import 'package:glupulse/app/theme/app_theme.dart';

class EditAddressPage extends StatefulWidget {
  final Map<String, String> addressToEdit;

  const EditAddressPage({super.key, required this.addressToEdit});

  @override
  State<EditAddressPage> createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  final _labelController = TextEditingController(text: 'Home');
  final _streetController = TextEditingController(text: 'Jl. Telekomunikasi No. 1');
  final _postalCodeController = TextEditingController(text: '40257');

  // Data dan state untuk dropdown kota
  // TODO: Sebaiknya data ini diambil dari API atau sumber data terpusat
  final List<String> _cities = ['Bandung', 'Jakarta', 'Surabaya', 'Medan', 'Yogyakarta'];
  String? _selectedCity;

  // Data dan state untuk dropdown provinsi
  final List<String> _states = ['Jawa Barat', 'DKI Jakarta', 'Jawa Timur', 'Sumatera Utara', 'DI Yogyakarta'];
  String? _selectedState;

  @override
  void dispose() {
    _labelController.dispose();
    _streetController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Mode Edit: Isi form dengan data yang ada
    final addressParts = widget.addressToEdit['address']!.split(', ');
    _labelController.text = widget.addressToEdit['label']!;
    _streetController.text = addressParts.length > 0 ? addressParts[0] : '';
    _selectedCity = addressParts.length > 1 && _cities.contains(addressParts[1]) ? addressParts[1] : _cities[0];
    _selectedState = addressParts.length > 2 && _states.contains(addressParts[2]) ? addressParts[2] : _states[0];
    // Anda mungkin perlu logika yang lebih baik untuk postal code jika ada di string
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
        title: const Text(
          'Edit Address',
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
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(
                controller: _labelController,
                label: 'Address Label',
                hint: 'e.g., Home, Office'),
            const SizedBox(height: 24),
            _buildTextField(
                controller: _streetController,
                label: 'Street',
                hint: 'Enter your street address'),
            const SizedBox(height: 24),
            _buildCityDropdown(),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildStateDropdown(),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                      controller: _postalCodeController,
                      label: 'Postal Code',
                      hint: 'Enter postal code',
                      keyboardType: TextInputType.number),
                ),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Gabungkan data dari form
                final fullAddress = '${_streetController.text}, $_selectedCity, $_selectedState';
                final addressData = {
                  'label': _labelController.text,
                  'address': fullAddress,
                };

                // Kembalikan data ke halaman sebelumnya
                Navigator.of(context).pop(addressData);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              child: const Text('Save Address',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCityDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'City',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCity,
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down,
                  color: Theme.of(context).colorScheme.primary),
              items: _cities.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCity = newValue;
                });
              },
              dropdownColor: Colors.white,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStateDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'State/Province',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedState,
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down,
                  color: Theme.of(context).colorScheme.primary),
              items: _states.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedState = newValue;
                });
              },
              dropdownColor: Colors.white,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller,
      required String label,
      required String hint,
      TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppTheme.inputLabelColor),
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
        ),
      ],
    );
  }
}