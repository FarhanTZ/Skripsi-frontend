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

  String? _selectedProvince;
  String? _selectedCity;
  String? _selectedDistrict;
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
    
    _isDefault = widget.addressToEdit.isDefault ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddressCubit, AddressState>(
      listener: (context, state) => _handleStateChanges(context, state),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Edit Address',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Recipient Info'),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _labelController,
                      label: 'Address Label',
                      hint: 'e.g. Home, Office',
                      icon: Icons.label_outline,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _recipientNameController,
                            label: 'Recipient Name',
                            hint: 'Full Name',
                            icon: Icons.person_outline,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _recipientPhoneController,
                      label: 'Phone Number',
                      hint: '08xxxxxxxxxx',
                      keyboardType: TextInputType.phone,
                      icon: Icons.phone_outlined,
                    ),
                    
                    const SizedBox(height: 32),
                    _buildSectionTitle('Address Details'),
                    const SizedBox(height: 16),
                    
                    _buildRegionSelector(context),
                    const SizedBox(height: 16),
                    _buildStreetSelector(context),
                    const SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildTextField(
                            controller: _addressLine2Controller,
                            label: 'Details (Optional)',
                            hint: 'Unit No, Block',
                            icon: Icons.home_work_outlined,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            controller: _postalCodeController,
                            label: 'Postal Code',
                            hint: '12345',
                            keyboardType: TextInputType.number,
                            icon: Icons.markunread_mailbox_outlined,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _deliveryNotesController,
                      label: 'Delivery Notes (Optional)',
                      hint: 'e.g. Leave at reception',
                      icon: Icons.note_alt_outlined,
                      maxLines: 2,
                    ),
                    
                    const SizedBox(height: 24),
                    _buildDefaultSwitch(),
                    const SizedBox(height: 40),
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildDefaultSwitch() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Set as Default Address',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Switch(
            value: _isDefault,
            onChanged: (val) => setState(() => _isDefault = val),
            activeColor: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5)),
        ],
      ),
      child: ElevatedButton(
        onPressed: _updateAddress,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 0,
        ),
        child: const Text('Update Address',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildRegionSelector(BuildContext context) {
    bool hasSelection = _selectedProvince != null;
    return GestureDetector(
      onTap: _navigateToRegionSelection,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.map_outlined, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Region', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(
                    hasSelection 
                      ? '$_selectedProvince, $_selectedCity, $_selectedDistrict' 
                      : 'Select Province, City, District',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: hasSelection ? FontWeight.w600 : FontWeight.normal,
                      color: hasSelection ? Colors.black87 : Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildStreetSelector(BuildContext context) {
    bool hasSelection = _streetController.text.isNotEmpty;
    return GestureDetector(
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.location_on_outlined, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Street / Location', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(
                    hasSelection ? _streetController.text : 'Search street name or building',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: hasSelection ? FontWeight.w600 : FontWeight.normal,
                      color: hasSelection ? Colors.black87 : Colors.grey.shade400,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.search, size: 20, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    IconData? icon,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400),
        prefixIcon: icon != null ? Icon(icon, color: Colors.grey.shade600, size: 22) : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.5),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  Future<void> _navigateToRegionSelection() async {
    final result = await Navigator.of(context).push<Map<String, String>>(
      MaterialPageRoute(builder: (context) => const RegionSelectionPage()),
    );

    if (result != null) {
      setState(() {
        _selectedProvince = result['province'];
        _selectedCity = result['city'];
        _selectedDistrict = result['district'];
        final postal = result['postalCode'];
        
        if (result.containsKey('street') && result['street']!.isNotEmpty) {
          _streetController.text = result['street']!;
        }
        if (postal != null) {
          _postalCodeController.text = postal;
        }
      });
    }
  }

  void _updateAddress() {
    if (_labelController.text.isEmpty ||
        _streetController.text.isEmpty ||
        _selectedProvince == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in required fields.')),
      );
      return;
    }

    final params = UpdateAddressParams(
      addressId: widget.addressToEdit.addressId,
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
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );
    } else if (state is AddressActionSuccess) {
      Navigator.of(context).pop(); 
      Navigator.of(context).pop(true);
    } else if (state is AddressError) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
    }
  }
}
