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

  @override
  List<Object?> get props => [
        appExperience,
        conditionId,
        diagnosisDate,
        heightCm,
        currentWeightKg,
        targetWeightKg,
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
