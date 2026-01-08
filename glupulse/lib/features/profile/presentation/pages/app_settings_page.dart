import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glupulse/app/theme/app_theme.dart';
import 'package:glupulse/features/HealthData/domain/entities/health_profile.dart';
import 'package:glupulse/features/HealthData/presentation/cubit/health_profile_cubit.dart';
import 'package:glupulse/features/HealthData/presentation/cubit/health_profile_state.dart';
import 'package:glupulse/injection_container.dart';

class AppSettingsPage extends StatelessWidget {
  const AppSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HealthProfileCubit>()..fetchHealthProfile(),
      child: const AppSettingsScreen(),
    );
  }
}

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({super.key});

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  // State variables for app settings
  String? _selectedPreferredUnit;
  String? _selectedGlucoseUnit;
  String? _selectedTimezone;
  String? _selectedLanguage;

  final List<String> _preferredUnitOptions = ['metric', 'imperial'];
  final Map<String, String> _glucoseUnitOptions = {
    'mg_dl': 'mg/dL',
    'mmol_l': 'mmol/L'
  };
  final List<String> _timezoneOptions = [
    'Asia/Jakarta',
    'Asia/Singapore',
    'America/New_York',
    'Europe/London',
    'Australia/Sydney'
  ];
  final Map<String, String> _languageOptions = {'id': 'Indonesia'};

  bool _enableGlucoseAlerts = true;
  bool _enableMealReminders = true;
  bool _enableActivityReminders = true;
  bool _enableMedicationReminders = true;
  bool _shareDataForResearch = false;
  bool _shareAnonymizedData = false;

  HealthProfile? _originalHealthProfile;

  @override
  void initState() {
    super.initState();
  }

  void _populateUI(HealthProfile healthProfile) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        title: const Text(
          'Pengaturan Aplikasi',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<HealthProfileCubit, HealthProfileState>(
        listener: (context, state) {
          if (state is HealthProfileLoaded) {
            _populateUI(state.healthProfile);
          } else if (state is HealthProfileError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is HealthProfileSaved) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pengaturan berhasil diperbarui!')));
            Navigator.of(context).pop();
          } else if (state is HealthProfileSaveError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Gagal menyimpan pengaturan: ${state.message}')));
          }
        },
        builder: (context, state) {
          if (state is HealthProfileLoading && _originalHealthProfile == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return _buildSettingsForm(state);
        },
      ),
    );
  }

  Widget _buildSettingsForm(HealthProfileState state) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Unit Pilihan'),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: _preferredUnitOptions.map((unit) {
                    return ChoiceChip(
                      label: Text(unit),
                      selected: _selectedPreferredUnit == unit,
                      onSelected: (isSelected) {
                        setState(() {
                          if (isSelected) _selectedPreferredUnit = unit;
                        });
                      },
                      selectedColor: Theme.of(context).colorScheme.primary,
                      labelStyle: TextStyle(
                        color: _selectedPreferredUnit == unit
                            ? Colors.white
                            : Colors.black,
                      ),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.grey.shade300)),
                      checkmarkColor: Colors.white,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('Unit Glukosa'),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: _glucoseUnitOptions.entries.map((entry) {
                    final backendValue = entry.key;
                    final displayValue = entry.value;
                    return ChoiceChip(
                      label: Text(displayValue),
                      selected: _selectedGlucoseUnit == backendValue,
                      onSelected: (isSelected) {
                        setState(() {
                          if (isSelected) _selectedGlucoseUnit = backendValue;
                        });
                      },
                      selectedColor: Theme.of(context).colorScheme.primary,
                      labelStyle: TextStyle(
                        color: _selectedGlucoseUnit == backendValue
                            ? Colors.white
                            : Colors.black,
                      ),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.grey.shade300)),
                      checkmarkColor: Colors.white,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('Zona Waktu'),
                _buildDropdown(
                    hint: 'Pilih Zona Waktu',
                    value: _selectedTimezone,
                    items: _timezoneOptions,
                    onChanged: (val) => setState(() => _selectedTimezone = val)),
                const SizedBox(height: 16),
                _buildSectionTitle('Bahasa'),
                _buildDropdown(
                    hint: 'Pilih Bahasa',
                    value: _selectedLanguage,
                    items: _languageOptions.keys.toList(),
                    displayBuilder: (val) => _languageOptions[val] ?? val,
                    onChanged: (val) => setState(() => _selectedLanguage = val)),
                const SizedBox(height: 24),
                _buildSectionTitle('Notifikasi & Pengingat'),
                _buildSettingSwitchTile(
                    title: 'Notifikasi Gula Darah',
                    value: _enableGlucoseAlerts,
                    onChanged: (val) =>
                        setState(() => _enableGlucoseAlerts = val)),
                _buildSettingSwitchTile(
                    title: 'Pengingat Makan',
                    value: _enableMealReminders,
                    onChanged: (val) =>
                        setState(() => _enableMealReminders = val)),
                _buildSettingSwitchTile(
                    title: 'Pengingat Aktivitas',
                    value: _enableActivityReminders,
                    onChanged: (val) =>
                        setState(() => _enableActivityReminders = val)),
                _buildSettingSwitchTile(
                    title: 'Pengingat Obat',
                    value: _enableMedicationReminders,
                    onChanged: (val) =>
                        setState(() => _enableMedicationReminders = val)),
                const SizedBox(height: 24),
                _buildSectionTitle('Privasi & Data'),
                _buildSettingSwitchTile(
                    title: 'Bagikan data untuk riset',
                    value: _shareDataForResearch,
                    onChanged: (val) =>
                        setState(() => _shareDataForResearch = val)),
                _buildSettingSwitchTile(
                    title: 'Bagikan data anonim',
                    value: _shareAnonymizedData,
                    onChanged: (val) =>
                        setState(() => _shareAnonymizedData = val)),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: ElevatedButton(
            onPressed: state is HealthProfileSaving ? null : _saveChanges,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              elevation: 5,
            ),
            child: state is HealthProfileSaving
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Simpan Perubahan',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String Function(String)? displayBuilder,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      hint: Text(hint,
          style: const TextStyle(color: AppTheme.inputLabelColor, fontSize: 14)),
      decoration: _inputDecoration(hintText: ''),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(displayBuilder != null ? displayBuilder(item) : item),
        );
      }).toList(),
      onChanged: onChanged,
      isExpanded: true,
    );
  }

  InputDecoration _inputDecoration({required String hintText}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: AppTheme.inputLabelColor, fontSize: 14),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide:
            BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  Widget _buildSettingSwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}