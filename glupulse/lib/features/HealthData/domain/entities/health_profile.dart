import 'package:equatable/equatable.dart';

class HealthProfile extends Equatable {
  // CORE IDENTITY & SETUP
  final String? appExperience;
  final int? conditionId;
  final DateTime? diagnosisDate;

  // BIOMETRICS & TARGETS
  final double? heightCm;
  final double? currentWeightKg;
  final double? targetWeightKg;
  final double? bmi;
  final double? waistCircumferenceCm;
  final double? bodyFatPercentage;
  final double? hba1cTarget;
  final double? lastHba1c;
  final DateTime? lastHba1cDate;
  final int? targetGlucoseFasting;
  final int? targetGlucosePostprandial;

  // MEDICATION & CGM USAGE
  final List<String>? treatmentTypes;
  final String? insulinRegimen;
  final bool? usesCgm;
  final String? cgmDevice;

  // ACTIVITY & LIFESTYLE GOALS
  final String? activityLevel;
  final int? dailyStepsGoal;
  final int? weeklyExerciseGoalMinutes;
  final List<int>? preferredActivityTypeIds;
  final String? dietaryPattern;
  final int? dailyCarbTargetGrams;
  final int? dailyCalorieTarget;
  final int? dailyProteinTargetGrams;
  final int? dailyFatTargetGrams;
  final int? mealsPerDay;
  final int? snacksPerDay;

  // PREFERENCES & RESTRICTIONS
  final List<String>? foodAllergies;
  final List<String>? foodIntolerances;
  final List<String>? foodsToAvoid;
  final List<String>? culturalCuisines;
  final List<String>? dietaryRestrictions;

  // COMORBIDITIES
  final bool? hasHypertension;
  final String? hypertensionMedication;
  final bool? hasKidneyDisease;
  final int? kidneyDiseaseStage;
  final double? egfrValue;
  final bool? hasCardiovascularDisease;
  final bool? hasNeuropathy;
  final bool? hasRetinopathy;
  final bool? hasGastroparesis;
  final bool? hasHypoglycemiaUnawareness;
  final List<String>? otherConditions;

  // LIFESTYLE FACTORS & APP SETTINGS
  final String? smokingStatus;
  final int? smokingYears;
  final String? alcoholFrequency;
  final int? alcoholDrinksPerWeek;
  final String? stressLevel;
  final double? typicalSleepHours;
  final String? sleepQuality;
  final bool? isPregnant;
  final bool? isBreastfeeding;
  final DateTime? expectedDueDate;

  // APP SETTINGS
  final String? preferredUnits;
  final String? glucoseUnit;
  final String? timezone;
  final String? languageCode;
  final bool? enableGlucoseAlerts;
  final bool? enableMealReminders;
  final bool? enableActivityReminders;
  final bool? enableMedicationReminders;
  final bool? shareDataForResearch;
  final bool? shareAnonymizedData;

  const HealthProfile({
    this.appExperience,
    this.conditionId,
    this.diagnosisDate,
    this.heightCm,
    this.currentWeightKg,
    this.targetWeightKg,
    this.bmi,
    this.waistCircumferenceCm,
    this.bodyFatPercentage,
    this.hba1cTarget,
    this.lastHba1c,
    this.lastHba1cDate,
    this.targetGlucoseFasting,
    this.targetGlucosePostprandial,
    this.treatmentTypes,
    this.insulinRegimen,
    this.usesCgm,
    this.cgmDevice,
    this.activityLevel,
    this.dailyStepsGoal,
    this.weeklyExerciseGoalMinutes,
    this.preferredActivityTypeIds,
    this.dietaryPattern,
    this.dailyCarbTargetGrams,
    this.dailyCalorieTarget,
    this.dailyProteinTargetGrams,
    this.dailyFatTargetGrams,
    this.mealsPerDay,
    this.snacksPerDay,
    this.foodAllergies,
    this.foodIntolerances,
    this.foodsToAvoid,
    this.culturalCuisines,
    this.dietaryRestrictions,
    this.hasHypertension,
    this.hypertensionMedication,
    this.hasKidneyDisease,
    this.kidneyDiseaseStage,
    this.egfrValue,
    this.hasCardiovascularDisease,
    this.hasNeuropathy,
    this.hasRetinopathy,
    this.hasGastroparesis,
    this.hasHypoglycemiaUnawareness,
    this.otherConditions,
    this.smokingStatus,
    this.smokingYears,
    this.alcoholFrequency,
    this.alcoholDrinksPerWeek,
    this.stressLevel,
    this.typicalSleepHours,
    this.sleepQuality,
    this.isPregnant,
    this.isBreastfeeding,
    this.expectedDueDate,
    this.preferredUnits,
    this.glucoseUnit,
    this.timezone,
    this.languageCode,
    this.enableGlucoseAlerts,
    this.enableMealReminders,
    this.enableActivityReminders,
    this.enableMedicationReminders,
    this.shareDataForResearch,
    this.shareAnonymizedData,
  });

