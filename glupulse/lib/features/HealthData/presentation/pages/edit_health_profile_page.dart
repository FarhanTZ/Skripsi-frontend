import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glupulse/app/theme/app_theme.dart';
import 'package:glupulse/features/HealthData/presentation/cubit/health_profile_state.dart';
import 'package:glupulse/features/HealthData/domain/entities/health_profile.dart';
import 'package:glupulse/features/HealthData/presentation/cubit/health_profile_cubit.dart';
import 'package:glupulse/injection_container.dart';

/// Wrapper widget untuk menyediakan Cubit ke halaman edit.
class EditHealthProfilePage extends StatelessWidget {
  const EditHealthProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HealthProfileCubit>()..fetchHealthProfile(),
      child: const EditHealthProfileScreen(),
    );
  }
}

/// Widget utama yang menampilkan layar edit profil kesehatan.
class EditHealthProfileScreen extends StatefulWidget {
  const EditHealthProfileScreen({super.key});

  @override
  State<EditHealthProfileScreen> createState() => _EditHealthProfileScreenState();
}

class _EditHealthProfileScreenState extends State<EditHealthProfileScreen> {
  // Semua controller dan state dari HealthProfilePage disalin ke sini.
  int? _selectedConditionId;

  final Map<int, String> _healthConditions = {
    1: 'Type 2 Diabetes',
    2: 'Prediabetes',
    3: 'Obesity',
    4: 'General Wellness',
  };

  final Map<String, String> _treatmentOptions = {
    'Insulin': 'insulin',
    'Metformin': 'metformin',
    'DPP-4 inhibitors': 'dpp4_inhibitor',
    'SGLT2 inhibitors': 'sglt2_inhibitor',
    'Alpha-glucosidase inhibitors': 'alpha_glucosidase_inhibitor',
    'GLP-1 receptor agonists': 'glp1_receptor_agonist',
    'Sulfonylureas': 'sulfonylurea',
    'Thiazolidinediones': 'thiazolidinedione',
    'Adjunctive diabetes medications': 'adjunctive_diabetes_medications',
    'Bile acid sequestrants': 'bile_acid_sequestrant',
    'Meglitinides': 'meglitinide',
    'Bariatric surgery': 'bariatric_surgery',
    'Dopamine-2 agonists': 'dopamine_2_agonists',
    'Emotional support': 'emotional_support',
    'Exercise': 'exercise',
    'Prandial glucose regulators': 'prandial_glucose_regulators',
  };

  Map<String, bool> _selectedTreatments = {};

  final _diagnosisDateController = TextEditingController();
  final _lastHba1cDateController = TextEditingController();
  final _heightController = TextEditingController();
  final _currentWeightController = TextEditingController();
  final _targetWeightController = TextEditingController();
  final _waistController = TextEditingController();
  final _bodyFatController = TextEditingController();
  final _hba1cTargetController = TextEditingController();
  final _lastHba1cController = TextEditingController();
  final _targetGlucoseFastingController = TextEditingController();
  final _targetGlucosePostprandialController = TextEditingController();
  final _insulinRegimenController = TextEditingController();
  final _cgmDeviceController = TextEditingController();
  final _dailyStepsGoalController = TextEditingController();
  final _weeklyExerciseGoalController = TextEditingController();
  final _preferredActivityController = TextEditingController();
  final _dietaryPatternController = TextEditingController();
  final _dailyCarbTargetController = TextEditingController();
  final _dailyCalorieTargetController = TextEditingController();
  final _dailyProteinTargetController = TextEditingController();
  final _dailyFatTargetController = TextEditingController();
  final _mealsPerDayController = TextEditingController();
  final _snacksPerDayController = TextEditingController();
  final _foodAllergiesController = TextEditingController();
  final _foodIntolerancesController = TextEditingController();
  final _foodsToAvoidController = TextEditingController();
  final _culturalCuisinesController = TextEditingController();
  final _dietaryRestrictionsController = TextEditingController();
  final _hypertensionMedicationController = TextEditingController();
  final _kidneyDiseaseStageController = TextEditingController();
  final _egfrValueController = TextEditingController();
  final _otherConditionsController = TextEditingController();
  final _smokingStatusController = TextEditingController();
  final _smokingYearsController = TextEditingController();
  final _alcoholFrequencyController = TextEditingController();
  final _alcoholDrinksPerWeekController = TextEditingController();
  final _stressLevelController = TextEditingController();
  final _typicalSleepHoursController = TextEditingController();
  final _sleepQualityController = TextEditingController();
  final _expectedDueDateController = TextEditingController();

  bool _usesCgm = false;
  bool _hasHypertension = false;
  bool _hasKidneyDisease = false;
  bool _hasCardiovascularDisease = false;
  bool _hasNeuropathy = false;
  bool _hasRetinopathy = false;
  bool _hasGastroparesis = false;
  bool _hasHypoglycemiaUnawareness = false;
  bool _isPregnant = false;
  bool _isBreastfeeding = false;

  String? _selectedPreferredUnit = 'metric';
  String? _selectedGlucoseUnit = 'mg_dl';
  String? _selectedTimezone;
  String? _selectedLanguage = 'id';
  String? _selectedActivityLevel = 'lightly_active';

