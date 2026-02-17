import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glupulse/app/theme/app_theme.dart';
import 'package:glupulse/features/HealthData/domain/entities/health_profile.dart';
import 'package:glupulse/features/HealthData/presentation/cubit/health_profile_cubit.dart';
import 'package:glupulse/features/HealthData/presentation/cubit/health_profile_state.dart';
import 'package:glupulse/features/profile/presentation/pages/delete_account_confirmation_page.dart';
import 'package:glupulse/features/auth/domain/entities/user_entity.dart';
import 'package:glupulse/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:glupulse/features/auth/presentation/cubit/auth_state.dart';
import 'package:glupulse/features/profile/presentation/pages/change_username_page.dart';
import 'package:glupulse/features/auth/presentation/pages/login_page.dart';
import 'package:glupulse/features/profile/presentation/pages/change_password_page.dart';
import 'package:glupulse/features/profile/presentation/pages/change_email_page.dart';
import 'package:glupulse/injection_container.dart';

class ProfileSettingsPage extends StatelessWidget {
  const ProfileSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Menyediakan HealthProfileCubit ke screen
    return BlocProvider(
      create: (context) => sl<HealthProfileCubit>()..fetchHealthProfile(),
      child: const ProfileSettingsScreen(),
    );
  }
}

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  // State variables for app settings
  String? _selectedPreferredUnit;
  String? _selectedGlucoseUnit;
  String? _selectedTimezone;
  String? _selectedLanguage;

  final List<String> _preferredUnitOptions = ['metric', 'imperial'];
  final Map<String, String> _glucoseUnitOptions = {'mg_dl': 'mg/dL', 'mmol_l': 'mmol/L'};
  final List<String> _timezoneOptions = ['Asia/Jakarta', 'Asia/Singapore', 'America/New_York', 'Europe/London', 'Australia/Sydney'];
  final Map<String, String> _languageOptions = {'id': 'Indonesia'};

  bool _enableGlucoseAlerts = true;
  bool _enableMealReminders = true;
  bool _enableActivityReminders = true;
  bool _enableMedicationReminders = true;
  bool _shareDataForResearch = false;
  bool _shareAnonymizedData = false;

  HealthProfile? _originalHealthProfile;

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
          'Pengaturan',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthUnauthenticated) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(const SnackBar(
                      content: Text('Akun Anda telah berhasil dihapus.'),
                      backgroundColor: Colors.green));
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginPage()), (route) => false);
              }
            },
          ),
          BlocListener<HealthProfileCubit, HealthProfileState>(
            listener: (context, state) {
              if (state is HealthProfileLoaded) {
                _populateUI(state.healthProfile);
              } else if (state is HealthProfileError) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
              } else if (state is HealthProfileSaved) { // Dihapus agar tidak ada notifikasi setiap auto-save
                // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pengaturan berhasil diperbarui!')));
                debugPrint('Pengaturan berhasil disimpan otomatis.'); // Log untuk debugging
              } else if (state is HealthProfileSaveError) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal menyimpan pengaturan: ${state.message}')));
              }
            },
          ),
        ],
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, authState) {
            if (authState is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            UserEntity? user;
            if (authState is AuthAuthenticated) {
              user = authState.user;
            } else if (authState is AuthProfileIncomplete) {
              user = authState.user;
            }

            return BlocBuilder<HealthProfileCubit, HealthProfileState>(
              builder: (context, healthState) {
                if (healthState is HealthProfileLoading && _originalHealthProfile == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _buildSectionTitle('Pengaturan Akun'),
                            _buildProfileMenuItem(
                              context: context,
                              icon: Icons.person_outline,
                              text: 'Ganti Username',
                              onTap: () {
                                final currentUser = user;
                                if (currentUser != null) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => ChangeUsernamePage(currentUsername: currentUser.username),
                                  ));
                                }
                              },
                            ),
                            _buildProfileMenuItem(
                              context: context,
                              icon: Icons.email_outlined,
                              text: 'Ganti Email',
                              onTap: () {
                                final currentUser = user;
                                if (currentUser != null) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => ChangeEmailPage(currentEmail: currentUser.email),
                                  ));
                                }
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
                            const SizedBox(height: 24),
                            _buildSectionTitle('Pengaturan Aplikasi'),
                            _buildAppSettingsSection(), // Bagian pengaturan aplikasi
                            const SizedBox(height: 24),
                            _buildSectionTitle('Manajemen Akun'),
                            _buildProfileMenuItem(
                              context: context,
                              icon: Icons.delete_forever_outlined,
                              text: 'Hapus Akun',
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => DeleteAccountConfirmationPage(
                                    // Kirim status tautan Google ke halaman baru
                                    isGoogleLinked: user?.isGoogleLinked ?? false,
                                  ),
                                ));
                              },
                              textColor: Colors.redAccent, // Warna disamakan dengan warna ikon di analytic_tab
                              iconColor: Colors.redAccent, // Warna disamakan dengan warna ikon di analytic_tab
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _populateUI(HealthProfile healthProfile) {
    if (!mounted) return;
    _originalHealthProfile = healthProfile;
    setState(() {
      _selectedPreferredUnit = healthProfile.preferredUnits ?? 'metric';
      _selectedGlucoseUnit = healthProfile.glucoseUnit ?? 'mg_dl';
      _selectedTimezone = healthProfile.timezone;
      _selectedLanguage = healthProfile.languageCode ?? 'id';
      _enableGlucoseAlerts = healthProfile.enableGlucoseAlerts ?? true;
      _enableMealReminders = healthProfile.enableMealReminders ?? true;
      _enableActivityReminders = healthProfile.enableActivityReminders ?? true;
      _enableMedicationReminders = healthProfile.enableMedicationReminders ?? true;
      _shareDataForResearch = healthProfile.shareDataForResearch ?? false;
      _shareAnonymizedData = healthProfile.shareAnonymizedData ?? false;
    });
  }

  void _saveChanges() {
    if (_originalHealthProfile == null) return;

    final updatedProfile = _originalHealthProfile!.copyWith(
      preferredUnits: _selectedPreferredUnit,
      glucoseUnit: _selectedGlucoseUnit,
      timezone: _selectedTimezone,
      languageCode: _selectedLanguage,
      enableGlucoseAlerts: _enableGlucoseAlerts,
      enableMealReminders: _enableMealReminders,
      enableActivityReminders: _enableActivityReminders,
      enableMedicationReminders: _enableMedicationReminders,
      shareDataForResearch: _shareDataForResearch,
      shareAnonymizedData: _shareAnonymizedData,
    );

    context.read<HealthProfileCubit>().saveHealthProfile(updatedProfile);
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary),
      ),
    );
  }

  Widget _buildProfileMenuItem({
    required BuildContext context,
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    final defaultTextColor = Colors.black87;
    final defaultIconColor = AppTheme.inputLabelColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: ListTile(
        leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: (iconColor == Colors.redAccent // Cek jika ini item destruktif
                    ? Colors.redAccent.withValues(alpha: 0.15) // Latar merah transparan
                    : AppTheme.inputFieldColor.withValues(alpha: 0.7)),
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

  Widget _buildAppSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubSectionTitle('Unit Pilihan'),
        Wrap(
          spacing: 8.0,
          children: _preferredUnitOptions.map((unit) {
            return ChoiceChip(
              label: Text(unit),
              selected: _selectedPreferredUnit == unit,
              onSelected: (isSelected) {
                if (isSelected) {
                  setState(() => _selectedPreferredUnit = unit);
                  _saveChanges();
                }
              },
              selectedColor: Theme.of(context).colorScheme.primary,
              labelStyle: TextStyle(color: _selectedPreferredUnit == unit ? Colors.white : Colors.black),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: Colors.grey.shade300)),
              checkmarkColor: Colors.white,
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        _buildSubSectionTitle('Unit Glukosa'),
        Wrap(
          spacing: 8.0,
          children: _glucoseUnitOptions.entries.map((entry) {
            return ChoiceChip(
              label: Text(entry.value),
              selected: _selectedGlucoseUnit == entry.key,
              onSelected: (isSelected) {
                if (isSelected) {
                  setState(() => _selectedGlucoseUnit = entry.key);
                  _saveChanges();
                }
              },
              selectedColor: Theme.of(context).colorScheme.primary,
              labelStyle: TextStyle(color: _selectedGlucoseUnit == entry.key ? Colors.white : Colors.black),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: Colors.grey.shade300)),
              checkmarkColor: Colors.white,
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        _buildSubSectionTitle('Zona Waktu'),
        _buildDropdown(
          value: _selectedTimezone,
          items: _timezoneOptions,
          onChanged: (val) { setState(() => _selectedTimezone = val); _saveChanges(); },
        ),
        const SizedBox(height: 16),
        _buildSubSectionTitle('Bahasa'),
        _buildDropdown(
          value: _selectedLanguage,
          items: _languageOptions.keys.toList(),
          displayBuilder: (val) => _languageOptions[val] ?? val,
          onChanged: (val) { setState(() => _selectedLanguage = val); _saveChanges(); },
        ),
        const SizedBox(height: 24),
        _buildSubSectionTitle('Notifikasi & Pengingat'),
        _buildSettingSwitchTile(title: 'Notifikasi Gula Darah', value: _enableGlucoseAlerts, onChanged: (val) { setState(() => _enableGlucoseAlerts = val); _saveChanges(); }),
        _buildSettingSwitchTile(title: 'Pengingat Makan', value: _enableMealReminders, onChanged: (val) { setState(() => _enableMealReminders = val); _saveChanges(); }),
        _buildSettingSwitchTile(title: 'Pengingat Aktivitas', value: _enableActivityReminders, onChanged: (val) { setState(() => _enableActivityReminders = val); _saveChanges(); }),
        _buildSettingSwitchTile(title: 'Pengingat Obat', value: _enableMedicationReminders, onChanged: (val) { setState(() => _enableMedicationReminders = val); _saveChanges(); }),
        const SizedBox(height: 24),
        _buildSubSectionTitle('Privasi & Data'),
        _buildSettingSwitchTile(title: 'Bagikan data untuk riset', value: _shareDataForResearch, onChanged: (val) { setState(() => _shareDataForResearch = val); _saveChanges(); }),
        _buildSettingSwitchTile(title: 'Bagikan data anonim', value: _shareAnonymizedData, onChanged: (val) { setState(() => _shareAnonymizedData = val); _saveChanges(); }),
      ],
    );
  }

  Widget _buildSubSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
    );
  }

  Widget _buildDropdown({required String? value, required List<String> items, required ValueChanged<String?> onChanged, String Function(String)? displayBuilder}) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      items: items.map((String item) => DropdownMenuItem<String>(value: item, child: Text(displayBuilder != null ? displayBuilder(item) : item))).toList(),
      onChanged: onChanged,
      isExpanded: true,
    );
  }

  Widget _buildSettingSwitchTile({required String title, required bool value, required ValueChanged<bool> onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.05), spreadRadius: 1, blurRadius: 5)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
          Switch(value: value, onChanged: onChanged, activeColor: Theme.of(context).colorScheme.primary),
        ],
      ),
    );
  }
}
