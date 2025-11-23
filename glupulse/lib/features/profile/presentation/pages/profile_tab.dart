import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glupulse/app/theme/app_theme.dart';
import 'package:glupulse/features/HealthData/presentation/pages/edit_health_profile_page.dart';
import 'package:glupulse/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:glupulse/features/auth/presentation/cubit/auth_state.dart';
import 'package:glupulse/features/profile/presentation/pages/profile_settings_screen.dart';
import 'package:glupulse/features/profile/presentation/pages/edit_profile_page.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        String fullName = 'Guest User';
        String email = 'email@example.com';

        if (state is AuthAuthenticated) {
          final user = state.user;
          // Gunakan nama depan, tangani jika null
          fullName = user.firstName ?? '';
          // Jika nama depan kosong (misal, baru login Google), gunakan username
          if (fullName.isEmpty) {
            fullName = user.username;
          }
          email = user.email;
        } else if (state is AuthProfileIncomplete) {
          // Lakukan hal yang sama untuk state AuthProfileIncomplete
          final user = state.user;
          fullName = user.firstName ?? '';
          if (fullName.isEmpty) {
            fullName = user.username;
          }
          email = user.email;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Container biru di bagian atas, sekarang dengan data dinamis
                    _buildProfileHeader(context, fullName: fullName, email: email),
                    const SizedBox(height: 24),

                    // Daftar menu di bawah container
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: [
                          _buildProfileMenuItem(
                              context: context,
                              iconWidget: SvgPicture.asset(
                                'assets/images/Profile_glupulsesvg.svg',
                                width: 24,
                                height: 24,
                                colorFilter: const ColorFilter.mode(
                                    AppTheme.inputLabelColor, BlendMode.srcIn),
                              ),
                              text: 'Edit Profile',
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const EditProfilePage(),
                                ));
                              }),
                          _buildProfileMenuItem(
                              context: context,
                              iconWidget: const Icon(
                                Icons.favorite_border,
                                color: AppTheme.inputLabelColor,
                                size: 24,
                              ),
                              text: 'Health Profile',
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const EditHealthProfilePage(),
                                  ),
                                );
                              }),
                          _buildProfileMenuItem(
                            context: context,
                            iconWidget: SvgPicture.asset(
                              'assets/images/Setting.svg',
                              width: 24,
                              height: 24,
                              colorFilter: const ColorFilter.mode(
                                  AppTheme.inputLabelColor, BlendMode.srcIn),
                            ),
                            text: 'Settings',
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const ProfileSettingsPage(),
                              ));
                            },
                          ),
                          _buildProfileMenuItem(
                            context: context,
                            iconWidget: SvgPicture.asset(
                              'assets/images/Help&support.svg',
                              width: 24,
                              height: 24,
                              colorFilter: const ColorFilter.mode(
                                  AppTheme.inputLabelColor, BlendMode.srcIn),
                            ),
                            text: 'Help & Support',
                            onTap: () {
                              // TODO: Implement navigation to Help page
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildProfileMenuItem(
                            context: context,
                            iconWidget: SvgPicture.asset(
                              'assets/images/Logout.svg',
                              width: 24,
                              height: 24,
                              colorFilter:
                                  const ColorFilter.mode(Colors.red, BlendMode.srcIn),
                            ),
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
      },
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
                      // Panggil metode logout dari AuthCubit
                      pageContext.read<AuthCubit>().logout();
                      Navigator.of(dialogContext).pop(); // Tutup dialog
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

  Widget _buildProfileHeader(
    BuildContext context, {
    required String fullName,
    required String email,
  }) {
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
          Text(
            fullName, // Data dinamis
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            email, // Data dinamis
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget untuk membuat item menu profil dengan gaya modern
  Widget _buildProfileMenuItem({
    required BuildContext context,
    required Widget iconWidget,
    required String text,
    required VoidCallback onTap,
    Color textColor = Colors.black87,
    Color? iconColor, // Dibuat opsional karena warna sudah diatur di SvgPicture
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
            color: (textColor == Colors.red
                ? const Color(0xFFFFA6AE)
                : AppTheme.inputFieldColor.withOpacity(0.7)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: iconWidget,
        ),
        title: Text(text, style: TextStyle(fontWeight: FontWeight.w600, color: textColor)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      ),
    );
  }
}