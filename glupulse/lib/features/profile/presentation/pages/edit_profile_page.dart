import 'package:flutter/material.dart';
import 'package:glupulse/app/theme/app_theme.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // Pre-fill dengan data pengguna saat ini
  final _fullNameController = TextEditingController(text: 'Parhan');
  final _usernameController = TextEditingController(text: 'Parhan');
  final _emailController = TextEditingController(text: 'parhan@example.com');
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    // TODO: Implementasikan logika untuk menyimpan perubahan ke backend
    // Setelah berhasil, kembali ke halaman profil
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [ // Menggunakan Stack untuk menumpuk widget
          // Container biru sebagai header, ukurannya sama dengan di profile_tab.dart
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
            ),
          ),
          // Konten form dibungkus dengan Expanded dan SingleChildScrollView
          Padding(
            // Memberi padding atas agar konten tidak tertutup header
            padding: const EdgeInsets.only(top: 238.0),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 60 + 40), // Spasi untuk avatar + jarak tambahan
                  // Full Name Label
                  const Text(
                    'Full Name',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8), // Space between label and field
                  _buildTextField(
                    controller: _fullNameController,
                    hintText: 'Enter your full name',
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 24),

                  // Username Label
                  const Text(
                    'Username',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _usernameController,
                    hintText: 'Enter your username',
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 24),

                  // Email Label
                  const Text(
                    'Email',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _emailController,
                    hintText: 'Enter your email',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 24),

                  // Password Label
                  const Text(
                    'Password',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _passwordController,
                    hintText: 'Enter new password',
                    icon: Icons.lock_outline,
                    isPassword: true,
                  ),
                  const SizedBox(height: 24),

                  // Confirm Password Label
                  const Text(
                    'Confirm Password',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _confirmPasswordController,
                    hintText: 'Confirm new password',
                    icon: Icons.lock_outline,
                    isPassword: true,
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 5,
                    ),
                    child: const Text('Save Changes',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
          // Tombol Kembali (Back) dipindahkan ke Stack agar di atas semua
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          // Avatar diposisikan di tengah garis bawah header
          Positioned(
            top: 238 - 60, // (tinggi header) - (radius avatar)
            left: 0,
            right: 0,
            child: Center(
              child: _buildProfileAvatar(),
            ),
          ),
        ],
      ),
    );
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
      String? hintText, // Mengubah menjadi opsional
      required IconData icon,
      TextInputType keyboardType = TextInputType.text,
      bool isPassword = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Warna latar belakang container
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
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: AppTheme.inputLabelColor),
          prefixIcon: Icon(icon),
          border: InputBorder.none, // Menghilangkan border default TextField
          contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16), // Padding di dalam TextField
          filled: true,
          fillColor: Colors.white, // Warna latar belakang TextField
        ),
      ),
    );
  }
}