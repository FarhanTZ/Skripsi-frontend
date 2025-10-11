import 'package:flutter/material.dart';
import 'package:glupulse/app/theme/app_theme.dart';
import 'package:glupulse/features/presentation/screens/User/edit_profile_page.dart';

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
                          // TODO: Implement logout logic
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