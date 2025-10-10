import 'package:flutter/material.dart';
import 'package:glupulse/app/theme/app_theme.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Container biru di bagian atas
                Container(
                  width: 440,
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
                ),
                const SizedBox(height: 24),

                // Daftar menu di bawah container
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      _buildProfileMenuItem(
                        icon: Icons.person_outline,
                        text: 'Edit Profile',
                        onTap: () {
                          // TODO: Implement navigation to Edit Profile page
                        },
                      ),
                      _buildProfileMenuItem(
                        icon: Icons.settings_outlined,
                        text: 'Settings',
                        onTap: () {
                          // TODO: Implement navigation to Settings page
                        },
                      ),
                      _buildProfileMenuItem(
                        icon: Icons.help_outline,
                        text: 'Help & Support',
                        onTap: () {
                          // TODO: Implement navigation to Help page
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Tombol Logout di bagian paling bawah
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: _buildLogoutButton(context),
        ),
      ],
    );
  }

  // Widget untuk tombol Logout
  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Implement logout logic
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: Colors.white),
            SizedBox(width: 12),
            Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget untuk membuat item menu profil dengan gaya modern
  Widget _buildProfileMenuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color textColor = Colors.black87,
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
            color: AppTheme.inputFieldColor.withOpacity(0.7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppTheme.inputLabelColor),
        ),
        title: Text(text, style: TextStyle(fontWeight: FontWeight.w600, color: textColor)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      ),
    );
  }
}