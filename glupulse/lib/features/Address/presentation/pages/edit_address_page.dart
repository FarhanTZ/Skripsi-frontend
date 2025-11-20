import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glupulse/app/theme/app_theme.dart';
import 'package:glupulse/features/Address/domain/usecases/update_address_usecase.dart';
import 'package:glupulse/features/Address/presentation/cubit/address_cubit.dart';
import 'package:glupulse/features/Address/presentation/cubit/address_state.dart';
import 'package:glupulse/features/Address/presentation/pages/region_selection_page.dart';
import 'package:glupulse/features/Address/presentation/pages/street_selection_page.dart';
import 'package:glupulse/features/profile/data/models/address_model.dart';

class EditAddressPage extends StatefulWidget {
  final AddressModel addressToEdit;
  const EditAddressPage({super.key, required this.addressToEdit});

  @override
  State<EditAddressPage> createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  final _labelController = TextEditingController();
  final _recipientNameController = TextEditingController();
  final _recipientPhoneController = TextEditingController();
  final _streetController = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _deliveryNotesController = TextEditingController();

  // State untuk menyimpan data wilayah yang dipilih
  String? _selectedProvince;
  String? _selectedCity;
  String? _selectedDistrict;
  String? _selectedPostalCode;
  bool _isDefault = false;

