import 'package:flutter/material.dart';
import 'package:glupulse/features/presentation/screens/User/edit_address_page.dart';
import 'package:glupulse/features/presentation/screens/User/add_address_page.dart';

class AddressListPage extends StatefulWidget {
  final Map<String, String> currentAddress;
  const AddressListPage({super.key, required this.currentAddress});

  @override
  State<AddressListPage> createState() => _AddressListPageState();
}

class _AddressListPageState extends State<AddressListPage> {
  // Data dummy untuk alamat
  List<Map<String, String>> _addresses = [
    {
      'label': 'Home',
      'address': 'Jl. Telekomunikasi No. 1, Bandung, Jawa Barat',
    },
    {
      'label': 'Office',
      'address': 'Jl. Gatot Subroto No. 123, Jakarta Selatan, DKI Jakarta',
    },
    {
      'label': 'Parents House',
      'address': 'Jl. Merdeka No. 45, Surabaya, Jawa Timur',
    },
  ];

  late String _selectedAddressLabel;

  @override
  void initState() {
    super.initState();
    _selectedAddressLabel = widget.currentAddress['label']!;
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
          'Select Address',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _addresses.length,
        itemBuilder: (context, index) {
          final address = _addresses[index];
          final isSelected = _selectedAddressLabel == address['label'];

          return Card(
            elevation: 2,
            color: isSelected
                ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                : Colors.white,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                width: 2,
              ),
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              title: Text(address['label']!,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(address['address']!),
              leading: Radio<String>(
                value: address['label']!,
                groupValue: _selectedAddressLabel,
                onChanged: (String? value) {
                  setState(() {
                    _selectedAddressLabel = value!;
                  });
                },
                activeColor: Theme.of(context).colorScheme.primary,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit_outlined, color: Colors.grey),
                onPressed: () {
                  _navigateToEditAddress(address, index);
                },
              ),
              onTap: () {
                setState(() {
                  _selectedAddressLabel = address['label']!;
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddNewAddress,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ElevatedButton(
          onPressed: () {
            final selected = _addresses
                .firstWhere((addr) => addr['label'] == _selectedAddressLabel);
            Navigator.of(context).pop(selected);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
          child: const Text('Confirm Address',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  void _navigateToAddNewAddress() async {
    final newAddress = await Navigator.of(context).push<Map<String, String>>(
      MaterialPageRoute(builder: (context) => const AddAddressPage()),
    );

    if (newAddress != null) {
      setState(() {
        _addresses.add(newAddress);
      });
    }
  }

  void _navigateToEditAddress(Map<String, String> address, int index) async {
    final updatedAddress = await Navigator.of(context).push<Map<String, String>>(
      MaterialPageRoute(
        builder: (context) => EditAddressPage(addressToEdit: address),
      ),
    );

    if (updatedAddress != null) {
      setState(() {
        _addresses[index] = updatedAddress;
      });
    }
  }
}