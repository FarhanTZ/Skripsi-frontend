import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glupulse/app/theme/app_theme.dart';
import 'package:glupulse/features/auth/domain/entities/user_entity.dart';
import 'package:glupulse/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:glupulse/features/auth/presentation/cubit/auth_state.dart';
import 'package:glupulse/features/profile/presentation/pages/change_username_page.dart';

class ProfileSettingsScreen extends StatelessWidget {
  const ProfileSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9), // Menyamakan warna background
      appBar: AppBar(
        toolbarHeight: 80, // Menyamakan tinggi AppBar
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        title: const Text(
          'Pengaturan Akun',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.message)));
          // Muat ulang data user untuk kembali ke state sebelum error
          context.read<AuthCubit>().checkAuthenticationStatus();
        } else if (state is AuthAuthenticated) {
          // Bisa tambahkan notifikasi sukses jika diperlukan
        }
      }, builder: (context, state) {
        if (state is AuthLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        UserEntity? user;
        if (state is AuthAuthenticated) {
          user = state.user;
        } else if (state is AuthProfileIncomplete) {
          user = state.user;
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: <Widget>[
              _buildProfileMenuItem(
                context: context,
                icon: Icons.person_outline,
                text: 'Ganti Username',
                onTap: () {
                  if (user != null) {
                    final currentUser = user; // Buat variabel non-nullable
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ChangeUsernamePage(
                        currentUsername: currentUser.username,
                      ),
                    ));
                  }
                },
              ),
              _buildProfileMenuItem(
                context: context,
                icon: Icons.email_outlined,
                text: 'Ganti Email',
                onTap: () {
                  print('Tombol Ganti Email diklik');
                },
              ),
              _buildProfileMenuItem(
                context: context,
                icon: Icons.lock_outline,
                text: 'Ganti Password',
                onTap: () {
                  print('Tombol Ganti Password diklik');
                },
              ),
              const SizedBox(height: 16),
              // _buildGoogleLinkButton(context, user),
            ],
          ),
        );
      }),
    );
  }

  // Menggunakan gaya yang sama dari profile_tab.dart
  Widget _buildProfileMenuItem({
    required BuildContext context,
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color textColor = Colors.black87,
    Color iconColor = AppTheme.inputLabelColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: ListTile(
        leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppTheme.inputFieldColor.withOpacity(0.7), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: iconColor)),
        title: Text(text, style: TextStyle(fontWeight: FontWeight.w600, color: textColor)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      ),
    );
  }

  // Widget khusus untuk tombol tautkan akun Google
  // Widget _buildGoogleLinkButton(BuildContext context, UserEntity? user) {
  //   // Cek apakah provider adalah 'google'.
  //   // Kita asumsikan user yang login biasa memiliki provider 'email' atau null.
  //   final bool isLinked = user?.provider?.toLowerCase() == 'google';

  //   return GestureDetector(
  //     onTap: isLinked
  //         ? null // Jika sudah tertaut, tidak ada aksi
  //         : () {
  //             // Panggil metode untuk menautkan akun
  //             context.read<AuthCubit>().linkGoogleAccount();
  //           },
  //     child: Container(
  //       // Ubah opacity jika tombol dinonaktifkan
  //       foregroundDecoration: isLinked ? BoxDecoration(color: Colors.white.withOpacity(0.5), borderRadius: BorderRadius.circular(15.0)) : null,
  //       padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(15.0),
  //         boxShadow: [
  //           BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 5))
  //         ],
  //       ),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Image.asset(
  //             'assets/images/google_logo.png',
  //             height: 24,
  //             width: 24,
  //           ),
  //           const SizedBox(width: 16),
  //           Text(
  //             // Ganti teks berdasarkan status
  //             isLinked ? 'Akun Sudah Tertaut' : 'Tautkan Akun Google',
  //             style: const TextStyle(
  //                 fontWeight: FontWeight.w600, color: Colors.black87, fontSize: 16),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