  final List<String> _activityLevelOptions = [
    'sedentary', 'lightly_active', 'moderately_active', 'very_active', 'extremely_active'
  ];
  final List<String> _preferredUnitOptions = ['metric', 'imperial'];
  final Map<String, String> _glucoseUnitOptions = {'mg_dl': 'mg/dL', 'mmol_l': 'mmol/L'};
  final List<String> _timezoneOptions = [
    'Asia/Jakarta', 'Asia/Singapore', 'America/New_York', 'Europe/London', 'Australia/Sydney'
  ];
  final Map<String, String> _languageOptions = {'id': 'Indonesia'};

  bool _enableGlucoseAlerts = true;
  bool _enableMealReminders = true;
  bool _enableActivityReminders = true;
  bool _enableMedicationReminders = true;
  bool _shareDataForResearch = false;
  bool _shareAnonymizedData = false;

  // State untuk menentukan apakah data berasal dari mode 'advanced'
  bool _isAdvancedMode = false;

  @override
  void initState() {
    super.initState();
    _selectedTreatments = Map.fromIterable(
      _treatmentOptions.values,
      key: (item) => item as String,
      value: (item) => false,
    );
    // Data akan di-fetch oleh BlocProvider di atas
  }

  @override
  void dispose() {
    // Dispose semua controller
    _diagnosisDateController.dispose();
    _lastHba1cDateController.dispose();
    _heightController.dispose();
    _currentWeightController.dispose();
    _targetWeightController.dispose();
    _waistController.dispose();
    _bodyFatController.dispose();
    _hba1cTargetController.dispose();
    _lastHba1cController.dispose();
    _targetGlucoseFastingController.dispose();
    _targetGlucosePostprandialController.dispose();
    _insulinRegimenController.dispose();
    _cgmDeviceController.dispose();
    _dailyStepsGoalController.dispose();
    _weeklyExerciseGoalController.dispose();
    _preferredActivityController.dispose();
    _dietaryPatternController.dispose();
    _dailyCarbTargetController.dispose();
    _dailyCalorieTargetController.dispose();
    _dailyProteinTargetController.dispose();
    _dailyFatTargetController.dispose();
    _mealsPerDayController.dispose();
    _snacksPerDayController.dispose();
    _foodAllergiesController.dispose();
    _foodIntolerancesController.dispose();
    _foodsToAvoidController.dispose();
    _culturalCuisinesController.dispose();
    _dietaryRestrictionsController.dispose();
    _hypertensionMedicationController.dispose();
    _kidneyDiseaseStageController.dispose();
    _egfrValueController.dispose();
    _otherConditionsController.dispose();
    _smokingStatusController.dispose();
    _smokingYearsController.dispose();
    _alcoholFrequencyController.dispose();
    _alcoholDrinksPerWeekController.dispose();
    _stressLevelController.dispose();
    _typicalSleepHoursController.dispose();
    _sleepQualityController.dispose();
    _expectedDueDateController.dispose();
    super.dispose();
  }

