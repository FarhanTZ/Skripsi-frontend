Field Name	Simple	Advance	Condition Type (If Mandatory)
Core Identity & Biometrics			
app_experience	YES	YES	All
condition_id	YES	YES	All
diagnosis_date	YES	YES	Type 2 Diabetes, Prediabetes
years_with_condition	YES	YES	Type 2 Diabetes, Prediabetes
height_cm	YES	YES	All (for BMI)
current_weight_kg	YES	YES	All (for BMI)
target_weight_kg	YES	YES	All
bmi (Generated)			All
waist_circumference_cm		YES	Obesity
body_fat_percentage		YES	Obesity
Metabolic Targets			
hba1c_target	YES	YES	Type 2 Diabetes, Prediabetes
last_hba1c	YES	YES	Type 2 Diabetes, Prediabetes
last_hba1c_date	YES	YES	Type 2 Diabetes, Prediabetes
target_glucose_fasting	YES	YES	Type 2 Diabetes, Prediabetes
target_glucose_postprandial	YES	YES	Type 2 Diabetes, Prediabetes
Medication & CGM			
treatment_types	YES	YES	Type 2 Diabetes, Prediabetes
insulin_regimen		YES	Type 2 Diabetes & Insulin Treatment only
uses_cgm		YES	Type 2 Diabetes
cgm_device		YES	Type 2 Diabetes
cgm_api_connected			Flag for system
Activity & Lifestyle			
activity_level	YES	YES	All
daily_steps_goal	YES	YES	All
weekly_exercise_goal_minutes	YES	YES	All
preferred_activity_type_ids	YES	YES	All
Dietary Targets			
dietary_pattern	YES	YES	All
daily_carb_target_grams		YES	All
daily_calorie_target		YES	All
daily_protein_target_grams		YES	All
daily_fat_target_grams		YES	All
meals_per_day		YES	All
snacks_per_day		YES	All
Preferences & Restrictions			
food_allergies	YES	YES	All
food_intolerances	YES	YES	All
foods_to_avoid	YES	YES	All
cultural_cuisines	YES	YES	All
dietary_restrictions	YES	YES	All
Comorbidities (Critical Safety)			
has_hypertension	YES	YES	All
hypertension_medication		YES	All
has_kidney_disease	YES	YES	All
kidney_disease_stage		YES	All (If has_kidney_desease=TRUE)
egfr_value		YES	All (If has_kidney_desease=TRUE)
has_cardiovascular_disease		YES	All
has_neuropathy		YES	All
has_retinopathy		YES	All
has_gastroparesis		YES	All
has_hypoglycemia_unawareness		YES	All
other_conditions		YES	All
Lifestyle & Environmental			
smoking_status		YES	All
smoking_years		YES	All
alcohol_frequency		YES	All
alcohol_drinks_per_week		YES	All
stress_level		YES	All
typical_sleep_hours		YES	All
sleep_quality		YES	All
Pregnancy			
is_pregnant	YES	YES	All (CRITICAL SAFETY)
is_breastfeeding		YES	If Pregnant=TRUE
expected_due_date		YES	If Pregnant=TRUE
App Settings (Non-Health)			
preferred_units	YES	YES	all
glucose_unit	YES	YES	all
timezone	YES	YES	all
language_code	YES	YES	all
enable_glucose_alerts	YES	YES	all
enable_meal_reminders	YES	YES	all
enable_activity_reminders	YES	YES	all
enable_medication_reminders	YES	YES	all
share_data_for_research	YES	YES	all
share_anonymized_data	YES	YES	all



I/flutter (24605): DEBUG: First Food Item JSON: {food_id: 779f936b-1491-43d0-bbbb-057462b66022, seller_id: 71c8d315-bf7d-4806-a31e-e02bfb74a271, food_name: american cheese spread, description: Nikmati kelezatan klasik "American Cheese Spread" tanpa khawatir! Dengan Indeks Glikemik (IG) hanya 27 dan Beban Glikemik (GL) yang sangat rendah (0,378), keju olesan ini adalah pilihan cerdas untuk menjaga kadar gula darah Anda tetap stabil. Kaya akan protein (2,6 gram) dan rendah gula (hanya 1,2 gram), cocok sebagai tambahan lezat pada menu sehat harian Anda. Ideal untuk penderita diabetes!, price: 15900.0, currency: IDR, photo_url: null, thumbnail_url: null, is_available: true, stock_count: 23, tags: [Cheese, Spread, American, Low Glycemic Index, Low Glycemic Load, Diabetic Friendly, High Protein, Low Sugar, Dairy], created_at: 2025-12-04T10:16:28.135036+07:00, updated_at: 2025-12-17T22:25:29.034833+07:00, serving_size: 1/2 oz, serving_size_grams: 14.0, quantity: 1.0, calories: 46, carbs_grams: 1.4, fiber_grams: 0, protein_grams: 2.6,
