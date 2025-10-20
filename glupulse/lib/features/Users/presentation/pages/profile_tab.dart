import 'package:flutter/material.dart';
import 'package:glupulse/app/theme/app_theme.dart';
import 'package:glupulse/features/auth/presentation/pages/login_page.dart';
import 'package:glupulse/features/profile/presentation/pages/edit_profile_page.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Container biru di bagian atas
                _buildProfileHeader(context),
                const SizedBox(height: 24),

                // Daftar menu di bawah container
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      _buildProfileMenuItem(
                        context: context,
                        icon: Icons.person_outline,
                        text: 'Edit Profile',
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const EditProfilePage(),
                          ));
                        },
                      ),
                      _buildProfileMenuItem(
                        context: context,
                        icon: Icons.settings_outlined,
                        text: 'Settings',
                        onTap: () {
                          // TODO: Implement navigation to Settings page
                        },
                      ),
                      _buildProfileMenuItem(
                        context: context,
                        icon: Icons.help_outline,
                        text: 'Help & Support',
                        onTap: () {
                          // TODO: Implement navigation to Help page
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildProfileMenuItem(
                        context: context,
                        icon: Icons.logout,
                        text: 'Logout',
                        textColor: Colors.red,
                        iconColor: Colors.red,
                        onTap: () {
                          _showModernLogoutDialog(context);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showModernLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Pengguna harus memilih salah satu tombol
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: _buildLogoutDialogContent(dialogContext, context),
        );
      },
    );
  }

  Widget _buildLogoutDialogContent(BuildContext dialogContext, BuildContext pageContext) {
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
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Konfirmasi Logout',
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Apakah Anda yakin ingin keluar dari akun Anda?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0, color: Colors.black54),
              ),
              const SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: const Text('Batal', style: TextStyle(fontSize: 16)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop(); // Tutup dialog
                      Navigator.of(pageContext).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                        (Route<dynamic> route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Logout', style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Ikon peringatan di atas dialog
        const Positioned(
          left: 20,
          right: 20,
          child: CircleAvatar(
            backgroundColor: Colors.orange,
            radius: 45,
            child: Icon(Icons.warning_amber_rounded, color: Colors.white, size: 50),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 238,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(30), // Lengkungan di bawah
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              size: 60,
              color: AppTheme.inputLabelColor,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Parhan', // Contoh nama
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'parhan@example.com', // Contoh email
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget untuk membuat item menu profil dengan gaya modern
  Widget _buildProfileMenuItem({
    required BuildContext context,
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color textColor = Colors.black87,
    Color iconColor = AppTheme.inputLabelColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0), // Memberi jarak antar item
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(            
            color: (iconColor == Colors.red ? iconColor.withOpacity(0.1) : AppTheme.inputFieldColor.withOpacity(0.7)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(text, style: TextStyle(fontWeight: FontWeight.w600, color: textColor)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      ),
    );
  }
}