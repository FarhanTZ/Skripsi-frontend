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
  // _addresses sekarang akan dikelola oleh ProfileBloc/Cubit
  AddressModel? _selectedAddress;

  @override
  void initState() {
    super.initState();
    // Inisialisasi alamat yang dipilih dari widget
    _selectedAddress = widget.currentSelectedAddress;
    // Panggil event untuk memuat alamat saat halaman pertama kali dibuka
    // Ini memastikan data selalu segar
    context.read<ProfileCubit>().fetchProfile();
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
      // Gunakan BlocListener untuk AddressCubit untuk menangani feedback (snackbar, refresh)
      body: BlocListener<AddressCubit, AddressState>(
        listener: (context, state) {
          if (state is AddressActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Aksi alamat berhasil!')),
            );
            // Muat ulang daftar alamat dari server
            context.read<ProfileCubit>().fetchProfile();
          } else if (state is AddressError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        // Gunakan BlocBuilder untuk membangun UI berdasarkan state dari ProfileCubit
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            // Tampilkan loading indicator jika state adalah ProfileLoading DAN
            // belum ada data user yang dimuat sebelumnya (misalnya dari state ProfileLoaded).
            final addressesFromState =
                state is ProfileLoaded ? state.user.addresses : null;

            if (state is ProfileLoading && (addressesFromState?.isEmpty ?? true)) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ProfileLoaded) {
              final addresses = state.user.addresses ?? [];
              if (addresses.isEmpty) {
                return const Center(child: Text('Anda belum memiliki alamat.'));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: addresses.length,
                itemBuilder: (context, index) {
                  final address = addresses[index];
                  final isSelected = _selectedAddress?.addressId == address.addressId;
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
                      title: Text(address.addressLabel ?? 'Tanpa Label',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        '${address.addressLine1 ?? ''}, ${address.addressCity ?? ''}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      leading: Radio<AddressModel>(
                        value: address,
                        groupValue: _selectedAddress,
                        onChanged: (AddressModel? value) {
                          setState(() {
                            _selectedAddress = value;
                          });
                        },
                        activeColor: Theme.of(context).colorScheme.primary,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, color: Colors.grey),
                            onPressed: () => _navigateToEditAddress(address),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                            onPressed: () => _confirmDeleteAddress(address),
                          ),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          _selectedAddress = address;
                        });
                      },
                    ),
                  );
                },
              );
            }
            if (state is ProfileError) {
              return Center(child: Text('Gagal memuat alamat: ${state.message}'));
            }
            return const Center(child: Text('Silakan muat ulang halaman.'));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddNewAddress,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ElevatedButton(
          // Hanya pop dengan AddressModel yang dipilih.
          onPressed: () => Navigator.of(context).pop(_selectedAddress),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          ),
          child: const Text('Confirm Address',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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

    // **PERUBAHAN UTAMA DI SINI**
    // Jika hasilnya true (sukses), panggil cubit untuk memuat ulang profil (yang berisi alamat).
    // Halaman TIDAK ditutup.
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

    // **PERUBAHAN UTAMA DI SINI JUGA**
    // Jika hasilnya true (sukses), panggil cubit untuk memuat ulang profil.
    // Halaman TIDAK ditutup.
    if (result == true && mounted) {
      context.read<ProfileCubit>().fetchProfile();
    }
  }

  void _confirmDeleteAddress(AddressModel address) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Alamat'),
          content: Text('Apakah Anda yakin ingin menghapus alamat "${address.addressLabel ?? 'Tanpa Label'}"?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Tutup dialog
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Hapus'),
              onPressed: () {
                // Panggil cubit untuk menghapus alamat
                // Gunakan context dari builder utama, bukan dialogContext
                context.read<AddressCubit>().deleteAddress(address.addressId);
                Navigator.of(dialogContext).pop(); // Tutup dialog
              },
            ),
          ],
        );
      },
    );
  }
}