import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glupulse/app/theme/app_theme.dart';
import 'package:glupulse/features/auth/domain/entities/user_entity.dart';
import 'package:glupulse/features/auth/presentation/cubit/auth_cubit.dart' as auth;
import 'package:glupulse/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:glupulse/features/profile/presentation/bloc/profile_cubit.dart';
import 'package:glupulse/home_page.dart';
import 'package:glupulse/injection_container.dart';

/// Widget ini bertugas untuk menyediakan ProfileCubit ke EditProfileScreen.
class EditProfilePage extends StatelessWidget {
  /// Jika true, artinya halaman ini diakses dari alur login/register,
  /// dan setelah save akan diarahkan ke HomePage.
  final bool isFromAuthFlow;

  const EditProfilePage({super.key, this.isFromAuthFlow = false});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProfileCubit>()..fetchProfile(),
      child: EditProfileScreen(isFromAuthFlow: isFromAuthFlow),
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  final bool isFromAuthFlow;
  const EditProfileScreen({super.key, required this.isFromAuthFlow});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Controller untuk setiap field
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dobController = TextEditingController();
  String? _selectedGender;
  final List<String> _genders = ['Male', 'Female'];

  @override
  void initState() {
    super.initState();
    // Ambil data user dari AuthCubit sebagai data awal jika ada
    final authState = context.read<auth.AuthCubit>().state;
    if (authState is auth.AuthAuthenticated) {
      _populateFields(authState.user);
    } else if (authState is auth.AuthProfileIncomplete) {
      _populateFields(authState.user);
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  void _populateFields(UserEntity user) {
    print('EditProfilePage: _populateFields dipanggil dengan user dari ProfileCubit: ${user.username}, ${user.email}'); // DEBUG
    // Ambil data user dari AuthCubit sebagai basis, karena pasti punya username & email.
    final authState = context.read<auth.AuthCubit>().state;
    UserEntity? authUser;
    if (authState is auth.AuthAuthenticated) {
      authUser = authState.user;
    } else if (authState is auth.AuthProfileIncomplete) {
      authUser = authState.user;
    }
    print('EditProfilePage: authUser dari AuthCubit: ${authUser?.username}, ${authUser?.email}'); // DEBUG

    // Isi field dari data yang paling lengkap.
    _firstNameController.text = user.firstName ?? authUser?.firstName ?? '';
    _lastNameController.text = user.lastName ?? authUser?.lastName ?? '';
    _emailController.text = user.email.isNotEmpty ? user.email : authUser?.email ?? '';
    _dobController.text = user.dob ?? authUser?.dob ?? '';
    if (user.gender != null && _genders.contains(user.gender)) {
      _selectedGender = user.gender;
    }
  }
  void _saveChanges() async {
    print('--- DEBUG: _saveChanges() dipanggil ---'); // DEBUG
    // Validasi field yang wajib diisi (username tidak lagi divalidasi)
    if (_firstNameController.text.isEmpty || // Username tidak lagi wajib
        _lastNameController.text.isEmpty ||
        _dobController.text.isEmpty || // Tetap validasi DOB
        _selectedGender == null) { // Tetap validasi Gender
      print('--- DEBUG: Validasi GAGAL. Detail: ---'); // DEBUG
      print('First Name Kosong: ${_firstNameController.text.isEmpty}');
      print('Last Name Kosong: ${_lastNameController.text.isEmpty}');
      print('DOB Kosong: ${_dobController.text.isEmpty}');
      print('Gender Kosong: ${_selectedGender == null}');
      print('------------------------------------'); // DEBUG

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Harap lengkapi semua field yang wajib diisi.')));
      return;
    }

    // Langsung panggil _proceedWithUpdate tanpa logika username
    _proceedWithUpdate();
  }

  void _proceedWithUpdate() {
     print('--- DEBUG: Validasi BERHASIL ---'); // DEBUG
     final params = UpdateProfileParams(
       firstName: _firstNameController.text,
       lastName: _lastNameController.text,
       dob: _dobController.text,
       gender: _selectedGender,
     );
 
     print('--- DEBUG: Parameter yang akan dikirim: ${params.toJson()} ---'); // DEBUG
     context.read<ProfileCubit>().updateProfile(params);
     print('--- DEBUG: Memanggil ProfileCubit.updateProfile... ---'); // DEBUG
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileUpdateSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profil berhasil diperbarui!')),
              );
              // Update state di AuthCubit juga
              context.read<auth.AuthCubit>().updateUser(state.user);

              // Arahkan ke HomePage jika dari alur otentikasi, atau pop jika dari halaman profil
              if (widget.isFromAuthFlow) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const HomePage()),
                  (route) => false,
                );
              } else {
                Navigator.of(context).pop();
              }
            } else if (state is ProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is ProfileLoaded) {
              _populateFields(state.user);
            }
          },
          builder: (context, state) {
            if (state is ProfileLoading && _firstNameController.text.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            return Stack(
              children: [
                // Header
                Container(
            width: double.infinity,
            height: 238, // Tinggi disamakan dengan profile_tab.dart
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
            child: const Align(
              alignment: Alignment(0.0, -0.6), // Sejajarkan sedikit ke atas dari tengah
              child: Text(
                'Edit Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),),
                // Form
                Padding(
                  padding: const EdgeInsets.only(top: 238.0),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 60 + 20), // Spasi untuk avatar
                        _buildSectionTitle('First Name'),
                        const SizedBox(height: 8),
                        _buildTextField(controller: _firstNameController, hintText: 'First Name', icon: Icons.person_outline),
                        const SizedBox(height: 24),

                        _buildSectionTitle('Last Name'),
                        const SizedBox(height: 8),
                        _buildTextField(controller: _lastNameController, hintText: 'Last Name', icon: Icons.person_outline),
                        const SizedBox(height: 24),

                        _buildSectionTitle('Email'),
                        const SizedBox(height: 8),
                        _buildTextField(controller: _emailController, hintText: 'Email', icon: Icons.email_outlined, readOnly: true),
                        const SizedBox(height: 24),

                        _buildSectionTitle('Date of Birth'),
                        const SizedBox(height: 8),
                        _buildDateField(context),
                        const SizedBox(height: 24),

                        _buildSectionTitle('Gender'),
                        const SizedBox(height: 8),
                        _buildGenderDropdown(),
                        const SizedBox(height: 24),
                        const SizedBox(height: 40), // Memberi spasi tambahan sebelum tombol
                        ElevatedButton(
                          onPressed: state is ProfileLoading ? null : _saveChanges,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 55),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                            elevation: 5,
                          ),
                          child: state is ProfileLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text('Save Changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ),
                // Tombol Kembali
                if (!widget.isFromAuthFlow && Navigator.canPop(context))
                  Positioned(
                    top: 40,
                    left: 16,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                // Avatar
                Positioned(
                  top: 238 - 60,
                  left: 0,
                  right: 0,
                  child: Center(child: _buildProfileAvatar()),
                ),
              ],
            );
          },
        ));
  }

  // Widget untuk Avatar Profil, diekstrak agar lebih rapi
  Widget _buildProfileAvatar() {
    return Stack(
      children: [
        const CircleAvatar(
          radius: 60,
          backgroundColor: AppTheme.inputFieldColor,
          child: Icon(
            Icons.person,
            size: 70,
            color: AppTheme.inputLabelColor,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              // TODO: Implementasikan logika untuk memilih gambar
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Helper widget untuk TextField
  Widget _buildTextField(
      {required TextEditingController controller,
      String? hintText,
      required IconData icon,
      TextInputType keyboardType = TextInputType.text,
      bool isPassword = false,
      bool readOnly = false}) {
    return Container(
      decoration: BoxDecoration(
        color: readOnly ? Colors.grey[200] : Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(0, 3), // Posisi bayangan
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: readOnly,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: AppTheme.inputLabelColor),
          prefixIcon: Icon(icon),
          border: InputBorder.none, // Menghilangkan border default TextField
          contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16), // Padding di dalam TextField
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.black87,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDateField(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: _dobController,
        readOnly: true,
        decoration: const InputDecoration(
          hintText: 'Date of Birth',
          hintStyle: TextStyle(color: AppTheme.inputLabelColor),
          prefixIcon: Icon(Icons.calendar_today),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (pickedDate != null) {
            String formattedDate = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
            setState(() {
              _dobController.text = formattedDate;
            });
          }
        },
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 7, offset: const Offset(0, 3))],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedGender,
          isExpanded: true,
          hint: const Text('Gender', style: TextStyle(color: AppTheme.inputLabelColor)),
          items: _genders.map((String value) => DropdownMenuItem<String>(value: value, child: Text(value))).toList(),
          onChanged: (newValue) => setState(() => _selectedGender = newValue),
        ),
      ),
    );
  }
}