  @override
  void dispose() {
    _labelController.dispose();
    _recipientNameController.dispose();
    _recipientPhoneController.dispose();
    _streetController.dispose();
    _addressLine2Controller.dispose();
    _postalCodeController.dispose();
    _deliveryNotesController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Isi form dengan data dari AddressModel
    _labelController.text = widget.addressToEdit.addressLabel ?? '';
    _recipientNameController.text = widget.addressToEdit.recipientName ?? '';
    _recipientPhoneController.text = widget.addressToEdit.recipientPhone ?? '';
    _streetController.text = widget.addressToEdit.addressLine1 ?? '';
    _addressLine2Controller.text = widget.addressToEdit.addressLine2 ?? '';
    _postalCodeController.text = widget.addressToEdit.addressPostalcode ?? '';
    _deliveryNotesController.text = widget.addressToEdit.deliveryNotes ?? '';

    _selectedProvince = widget.addressToEdit.addressProvince;
    _selectedCity = widget.addressToEdit.addressCity;
    _selectedDistrict = widget.addressToEdit.addressDistrict;
    _selectedPostalCode = widget.addressToEdit.addressPostalcode;

    _isDefault = widget.addressToEdit.isDefault ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddressCubit, AddressState>(
      listener: (context, state) {
        _handleStateChanges(context, state);
      },
      child: Scaffold(
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _labelController,
                          label: 'Label Alamat',
                          hint: 'Contoh: Rumah',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          controller: _recipientNameController,
                          label: 'Nama Penerima',
                          hint: 'Nama lengkap',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildTextField(
                    controller: _recipientPhoneController,
                    label: 'No. Telepon Penerima',
                    hint: 'Masukkan nomor telepon aktif',
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 24),
                  _buildRegionSelector(context),
                  const SizedBox(height: 24),
                  _buildStreetSelector(context),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _addressLine2Controller,
                          label: 'Detail Alamat',
                          hint: 'Blok C1 No. 2',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                            controller: _postalCodeController,
                            label: 'Kode Pos',
                            hint: 'Kode pos',
                            keyboardType: TextInputType.number),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildTextField(
                      controller: _deliveryNotesController,
                      label: 'Catatan Pengiriman (Opsional)',
                      hint: 'Contoh: Titip di resepsionis'),
                  const SizedBox(height: 24), // Spasi sebelum area bawah
                ],
              ),
            ),
          ),
          _buildBottomActionBar(),
        ],
      ),
    ),
    );
  }

  void _updateAddress() {
    if (_labelController.text.isEmpty ||
        _recipientNameController.text.isEmpty ||
        _recipientPhoneController.text.isEmpty ||
        _streetController.text.isEmpty ||
        _selectedProvince == null ||
        _selectedCity == null ||
        _selectedDistrict == null ||
        _postalCodeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap lengkapi semua field yang wajib diisi.')),
      );
      return;
    }

    final params = UpdateAddressParams(
      addressId: widget.addressToEdit.addressId, // ID dari alamat yang diedit
      addressLabel: _labelController.text,
      isDefault: _isDefault,
      recipientName: _recipientNameController.text,
      recipientPhone: _recipientPhoneController.text,
      addressLine1: _streetController.text,
      addressLine2: _addressLine2Controller.text.isNotEmpty ? _addressLine2Controller.text : null,
      addressCity: _selectedCity!,
      addressPostalcode: _postalCodeController.text,
      addressDistrict: _selectedDistrict!,
      addressProvince: _selectedProvince!,
      deliveryNotes: _deliveryNotesController.text.isNotEmpty ? _deliveryNotesController.text : null,
    );

    context.read<AddressCubit>().updateAddress(params);
  }

  void _handleStateChanges(BuildContext context, AddressState state) {
    if (state is AddressLoading) {
      showDialog(context: context, barrierDismissible: false, builder: (context) => const Center(child: CircularProgressIndicator()));
    } else if (state is AddressActionSuccess) {
      Navigator.of(context).pop(); // Tutup dialog loading
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Alamat berhasil diperbarui!')));
      Navigator.of(context).pop(true); // Kembali dan kirim sinyal sukses
    } else if (state is AddressError) {
      Navigator.of(context).pop(); // Tutup dialog loading
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
    }
  }

  Widget _buildDefaultAddressSwitch() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Jadikan Alamat Utama',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          Switch(
            value: _isDefault,
            onChanged: (value) {
              setState(() {
                _isDefault = value;
              });
            },
          ),
        ],
      ),
    );
  }
  Widget _buildRegionSelector(BuildContext context) {
    // ... (kode tidak berubah)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Provinsi, Kota, Kecamatan',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8.0),
        GestureDetector(
          onTap: () async => _navigateToRegionSelection(),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: _selectedProvince == null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pilih wilayah Anda',
                        style: TextStyle(color: AppTheme.inputLabelColor, fontSize: 16),
                      ),
                      const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildAddressLine('Provinsi', _selectedProvince),
                            _buildAddressLine('Kota/Kab.', _selectedCity),
                            _buildAddressLine('Kecamatan', _selectedDistrict),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDefaultAddressSwitch(),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _updateAddress,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                ),
                child: const Text('Save Address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
  }

  Widget _buildStreetSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Jalan, Gedung, atau No. Rumah',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8.0),
        GestureDetector(
          onTap: () async {
            final result = await Navigator.of(context).push<String>(
              MaterialPageRoute(builder: (context) => const StreetSelectionPage()),
            );
            if (result != null) {
              setState(() {
                _streetController.text = result;
              });
            }
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _streetController.text.isEmpty ? 'Cari alamat jalan Anda' : _streetController.text,
                    style: TextStyle(color: _streetController.text.isEmpty ? AppTheme.inputLabelColor : Colors.black87, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.search, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Widget untuk menampilkan baris alamat
  Widget _buildAddressLine(String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Text(
        '$label: $value',
        style: const TextStyle(fontSize: 16, color: Colors.black87),
      ),
    );
  }

  // Fungsi untuk navigasi dan handle hasil
  Future<void> _navigateToRegionSelection() async {
    final result = await Navigator.of(context).push<Map<String, String>>(
      MaterialPageRoute(builder: (context) => const RegionSelectionPage()),
    );

    if (result != null) {
      setState(() {
        _selectedProvince = result['province'];
        _selectedCity = result['city'];
        _selectedDistrict = result['district'];
        _selectedPostalCode = result['postalCode']; // Mungkin null

        // Jika "Gunakan Lokasi Saat Ini" memberikan data, isi otomatis
        if (result.containsKey('street') && result['street']!.isNotEmpty) {
          _streetController.text = result['street']!;
        }
        if (_selectedPostalCode != null) {
          _postalCodeController.text = _selectedPostalCode!;
        }
      });
    }
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