  HealthProfile copyWith({
    String? appExperience,
    int? conditionId,
    DateTime? diagnosisDate,
    double? heightCm,
    double? currentWeightKg,
    double? targetWeightKg,
    double? bmi,
    double? waistCircumferenceCm,
    double? bodyFatPercentage,
    double? hba1cTarget,
    double? lastHba1c,
    DateTime? lastHba1cDate,
    int? targetGlucoseFasting,
    int? targetGlucosePostprandial,
    List<String>? treatmentTypes,
    String? insulinRegimen,
    bool? usesCgm,
    String? cgmDevice,
    String? activityLevel,
    int? dailyStepsGoal,
    int? weeklyExerciseGoalMinutes,
    List<int>? preferredActivityTypeIds,
    String? dietaryPattern,
    int? dailyCarbTargetGrams,
    int? dailyCalorieTarget,
    int? dailyProteinTargetGrams,
    int? dailyFatTargetGrams,
    int? mealsPerDay,
    int? snacksPerDay,
    List<String>? foodAllergies,
    List<String>? foodIntolerances,
    List<String>? foodsToAvoid,
    List<String>? culturalCuisines,
    List<String>? dietaryRestrictions,
    bool? hasHypertension,
    String? hypertensionMedication,
    bool? hasKidneyDisease,
    int? kidneyDiseaseStage,
    double? egfrValue,
    bool? hasCardiovascularDisease,
    bool? hasNeuropathy,
    bool? hasRetinopathy,
    bool? hasGastroparesis,
    bool? hasHypoglycemiaUnawareness,
    List<String>? otherConditions,
    String? smokingStatus,
    int? smokingYears,
    String? alcoholFrequency,
    int? alcoholDrinksPerWeek,
    String? stressLevel,
    double? typicalSleepHours,
    String? sleepQuality,
    bool? isPregnant,
    bool? isBreastfeeding,
    DateTime? expectedDueDate,
    String? preferredUnits,
    String? glucoseUnit,
    String? timezone,
    String? languageCode,
    bool? enableGlucoseAlerts,
    bool? enableMealReminders,
    bool? enableActivityReminders,
    bool? enableMedicationReminders,
    bool? shareDataForResearch,
    bool? shareAnonymizedData,
  }) {
    return HealthProfile(
      appExperience: appExperience ?? this.appExperience,
      conditionId: conditionId ?? this.conditionId,
      diagnosisDate: diagnosisDate ?? this.diagnosisDate,
      heightCm: heightCm ?? this.heightCm,
      currentWeightKg: currentWeightKg ?? this.currentWeightKg,
      targetWeightKg: targetWeightKg ?? this.targetWeightKg,
      bmi: bmi ?? this.bmi,
      waistCircumferenceCm: waistCircumferenceCm ?? this.waistCircumferenceCm,
      bodyFatPercentage: bodyFatPercentage ?? this.bodyFatPercentage,
      hba1cTarget: hba1cTarget ?? this.hba1cTarget,
      lastHba1c: lastHba1c ?? this.lastHba1c,
      lastHba1cDate: lastHba1cDate ?? this.lastHba1cDate,
      targetGlucoseFasting: targetGlucoseFasting ?? this.targetGlucoseFasting,
      targetGlucosePostprandial: targetGlucosePostprandial ?? this.targetGlucosePostprandial,
      treatmentTypes: treatmentTypes ?? this.treatmentTypes,
      insulinRegimen: insulinRegimen ?? this.insulinRegimen,
      usesCgm: usesCgm ?? this.usesCgm,
      cgmDevice: cgmDevice ?? this.cgmDevice,
      activityLevel: activityLevel ?? this.activityLevel,
      dailyStepsGoal: dailyStepsGoal ?? this.dailyStepsGoal,
      weeklyExerciseGoalMinutes: weeklyExerciseGoalMinutes ?? this.weeklyExerciseGoalMinutes,
      preferredActivityTypeIds: preferredActivityTypeIds ?? this.preferredActivityTypeIds,
      dietaryPattern: dietaryPattern ?? this.dietaryPattern,
      dailyCarbTargetGrams: dailyCarbTargetGrams ?? this.dailyCarbTargetGrams,
      dailyCalorieTarget: dailyCalorieTarget ?? this.dailyCalorieTarget,
      dailyProteinTargetGrams: dailyProteinTargetGrams ?? this.dailyProteinTargetGrams,
      dailyFatTargetGrams: dailyFatTargetGrams ?? this.dailyFatTargetGrams,
      mealsPerDay: mealsPerDay ?? this.mealsPerDay,
      snacksPerDay: snacksPerDay ?? this.snacksPerDay,
      foodAllergies: foodAllergies ?? this.foodAllergies,
      foodIntolerances: foodIntolerances ?? this.foodIntolerances,
      foodsToAvoid: foodsToAvoid ?? this.foodsToAvoid,
      culturalCuisines: culturalCuisines ?? this.culturalCuisines,
      dietaryRestrictions: dietaryRestrictions ?? this.dietaryRestrictions,
      hasHypertension: hasHypertension ?? this.hasHypertension,
      hypertensionMedication: hypertensionMedication ?? this.hypertensionMedication,
      hasKidneyDisease: hasKidneyDisease ?? this.hasKidneyDisease,
      kidneyDiseaseStage: kidneyDiseaseStage ?? this.kidneyDiseaseStage,
      egfrValue: egfrValue ?? this.egfrValue,
      hasCardiovascularDisease: hasCardiovascularDisease ?? this.hasCardiovascularDisease,
      hasNeuropathy: hasNeuropathy ?? this.hasNeuropathy,
      hasRetinopathy: hasRetinopathy ?? this.hasRetinopathy,
      hasGastroparesis: hasGastroparesis ?? this.hasGastroparesis,
      hasHypoglycemiaUnawareness: hasHypoglycemiaUnawareness ?? this.hasHypoglycemiaUnawareness,
      otherConditions: otherConditions ?? this.otherConditions,
      smokingStatus: smokingStatus ?? this.smokingStatus,
      smokingYears: smokingYears ?? this.smokingYears,
      alcoholFrequency: alcoholFrequency ?? this.alcoholFrequency,
      alcoholDrinksPerWeek: alcoholDrinksPerWeek ?? this.alcoholDrinksPerWeek,
      stressLevel: stressLevel ?? this.stressLevel,
      typicalSleepHours: typicalSleepHours ?? this.typicalSleepHours,
      sleepQuality: sleepQuality ?? this.sleepQuality,
      isPregnant: isPregnant ?? this.isPregnant,
      isBreastfeeding: isBreastfeeding ?? this.isBreastfeeding,
      expectedDueDate: expectedDueDate ?? this.expectedDueDate,
      preferredUnits: preferredUnits ?? this.preferredUnits,
      glucoseUnit: glucoseUnit ?? this.glucoseUnit,
      timezone: timezone ?? this.timezone,
      languageCode: languageCode ?? this.languageCode,
      enableGlucoseAlerts: enableGlucoseAlerts ?? this.enableGlucoseAlerts,
      enableMealReminders: enableMealReminders ?? this.enableMealReminders,
      enableActivityReminders: enableActivityReminders ?? this.enableActivityReminders,
      enableMedicationReminders: enableMedicationReminders ?? this.enableMedicationReminders,
      shareDataForResearch: shareDataForResearch ?? this.shareDataForResearch,
      shareAnonymizedData: shareAnonymizedData ?? this.shareAnonymizedData,
    );
  }