  void _populateUI(HealthProfile healthProfile) {
    setState(() {
      _isAdvancedMode = healthProfile.appExperience == 'advanced';
      _selectedConditionId = healthProfile.conditionId;
      _diagnosisDateController.text = healthProfile.diagnosisDate?.toIso8601String().split('T').first ?? '';
      _heightController.text = healthProfile.heightCm?.toString() ?? '';
      _currentWeightController.text = healthProfile.currentWeightKg?.toString() ?? '';
      _targetWeightController.text = healthProfile.targetWeightKg?.toString() ?? '';
      _waistController.text = healthProfile.waistCircumferenceCm?.toString() ?? '';
      _bodyFatController.text = healthProfile.bodyFatPercentage?.toString() ?? '';
      _hba1cTargetController.text = healthProfile.hba1cTarget?.toString() ?? '';
      _lastHba1cController.text = healthProfile.lastHba1c?.toString() ?? '';
      _lastHba1cDateController.text = healthProfile.lastHba1cDate?.toIso8601String().split('T').first ?? '';
      _targetGlucoseFastingController.text = healthProfile.targetGlucoseFasting?.toString() ?? '';
      _targetGlucosePostprandialController.text = healthProfile.targetGlucosePostprandial?.toString() ?? '';

      _selectedTreatments.updateAll((key, value) => false);
      healthProfile.treatmentTypes?.forEach((type) {
        if (_selectedTreatments.containsKey(type)) {
          _selectedTreatments[type] = true;
        }
      });

      _insulinRegimenController.text = healthProfile.insulinRegimen ?? '';
      _usesCgm = healthProfile.usesCgm ?? false;
      _cgmDeviceController.text = healthProfile.cgmDevice ?? '';

      _selectedActivityLevel = healthProfile.activityLevel;
      _dailyStepsGoalController.text = healthProfile.dailyStepsGoal?.toString() ?? '';
      _weeklyExerciseGoalController.text = healthProfile.weeklyExerciseGoalMinutes?.toString() ?? '';
      _preferredActivityController.text = healthProfile.preferredActivityTypeIds?.join(', ') ?? '';
      _dietaryPatternController.text = healthProfile.dietaryPattern ?? '';
      _dailyCarbTargetController.text = healthProfile.dailyCarbTargetGrams?.toString() ?? '';
      _dailyCalorieTargetController.text = healthProfile.dailyCalorieTarget?.toString() ?? '';
      _dailyProteinTargetController.text = healthProfile.dailyProteinTargetGrams?.toString() ?? '';
      _dailyFatTargetController.text = healthProfile.dailyFatTargetGrams?.toString() ?? '';
      _mealsPerDayController.text = healthProfile.mealsPerDay?.toString() ?? '';
      _snacksPerDayController.text = healthProfile.snacksPerDay?.toString() ?? '';

      _foodAllergiesController.text = healthProfile.foodAllergies?.join(', ') ?? '';
      _foodIntolerancesController.text = healthProfile.foodIntolerances?.join(', ') ?? '';
      _foodsToAvoidController.text = healthProfile.foodsToAvoid?.join(', ') ?? '';
      _culturalCuisinesController.text = healthProfile.culturalCuisines?.join(', ') ?? '';
      _dietaryRestrictionsController.text = healthProfile.dietaryRestrictions?.join(', ') ?? '';

      _hasHypertension = healthProfile.hasHypertension ?? false;
      _hypertensionMedicationController.text = healthProfile.hypertensionMedication ?? '';
      _hasKidneyDisease = healthProfile.hasKidneyDisease ?? false;
      _kidneyDiseaseStageController.text = healthProfile.kidneyDiseaseStage?.toString() ?? '';
      _egfrValueController.text = healthProfile.egfrValue?.toString() ?? '';
      _hasCardiovascularDisease = healthProfile.hasCardiovascularDisease ?? false;
      _hasNeuropathy = healthProfile.hasNeuropathy ?? false;
      _hasRetinopathy = healthProfile.hasRetinopathy ?? false;
      _hasGastroparesis = healthProfile.hasGastroparesis ?? false;
      _hasHypoglycemiaUnawareness = healthProfile.hasHypoglycemiaUnawareness ?? false;
      _otherConditionsController.text = healthProfile.otherConditions?.join(', ') ?? '';

      _smokingStatusController.text = healthProfile.smokingStatus ?? '';
      _smokingYearsController.text = healthProfile.smokingYears?.toString() ?? '';
      _alcoholFrequencyController.text = healthProfile.alcoholFrequency ?? '';
      _alcoholDrinksPerWeekController.text = healthProfile.alcoholDrinksPerWeek?.toString() ?? '';
      _stressLevelController.text = healthProfile.stressLevel ?? '';
      _typicalSleepHoursController.text = healthProfile.typicalSleepHours?.toString() ?? '';
      _sleepQualityController.text = healthProfile.sleepQuality ?? '';
      _isPregnant = healthProfile.isPregnant ?? false;
      _isBreastfeeding = healthProfile.isBreastfeeding ?? false;
      _expectedDueDateController.text = healthProfile.expectedDueDate?.toIso8601String().split('T').first ?? '';

      _selectedPreferredUnit = healthProfile.preferredUnits;
      _selectedGlucoseUnit = healthProfile.glucoseUnit;
      _selectedTimezone = healthProfile.timezone;
      _selectedLanguage = healthProfile.languageCode;
      _enableGlucoseAlerts = healthProfile.enableGlucoseAlerts ?? true;
      _enableMealReminders = healthProfile.enableMealReminders ?? true;
      _enableActivityReminders = healthProfile.enableActivityReminders ?? true;
      _enableMedicationReminders = healthProfile.enableMedicationReminders ?? true;
      _shareDataForResearch = healthProfile.shareDataForResearch ?? false;
      _shareAnonymizedData = healthProfile.shareAnonymizedData ?? false;
    });
  }

