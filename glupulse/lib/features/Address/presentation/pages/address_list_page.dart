import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glupulse/features/Address/presentation/cubit/address_cubit.dart';
import 'package:glupulse/features/profile/data/models/address_model.dart';
import 'package:glupulse/features/Address/presentation/cubit/address_state.dart';
import 'package:glupulse/features/Address/presentation/pages/edit_address_page.dart';
import 'package:glupulse/features/Address/presentation/pages/add_address_page.dart';
import 'package:glupulse/injection_container.dart';
import 'package:glupulse/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:glupulse/features/profile/presentation/cubit/profile_state.dart';

class AddressListPage extends StatefulWidget {
  final List<AddressModel> addresses;
  final AddressModel? currentSelectedAddress;
  const AddressListPage(
      {super.key, required this.addresses, this.currentSelectedAddress});

  @override
  State<AddressListPage> createState() => _AddressListPageState();
}

class _AddressListPageState extends State<AddressListPage> {
  AddressModel? _selectedAddress;

  @override
  void initState() {
    super.initState();
    _selectedAddress = widget.currentSelectedAddress;
    context.read<ProfileCubit>().fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Select Address',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocListener<AddressCubit, AddressState>(
        listener: (context, state) {
          if (state is AddressActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Address updated successfully!')),
            );
            context.read<ProfileCubit>().fetchProfile();
          } else if (state is AddressError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            final addressesFromState =
                state is ProfileLoaded ? state.user.addresses : null;

            if (state is ProfileLoading && (addressesFromState?.isEmpty ?? true)) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ProfileLoaded) {
              final addresses = state.user.addresses ?? [];
              if (addresses.isEmpty) {
                return _buildEmptyState();
              }
              return ListView.separated(
                padding: const EdgeInsets.all(20.0),
                itemCount: addresses.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final address = addresses[index];
                  final isSelected = _selectedAddress?.addressId == address.addressId;
                  return _buildAddressCard(address, isSelected);
                },
              );
            }
            if (state is ProfileError) {
              return Center(child: Text('Failed to load addresses: ${state.message}'));
            }
            return const Center(child: Text('Please reload.'));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddNewAddress,
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5)),
          ],
        ),
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).pop(_selectedAddress),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
            elevation: 0,
          ),
          child: const Text('Confirm Selection',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_off_outlined, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'No addresses found',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Add a new address to get started',
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(AddressModel address, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedAddress = address;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                  color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade400,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    address.addressLabel ?? 'Address',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isSelected ? Theme.of(context).colorScheme.primary : Colors.black87,
                    ),
                  ),
                ),
                if (address.isDefault)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Default',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 36), // Align with text above
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        address.recipientName ?? 'Recipient Name',
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        address.recipientPhone ?? '-',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${address.addressLine1 ?? ''}, ${address.addressCity ?? ''}, ${address.addressProvince ?? ''} ${address.addressPostalcode ?? ''}',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _navigateToEditAddress(address),
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  label: const Text('Edit'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey.shade700,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _confirmDeleteAddress(address),
                  icon: const Icon(Icons.delete_outline, size: 16),
                  label: const Text('Delete'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _navigateToAddNewAddress() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (_) => sl<AddressCubit>(),
          child: AddAddressPage(),
        ),
      ),
    );

    if (result == true && mounted) {
      context.read<ProfileCubit>().fetchProfile();
    }
  }

  void _navigateToEditAddress(AddressModel address) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (_) => sl<AddressCubit>(),
          child: EditAddressPage(addressToEdit: address),
        ),
      ),
    );

    if (result == true && mounted) {
      context.read<ProfileCubit>().fetchProfile();
    }
  }

  void _confirmDeleteAddress(AddressModel address) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Delete Address'),
          content: Text('Are you sure you want to delete "${address.addressLabel}"?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
              onPressed: () {
                context.read<AddressCubit>().deleteAddress(address.addressId);
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