  @override
  List<Object?> get props => [
        appExperience,
        conditionId,
        diagnosisDate,
        heightCm,
        currentWeightKg,
        targetWeightKg,
        bmi,
        waistCircumferenceCm,
        bodyFatPercentage,
        hba1cTarget,
        lastHba1c,
        lastHba1cDate,
        targetGlucoseFasting,
        targetGlucosePostprandial,
        treatmentTypes,
        insulinRegimen,
        usesCgm,
        cgmDevice,
        activityLevel,
        dailyStepsGoal,
        weeklyExerciseGoalMinutes,
        preferredActivityTypeIds,
        dietaryPattern,
        dailyCarbTargetGrams,
        dailyCalorieTarget,
        dailyProteinTargetGrams,
        dailyFatTargetGrams,
        mealsPerDay,
        snacksPerDay,
        foodAllergies,
        foodIntolerances,
        foodsToAvoid,
        culturalCuisines,
        dietaryRestrictions,
        hasHypertension,
        hypertensionMedication,
        hasKidneyDisease,
        kidneyDiseaseStage,
        egfrValue,
        hasCardiovascularDisease,
        hasNeuropathy,
        hasRetinopathy,
        hasGastroparesis,
        hasHypoglycemiaUnawareness,
        otherConditions,
        smokingStatus,
        smokingYears,
        alcoholFrequency,
        alcoholDrinksPerWeek,
        stressLevel,
        typicalSleepHours,
        sleepQuality,
        isPregnant,
        isBreastfeeding,
        expectedDueDate,
        preferredUnits,
        glucoseUnit,
        timezone,
        languageCode,
        enableGlucoseAlerts,
        enableMealReminders,
        enableActivityReminders,
        enableMedicationReminders,
        shareDataForResearch,
        shareAnonymizedData,
      ];

}