  HealthProfile _collectHealthProfileData() {
    return HealthProfile(
      appExperience: _isAdvancedMode ? 'advanced' : 'simple',
      conditionId: _selectedConditionId,
      diagnosisDate: DateTime.tryParse(_diagnosisDateController.text),
      heightCm: double.tryParse(_heightController.text),
      currentWeightKg: double.tryParse(_currentWeightController.text),
      targetWeightKg: double.tryParse(_targetWeightController.text),
      waistCircumferenceCm: double.tryParse(_waistController.text),
      bodyFatPercentage: double.tryParse(_bodyFatController.text),
      hba1cTarget: double.tryParse(_hba1cTargetController.text),
      lastHba1c: double.tryParse(_lastHba1cController.text),
      lastHba1cDate: DateTime.tryParse(_lastHba1cDateController.text),
      targetGlucoseFasting: int.tryParse(_targetGlucoseFastingController.text),
      targetGlucosePostprandial: int.tryParse(_targetGlucosePostprandialController.text),
      treatmentTypes: _selectedTreatments.entries.where((e) => e.value).map((e) => e.key).toList(),
      insulinRegimen: _insulinRegimenController.text.isNotEmpty ? _insulinRegimenController.text : null,
      usesCgm: _usesCgm,
      cgmDevice: _cgmDeviceController.text.isNotEmpty ? _cgmDeviceController.text : null,
      activityLevel: _selectedActivityLevel,
      dailyStepsGoal: int.tryParse(_dailyStepsGoalController.text),
      weeklyExerciseGoalMinutes: int.tryParse(_weeklyExerciseGoalController.text),
      preferredActivityTypeIds: _preferredActivityController.text.isNotEmpty
          ? _preferredActivityController.text.split(',').map((e) => int.tryParse(e.trim())).whereType<int>().toList()
          : null,
      dietaryPattern: _dietaryPatternController.text.isNotEmpty ? _dietaryPatternController.text : null,
      dailyCarbTargetGrams: int.tryParse(_dailyCarbTargetController.text),
      dailyCalorieTarget: int.tryParse(_dailyCalorieTargetController.text),
      dailyProteinTargetGrams: int.tryParse(_dailyProteinTargetController.text),
      dailyFatTargetGrams: int.tryParse(_dailyFatTargetController.text),
      mealsPerDay: int.tryParse(_mealsPerDayController.text),
      snacksPerDay: int.tryParse(_snacksPerDayController.text),
      foodAllergies: _foodAllergiesController.text.isNotEmpty ? _foodAllergiesController.text.split(',').map((e) => e.trim()).toList() : null,
      foodIntolerances: _foodIntolerancesController.text.isNotEmpty ? _foodIntolerancesController.text.split(',').map((e) => e.trim()).toList() : null,
      foodsToAvoid: _foodsToAvoidController.text.isNotEmpty ? _foodsToAvoidController.text.split(',').map((e) => e.trim()).toList() : null,
      culturalCuisines: _culturalCuisinesController.text.isNotEmpty ? _culturalCuisinesController.text.split(',').map((e) => e.trim()).toList() : null,
      dietaryRestrictions: _dietaryRestrictionsController.text.isNotEmpty ? _dietaryRestrictionsController.text.split(',').map((e) => e.trim()).toList() : null,
      hasHypertension: _hasHypertension,
      hypertensionMedication: _hypertensionMedicationController.text.isNotEmpty ? _hypertensionMedicationController.text : null,
      hasKidneyDisease: _hasKidneyDisease,
      kidneyDiseaseStage: int.tryParse(_kidneyDiseaseStageController.text),
      egfrValue: double.tryParse(_egfrValueController.text),
      hasCardiovascularDisease: _hasCardiovascularDisease,
      hasNeuropathy: _hasNeuropathy,
      hasRetinopathy: _hasRetinopathy,
      hasGastroparesis: _hasGastroparesis,
      hasHypoglycemiaUnawareness: _hasHypoglycemiaUnawareness,
      otherConditions: _otherConditionsController.text.isNotEmpty ? _otherConditionsController.text.split(',').map((e) => e.trim()).toList() : null,
      smokingStatus: _smokingStatusController.text.isNotEmpty ? _smokingStatusController.text : null,
      smokingYears: int.tryParse(_smokingYearsController.text),
      alcoholFrequency: _alcoholFrequencyController.text.isNotEmpty ? _alcoholFrequencyController.text : null,
      alcoholDrinksPerWeek: int.tryParse(_alcoholDrinksPerWeekController.text),
      stressLevel: _stressLevelController.text.isNotEmpty ? _stressLevelController.text : null,
      typicalSleepHours: double.tryParse(_typicalSleepHoursController.text),
      sleepQuality: _sleepQualityController.text.isNotEmpty ? _sleepQualityController.text : null,
      isPregnant: _isPregnant,
      isBreastfeeding: _isBreastfeeding,
      expectedDueDate: DateTime.tryParse(_expectedDueDateController.text),
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
  }

  void _saveChanges() {
    context.read<HealthProfileCubit>().saveHealthProfile(_collectHealthProfileData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80, // Menyamakan tinggi AppBar
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        title: const Text(
          'Edit Profil Kesehatan',
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
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is HealthProfileSaved) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profil kesehatan berhasil diperbarui!')));
            Navigator.of(context).pop();
          } else if (state is HealthProfileSaveError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal menyimpan profil: ${state.message}')));
          }
        },
        builder: (context, state) {
          if (state is HealthProfileLoading && _heightController.text.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // Selalu tampilkan form, loading indicator akan muncul di tombol simpan
          return _buildEditForm(state);
        },
      ),
    );
  }

  Widget _buildEditForm(HealthProfileState state) {
    // Menggabungkan semua section builder menjadi satu list widget
    final sections = _getAllSections();

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: sections,
            ),
          ),
        ),
        // Tombol Simpan di bagian bawah
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: ElevatedButton(
            onPressed: state is HealthProfileSaving ? null : _saveChanges,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
              elevation: 5,
            ),
            child: state is HealthProfileSaving
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Simpan Perubahan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  List<Widget> _getAllSections() {
    bool isT2dOrPrediabetes = _selectedConditionId == 1 || _selectedConditionId == 2;
    bool isT2d = _selectedConditionId == 1;

    return [
      _buildSectionContainer('Informasi Dasar', _buildCoreIdentitySection(_isAdvancedMode)),
      _buildSectionContainer('Biometrik & Target', _buildBiometricsAndTargetsSection(_isAdvancedMode)),
      if (isT2dOrPrediabetes)
        _buildSectionContainer('Perawatan', _buildTreatmentsSection(_isAdvancedMode)),
      if (_isAdvancedMode && isT2d)
        _buildSectionContainer('Medikasi & CGM Lanjutan', _buildAdvancedMedicationSection(_isAdvancedMode)),
      _buildSectionContainer('Aktivitas & Gaya Hidup', _buildActivityLifestyleSection(_isAdvancedMode)),
      if (_isAdvancedMode)
        _buildSectionContainer('Target Diet Lanjutan', _buildAdvancedDietarySection(_isAdvancedMode)),
      _buildSectionContainer('Preferensi & Pantangan', _buildPreferencesSection(_isAdvancedMode)),
      _buildSectionContainer('Kondisi Penyerta & Kehamilan', _buildComorbiditiesSection(_isAdvancedMode)),
      if (_isAdvancedMode)
        _buildSectionContainer('Faktor Gaya Hidup Lain', _buildLifestyleFactorsSection(_isAdvancedMode)),
      _buildSectionContainer('Pengaturan Aplikasi', _buildAppSettingsSection(_isAdvancedMode)),
    ];
  }

  // Helper untuk membungkus setiap section dengan judul
  Widget _buildSectionContainer(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary),
        ),
        const SizedBox(height: 16),
        content,
        const SizedBox(height: 32), // Spasi antar section
      ],
    );
  }

  // --- SEMUA WIDGET BUILDER DARI HealthProfilePage DISALIN KE SINI ---
  // (buildCoreIdentitySection, buildBiometricsAndTargetsSection, dst.)

  Widget _buildCoreIdentitySection(bool isAdvanced) {
    bool isT2dOrPrediabetes = _selectedConditionId == 1 || _selectedConditionId == 2;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Pengalaman Aplikasi'),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              _buildExperienceToggle(
                  'Simple', false, 'assets/images/simple.svg'),
              _buildExperienceToggle(
                  'Advanced', true, 'assets/images/advanced.svg'),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _buildSectionTitle('Kondisi Utama', isMandatory: true),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: _healthConditions.entries.map((entry) {
            return ChoiceChip(
              label: Text(entry.value),
              selected: _selectedConditionId == entry.key,
              onSelected: (isSelected) {
                setState(() {
                  if (isSelected) _selectedConditionId = entry.key;
                });
              },
              selectedColor: Theme.of(context).colorScheme.primary,
              labelStyle: TextStyle(
                color: _selectedConditionId == entry.key ? Colors.white : Colors.black,
              ),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: Colors.grey.shade300)),
              checkmarkColor: Colors.white,
            );
          }).toList(),
        ),
        Visibility(
          visible: isT2dOrPrediabetes,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _buildSectionTitle('Tanggal Diagnosis', isMandatory: true),
              TextFormField(
                controller: _diagnosisDateController,
                readOnly: true,
                decoration: _inputDecoration(hintText: 'Pilih Tanggal'),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context, initialDate: DateTime.tryParse(_diagnosisDateController.text) ?? DateTime.now(),
                    firstDate: DateTime(1900), lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    String formattedDate = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                    _diagnosisDateController.text = formattedDate;
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBiometricsAndTargetsSection(bool isAdvanced) {
    bool isT2dOrPrediabetes = _selectedConditionId == 1 || _selectedConditionId == 2;
    bool isObesity = _selectedConditionId == 3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Tinggi (cm)', isMandatory: true),
        _buildTextField(
          controller: _heightController, hintText: 'Tinggi (100 - 250 cm)', keyboardType: TextInputType.number,
          formatters: [_NumberRangeInputFormatter(minValue: 100, maxValue: 250)],
        ),
        const SizedBox(height: 16),
        _buildSectionTitle('Berat Badan Saat Ini (kg)', isMandatory: true),
        _buildTextField(
          controller: _currentWeightController, hintText: 'Berat (20 - 300 kg)', keyboardType: TextInputType.number,
          formatters: [_NumberRangeInputFormatter(minValue: 20, maxValue: 300)],
        ),
        const SizedBox(height: 16),
        _buildTextField(controller: _targetWeightController, hintText: 'Target Berat Badan (kg)', keyboardType: TextInputType.number),

        Visibility(
          visible: isAdvanced && isObesity,
          child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _buildSectionTitle('Biometrik Tambahan (Opsional)'),
              Row(
                children: [
                  Expanded(child: _buildTextField(controller: _waistController, hintText: 'Pinggang (cm)', keyboardType: TextInputType.number)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField(controller: _bodyFatController, hintText: 'Lemak Tubuh (%)', keyboardType: TextInputType.number)),
                ],
              ),
            ],
          ),
        ),

        Visibility(
          visible: isT2dOrPrediabetes,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              _buildSectionTitle('Target Laboratorium (HbA1c)', isMandatory: true),
              _buildTextField(
                controller: _hba1cTargetController, hintText: 'Target HbA1c (4.0 - 10.0)', keyboardType: TextInputType.number,
                formatters: [_NumberRangeInputFormatter(minValue: 4.0, maxValue: 10.0)],
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _lastHba1cController, hintText: 'HbA1c Terakhir (4.0 - 20.0)', keyboardType: TextInputType.number,
                formatters: [_NumberRangeInputFormatter(minValue: 4.0, maxValue: 20.0)],
              ),
              const SizedBox(height: 16),
              _buildSectionTitle('Tanggal HbA1c Terakhir'),
              TextFormField(
                controller: _lastHba1cDateController, readOnly: true,
                decoration: _inputDecoration(hintText: 'Pilih Tanggal'),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(context: context, initialDate: DateTime.tryParse(_lastHba1cDateController.text) ?? DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime.now());
                  if (pickedDate != null) {
                    String formattedDate = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                    _lastHba1cDateController.text = formattedDate;
                  }
                },
              ),
              const SizedBox(height: 16),
              _buildSectionTitle('Target Gula Darah', isMandatory: true),
              _buildTextField(controller: _targetGlucoseFastingController, hintText: 'Gula Darah Puasa (mg/dL)', keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              _buildTextField(controller: _targetGlucosePostprandialController, hintText: 'Gula Darah Setelah Makan (mg/dL)', keyboardType: TextInputType.number),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTreatmentsSection(bool isAdvanced) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Jenis Perawatan / Pengobatan Saat Ini'),
        Text('Pilih semua yang sedang Anda jalani.', style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: _treatmentOptions.entries.map((entry) {
            final displayName = entry.key;
            final backendValue = entry.value;
            return _buildCustomCircularCheckbox(
              title: displayName,
              value: _selectedTreatments[backendValue] ?? false,
              onChanged: (bool? newValue) {
                setState(() => _selectedTreatments[backendValue] = newValue ?? false);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAdvancedMedicationSection(bool isAdvanced) {
    bool usesInsulin = _selectedTreatments['insulin'] ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: usesInsulin,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Regimen Insulin'),
              _buildTextField(
                  controller: _insulinRegimenController,
                  hintText: 'Contoh: basal_bolus, mixed_split'),
              const SizedBox(height: 16),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Monitoring Gula Darah'),
            _buildCheckboxTile(
              title: 'Menggunakan CGM (Continuous Glucose Monitor)',
              value: _usesCgm,
              onChanged: (bool? newValue) {
                setState(() => _usesCgm = newValue ?? false);
              },
            ),
            Visibility(
              visible: _usesCgm,
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: _buildTextField(
                    controller: _cgmDeviceController,
                    hintText: 'Merek/Tipe CGM'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActivityLifestyleSection(bool isAdvanced) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Tingkat Aktivitas Umum'),
        _buildDropdown(
            hint: 'Pilih Tingkat Aktivitas',
            value: _selectedActivityLevel,
            items: _activityLevelOptions,
            onChanged: (val) => setState(() => _selectedActivityLevel = val)),
        const SizedBox(height: 16),
        _buildSectionTitle('Target Langkah Harian'),
        _buildTextField(controller: _dailyStepsGoalController, hintText: 'Contoh: 8000', keyboardType: TextInputType.number),
        const SizedBox(height: 16),
        _buildSectionTitle('Target Olahraga Mingguan (menit)'),
        _buildTextField(controller: _weeklyExerciseGoalController, hintText: 'Contoh: 150', keyboardType: TextInputType.number),
        const SizedBox(height: 16),
        _buildSectionTitle('Jenis Aktivitas Favorit'),
        _buildTextField(controller: _preferredActivityController, hintText: 'Contoh: jalan kaki, berenang (pisahkan koma)'),
        const SizedBox(height: 16),
        _buildSectionTitle('Pola Diet'),
        _buildTextField(controller: _dietaryPatternController, hintText: 'Contoh: low_carb, standard, mediterranean'),
      ],
    );
  }

  Widget _buildAdvancedDietarySection(bool isAdvanced) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Target Makronutrien Harian'),
        _buildTextField(controller: _dailyCarbTargetController, hintText: 'Target Karbohidrat (gram)', keyboardType: TextInputType.number),
        const SizedBox(height: 16),
        _buildTextField(controller: _dailyCalorieTargetController, hintText: 'Target Kalori (kkal)', keyboardType: TextInputType.number),
        const SizedBox(height: 16),
        _buildTextField(controller: _dailyProteinTargetController, hintText: 'Target Protein (gram)', keyboardType: TextInputType.number),
        const SizedBox(height: 16),
        _buildTextField(controller: _dailyFatTargetController, hintText: 'Target Lemak (gram)', keyboardType: TextInputType.number),
        const SizedBox(height: 24),
        _buildSectionTitle('Frekuensi Makan'),
        _buildTextField(controller: _mealsPerDayController, hintText: 'Jumlah makan utama per hari', keyboardType: TextInputType.number),
        const SizedBox(height: 16),
        _buildTextField(controller: _snacksPerDayController, hintText: 'Jumlah cemilan per hari', keyboardType: TextInputType.number),
      ],
    );
  }

  Widget _buildPreferencesSection(bool isAdvanced) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Alergi Makanan'),
        _buildTextField(controller: _foodAllergiesController, hintText: 'Contoh: kerang, udang (pisahkan koma)'),
        const SizedBox(height: 16),
        _buildSectionTitle('Intoleransi Makanan'),
        _buildTextField(controller: _foodIntolerancesController, hintText: 'Contoh: laktosa, gluten (pisahkan koma)'),
        const SizedBox(height: 16),
        _buildSectionTitle('Makanan yang Dihindari'),
        _buildTextField(controller: _foodsToAvoidController, hintText: 'Contoh: mie instan, soda (pisahkan koma)'),
        const SizedBox(height: 16),
        _buildSectionTitle('Preferensi Masakan'),
        _buildTextField(controller: _culturalCuisinesController, hintText: 'Contoh: indonesia, asia, mediterania (pisahkan koma)'),
        const SizedBox(height: 16),
        _buildSectionTitle('Pantangan Diet Khusus'),
        _buildTextField(controller: _dietaryRestrictionsController, hintText: 'Contoh: halal, vegetarian (pisahkan koma)'),
      ],
    );
  }

  Widget _buildComorbiditiesSection(bool isAdvanced) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Riwayat Penyakit Penyerta (PENTING)'),
        _buildCheckboxTile(title: 'Memiliki Hipertensi?', value: _hasHypertension, onChanged: (val) => setState(() => _hasHypertension = val ?? false)),
        Visibility(
          visible: isAdvanced && _hasHypertension,
          child: Padding(
            padding: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
            child: _buildTextField(controller: _hypertensionMedicationController, hintText: 'Sebutkan obat hipertensi'),
          ),
        ),
        const SizedBox(height: 8),
        _buildCheckboxTile(title: 'Memiliki Penyakit Ginjal?', value: _hasKidneyDisease, onChanged: (val) => setState(() => _hasKidneyDisease = val ?? false)),
        Visibility(
          visible: isAdvanced && _hasKidneyDisease,
          child: Padding(
            padding: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
            child: Column(children: [
              _buildTextField(controller: _kidneyDiseaseStageController, hintText: 'Stadium penyakit ginjal'),
              const SizedBox(height: 8),
              _buildTextField(controller: _egfrValueController, hintText: 'Nilai eGFR terakhir'),
            ],),
          ),
        ),
        const SizedBox(height: 8),
        if(isAdvanced) ...[
          _buildCheckboxTile(title: 'Memiliki Penyakit Kardiovaskular?', value: _hasCardiovascularDisease, onChanged: (val)=> setState(() => _hasCardiovascularDisease = val ?? false)),
          const SizedBox(height: 8),
          _buildCheckboxTile(title: 'Memiliki Neuropati?', value: _hasNeuropathy, onChanged: (val)=> setState(() => _hasNeuropathy = val ?? false)),
          const SizedBox(height: 8),
          _buildCheckboxTile(title: 'Memiliki Retinopati?', value: _hasRetinopathy, onChanged: (val)=> setState(() => _hasRetinopathy = val ?? false)),
          const SizedBox(height: 8),
          _buildCheckboxTile(title: 'Memiliki Gastroparesis?', value: _hasGastroparesis, onChanged: (val)=> setState(() => _hasGastroparesis = val ?? false)),
          const SizedBox(height: 8),
          _buildCheckboxTile(title: 'Tidak Sadar Hipoglikemia?', value: _hasHypoglycemiaUnawareness, onChanged: (val)=> setState(() => _hasHypoglycemiaUnawareness = val ?? false)),
          const SizedBox(height: 16),
          _buildSectionTitle('Kondisi Lain'),
          _buildTextField(controller: _otherConditionsController, hintText: 'Contoh: masalah tiroid (pisahkan koma)'),
          const SizedBox(height: 24),
        ],

        _buildSectionTitle('Status Kehamilan (PENTING)'),
         _buildCheckboxTile(title: 'Sedang Hamil?', value: _isPregnant, onChanged: (val) => setState(() => _isPregnant = val ?? false)),

      ],
    );
  }

  Widget _buildLifestyleFactorsSection(bool isAdvanced) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Gaya Hidup'),
        _buildTextField(controller: _smokingStatusController, hintText: 'Status Merokok (e.g., former, current, never)'),
        const SizedBox(height: 16),
         _buildTextField(controller: _smokingYearsController, hintText: 'Jumlah tahun merokok', keyboardType: TextInputType.number),
        const SizedBox(height: 16),
        _buildTextField(controller: _alcoholFrequencyController, hintText: 'Frekuensi Alkohol (e.g., rarely, weekly)'),
        const SizedBox(height: 16),
        _buildTextField(controller: _alcoholDrinksPerWeekController, hintText: 'Minuman beralkohol per minggu', keyboardType: TextInputType.number),
        const SizedBox(height: 16),
        _buildSectionTitle('Stres & Tidur'),
        _buildTextField(controller: _stressLevelController, hintText: 'Tingkat Stres (e.g., moderate, high)'),
        const SizedBox(height: 16),
        _buildTextField(controller: _typicalSleepHoursController, hintText: 'Jam Tidur Rata-rata', keyboardType: TextInputType.number),
        const SizedBox(height: 16),
        _buildTextField(controller: _sleepQualityController, hintText: 'Kualitas Tidur (e.g., good, poor)'),

        const SizedBox(height: 24),
        Visibility(
          visible: _isPregnant,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Kehamilan Lanjutan'),
              _buildCheckboxTile(title: 'Sedang Menyusui?', value: _isBreastfeeding, onChanged: (val) => setState(() => _isBreastfeeding = val ?? false)),
              const SizedBox(height: 16),
              _buildSectionTitle('Perkiraan Tanggal Lahir'),
               TextFormField(
                controller: _expectedDueDateController,
                readOnly: true,
                decoration: _inputDecoration(hintText: 'Pilih Tanggal'),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context, initialDate: DateTime.tryParse(_expectedDueDateController.text) ?? DateTime.now(),
                    firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 300)),
                  );
                  if (pickedDate != null) {
                    String formattedDate = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                    _expectedDueDateController.text = formattedDate;
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppSettingsSection(bool isAdvanced) {
    return Column(
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
                color: _selectedPreferredUnit == unit ? Colors.white : Colors.black,
              ),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: Colors.grey.shade300)),
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
                color: _selectedGlucoseUnit == backendValue ? Colors.white : Colors.black,
              ),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: Colors.grey.shade300)),
              checkmarkColor: Colors.white,
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        _buildSectionTitle('Zona Waktu'),
        _buildDropdown(hint: 'Pilih Zona Waktu', value: _selectedTimezone, items: _timezoneOptions, onChanged: (val) => setState(() => _selectedTimezone = val)),
        const SizedBox(height: 16),
        _buildSectionTitle('Bahasa'),
        _buildDropdown(hint: 'Pilih Bahasa', value: _selectedLanguage, items: _languageOptions.keys.toList(), displayBuilder: (val) => _languageOptions[val] ?? val, onChanged: (val) => setState(() => _selectedLanguage = val)),
        const SizedBox(height: 24),
        _buildSectionTitle('Notifikasi & Pengingat'),
        _buildSettingSwitchTile(title: 'Notifikasi Gula Darah', value: _enableGlucoseAlerts, onChanged: (val) => setState(() => _enableGlucoseAlerts = val)),
        _buildSettingSwitchTile(title: 'Pengingat Makan', value: _enableMealReminders, onChanged: (val) => setState(() => _enableMealReminders = val)),
        _buildSettingSwitchTile(title: 'Pengingat Aktivitas', value: _enableActivityReminders, onChanged: (val) => setState(() => _enableActivityReminders = val)),
        _buildSettingSwitchTile(title: 'Pengingat Obat', value: _enableMedicationReminders, onChanged: (val) => setState(() => _enableMedicationReminders = val)),
        const SizedBox(height: 24),
        _buildSectionTitle('Privasi & Data'),
        _buildSettingSwitchTile(title: 'Bagikan data untuk riset', value: _shareDataForResearch, onChanged: (val) => setState(() => _shareDataForResearch = val)),
        _buildSettingSwitchTile(title: 'Bagikan data anonim', value: _shareAnonymizedData, onChanged: (val) => setState(() => _shareAnonymizedData = val)),
      ],
    );
  }

  // --- WIDGET HELPERS ---

  Widget _buildExperienceToggle(String title, bool isAdvanced, String iconAsset) {
    bool isSelected = _isAdvancedMode == isAdvanced;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _isAdvancedMode = isAdvanced),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                iconAsset,
                colorFilter: ColorFilter.mode(
                    isSelected ? Colors.white : Colors.grey.shade600,
                    BlendMode.srcIn),
                width: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.grey.shade800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, {bool isMandatory = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
      child: RichText(
        text: TextSpan(
          text: title,
          style: const TextStyle(
            fontFamily: 'Poppins', // Pastikan font family sama
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          children: [
            if (isMandatory)
              const TextSpan(
                text: ' *',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    TextEditingController? controller,
    List<TextInputFormatter>? formatters,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: formatters,
      decoration: _inputDecoration(hintText: hintText),
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
      hint: Text(hint, style: const TextStyle(color: AppTheme.inputLabelColor, fontSize: 14)),
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
        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  Widget _buildCheckboxTile({
    required String title,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: value
              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: value
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              value ? Icons.check_circle : Icons.radio_button_unchecked,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child:
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomCircularCheckbox({
    required String title,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: value ? Theme.of(context).colorScheme.primary.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: value ? Theme.of(context).colorScheme.primary : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              value ? Icons.check_circle : Icons.radio_button_unchecked,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Flexible(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w500))),
          ],
        ),
      ),
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

/// Formatter untuk membatasi input numerik dalam rentang tertentu.
class _NumberRangeInputFormatter extends TextInputFormatter {
  final double minValue;
  final double maxValue;

  _NumberRangeInputFormatter({required this.minValue, required this.maxValue});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final double? parsedValue = double.tryParse(newValue.text);

    if (parsedValue == null) {
      return oldValue; // Jangan izinkan input non-numerik
    }

    if (parsedValue > maxValue) {
      final correctedValue = maxValue.toStringAsFixed(maxValue.truncateToDouble() == maxValue ? 0 : 2);
      return TextEditingValue(text: correctedValue, selection: TextSelection.collapsed(offset: correctedValue.length));
    }

    return newValue; // Izinkan input jika valid atau di bawah max
  }
}