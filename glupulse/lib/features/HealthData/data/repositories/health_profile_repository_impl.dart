import 'package:dartz/dartz.dart';
import 'package:glupulse/core/error/exceptions.dart';
import 'package:glupulse/core/error/failures.dart';
import 'package:glupulse/features/HealthData/data/datasources/health_profile_remote_data_source.dart';
import 'package:glupulse/features/HealthData/data/models/health_profile_model.dart';
import 'package:glupulse/features/HealthData/domain/entities/health_profile.dart';
import 'package:glupulse/features/HealthData/domain/repositories/health_profile_repository.dart';
import 'package:glupulse/features/auth/data/datasources/auth_local_data_source.dart';

class HealthProfileRepositoryImpl implements HealthProfileRepository {
  final HealthProfileRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  HealthProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, HealthProfile>> getHealthProfile() async {
    try {
      final token = await localDataSource.getLastToken();
      final remoteProfile = await remoteDataSource.getHealthProfile(token);
      return Right(remoteProfile);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, HealthProfile>> updateHealthProfile(
      HealthProfile healthProfile) async {
    try {
      final token = await localDataSource.getLastToken();
      final healthProfileModel = HealthProfileModel(
        appExperience: healthProfile.appExperience,
        conditionId: healthProfile.conditionId,
        diagnosisDate: healthProfile.diagnosisDate,
        heightCm: healthProfile.heightCm,
        currentWeightKg: healthProfile.currentWeightKg,
        targetWeightKg: healthProfile.targetWeightKg,
        waistCircumferenceCm: healthProfile.waistCircumferenceCm,
        bodyFatPercentage: healthProfile.bodyFatPercentage,
        hba1cTarget: healthProfile.hba1cTarget,
        lastHba1c: healthProfile.lastHba1c,
        lastHba1cDate: healthProfile.lastHba1cDate,
        targetGlucoseFasting: healthProfile.targetGlucoseFasting,
        targetGlucosePostprandial: healthProfile.targetGlucosePostprandial,
        treatmentTypes: healthProfile.treatmentTypes,
        insulinRegimen: healthProfile.insulinRegimen,
        usesCgm: healthProfile.usesCgm,
        cgmDevice: healthProfile.cgmDevice,
        activityLevel: healthProfile.activityLevel,
        dailyStepsGoal: healthProfile.dailyStepsGoal,
        weeklyExerciseGoalMinutes: healthProfile.weeklyExerciseGoalMinutes,
        preferredActivityTypeIds: healthProfile.preferredActivityTypeIds,
        dietaryPattern: healthProfile.dietaryPattern,
        dailyCarbTargetGrams: healthProfile.dailyCarbTargetGrams,
        dailyCalorieTarget: healthProfile.dailyCalorieTarget,
        dailyProteinTargetGrams: healthProfile.dailyProteinTargetGrams,
        dailyFatTargetGrams: healthProfile.dailyFatTargetGrams,
        mealsPerDay: healthProfile.mealsPerDay,
        snacksPerDay: healthProfile.snacksPerDay,
        foodAllergies: healthProfile.foodAllergies,
        foodIntolerances: healthProfile.foodIntolerances,
        foodsToAvoid: healthProfile.foodsToAvoid,
        culturalCuisines: healthProfile.culturalCuisines,
        dietaryRestrictions: healthProfile.dietaryRestrictions,
        hasHypertension: healthProfile.hasHypertension,
        hypertensionMedication: healthProfile.hypertensionMedication,
        hasKidneyDisease: healthProfile.hasKidneyDisease,
        kidneyDiseaseStage: healthProfile.kidneyDiseaseStage,
        egfrValue: healthProfile.egfrValue,
        hasCardiovascularDisease: healthProfile.hasCardiovascularDisease,
        hasNeuropathy: healthProfile.hasNeuropathy,
        hasRetinopathy: healthProfile.hasRetinopathy,
        hasGastroparesis: healthProfile.hasGastroparesis,
        hasHypoglycemiaUnawareness: healthProfile.hasHypoglycemiaUnawareness,
        otherConditions: healthProfile.otherConditions,
        smokingStatus: healthProfile.smokingStatus,
        smokingYears: healthProfile.smokingYears,
        alcoholFrequency: healthProfile.alcoholFrequency,
        alcoholDrinksPerWeek: healthProfile.alcoholDrinksPerWeek,
        stressLevel: healthProfile.stressLevel,
        typicalSleepHours: healthProfile.typicalSleepHours,
        sleepQuality: healthProfile.sleepQuality,
        isPregnant: healthProfile.isPregnant,
        isBreastfeeding: healthProfile.isBreastfeeding,
        expectedDueDate: healthProfile.expectedDueDate,
        preferredUnits: healthProfile.preferredUnits,
        glucoseUnit: healthProfile.glucoseUnit,
        timezone: healthProfile.timezone,
        languageCode: healthProfile.languageCode,
        enableGlucoseAlerts: healthProfile.enableGlucoseAlerts,
        enableMealReminders: healthProfile.enableMealReminders,
        enableActivityReminders: healthProfile.enableActivityReminders,
        enableMedicationReminders: healthProfile.enableMedicationReminders,
        shareDataForResearch: healthProfile.shareDataForResearch,
        shareAnonymizedData: healthProfile.shareAnonymizedData,
      );
      final remoteProfile =
          await remoteDataSource.updateHealthProfile(healthProfileModel, token);
      return Right(remoteProfile);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }
}
