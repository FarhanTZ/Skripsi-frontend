import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glupulse/app/theme/app_theme.dart';
import 'package:glupulse/features/auth/domain/entities/user_entity.dart';
import 'package:glupulse/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:glupulse/features/auth/presentation/cubit/auth_state.dart';
import 'package:glupulse/features/profile/presentation/pages/change_username_page.dart';
import 'package:glupulse/features/auth/presentation/pages/login_page.dart';
import 'package:glupulse/features/profile/presentation/pages/change_password_page.dart';

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
      body: BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
        // Listener untuk menangani navigasi setelah akun dihapus
        if (state is AuthUnauthenticated) {
          // Tampilkan pesan bahwa akun telah dihapus
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(const SnackBar(
                content: Text('Akun Anda telah berhasil dihapus.'),
                backgroundColor: Colors.green));
          // Arahkan ke halaman login dan hapus semua riwayat navigasi
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginPage()), (route) => false);
        }
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
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const ChangePasswordPage(),
                  ));
                },
              ),
              const SizedBox(height: 16),
              _buildProfileMenuItem(
                context: context,
                icon: Icons.delete_forever_outlined,
                text: 'Hapus Akun',
                onTap: () {
                  // Ambil user dari state saat ini untuk memeriksa status Google link
                  final authState = context.read<AuthCubit>().state;
                  UserEntity? currentUser;
                  if (authState is AuthAuthenticated) currentUser = authState.user;
                  if (authState is AuthProfileIncomplete) currentUser = authState.user;

                  bool isGoogleLinked = currentUser?.isGoogleLinked ?? false;
                  _showDeleteAccountDialog(context, isGoogleLinked: isGoogleLinked);
                },
                textColor: Colors.red,
                iconColor: Colors.red,
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
    Color? textColor, // Dibuat nullable
    Color? iconColor, // Dibuat nullable
  }) {
    final defaultTextColor = Colors.black87;
    final defaultIconColor = AppTheme.inputLabelColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: ListTile(
        leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: (textColor == Colors.red
                    ? const Color(0xFFFFA6AE)
                    : AppTheme.inputFieldColor.withOpacity(0.7)),
                borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: iconColor ?? defaultIconColor)),
        title: Text(text,
            style: TextStyle(
                fontWeight: FontWeight.w600, color: textColor ?? defaultTextColor)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context, {required bool isGoogleLinked}) {
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              // Tampilkan error jika password salah atau ada masalah lain
              ScaffoldMessenger.of(dialogContext)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red));
            }
            // Penanganan state AuthUnauthenticated sudah ada di BlocBuilder utama
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return AlertDialog(
              title: const Text('Konfirmasi Hapus Akun'),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isGoogleLinked)
                        const Text(
                            'Ini adalah tindakan permanen dan tidak dapat dibatalkan. Apakah Anda yakin ingin melanjutkan?')
                      else ...[
                        const Text(
                            'Ini adalah tindakan permanen dan tidak dapat dibatalkan. Untuk melanjutkan, masukkan kata sandi Anda.'),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            // Validasi hanya jika tidak login via Google
                            if (!isGoogleLinked && (value == null || value.isEmpty)) {
                              return 'Password tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                      ]
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: isLoading ? null : () => Navigator.of(dialogContext).pop(),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: isLoading ? null : () {
                    // Jika login via Google, lewati validasi form
                    // Jika tidak, jalankan validasi
                    if (isGoogleLinked || formKey.currentState!.validate()) {
                      context.read<AuthCubit>().deleteAccount(passwordController.text);
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: isLoading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Hapus Akun', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
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
