/health/profile

/put
/get


{
/* ========================================================
   CORE IDENTITY & SETUP (MANDATORY for App Functionality)
   ======================================================== */
  "app_experience": "advanced",                 // [Constraint: 'simple' or 'advanced']. Sets the app's UI complexity level.
  "condition_id": 1, // [Mandatory FK]. References the 'health_condition_types' table (1 = Type 2 Diabetes, 2 = prediabetes, 3 = obesity, 4 = general_wellness).
  "diagnosis_date": "2023-01-15", // [Format: YYYY-MM-DD]. Date of diagnosis.
  //"years_with_condition": 1.86, [Go Calculated]. Contextual field, calculated by the Go backend (not manually sent).

/* ========================================================
   BIOMETRICS & TARGETS (Required for BMI & Goal Setting)
   ======================================================== */

  "height_cm": 175.50,                         // [Mandatory, Constraint: >= 100, <= 250]. Used for BMI calculation.
  "current_weight_kg": 92.00,                  // [Mandatory, Constraint: >= 20, <= 300]. Used for BMI calculation.
  "target_weight_kg": 75.00,                   // Optional: User's goal weight.
  "waist_circumference_cm": 105.50,            // Optional: Key risk factor for metabolic syndrome.
  "body_fat_percentage": 28.50,                // Optional.

  "hba1c_target": 7.00,                        // [Constraint: 4.0 - 10.0]. Doctor-set HbA1c goal.
  "last_hba1c": 8.30,                          // [Constraint: 4.0 - 20.0]. Latest lab result.
  "last_hba1c_date": "2025-10-01",             // Date of last lab.
  "target_glucose_fasting": 100,               // Target glucose level (mg/dL) before meals.
  "target_glucose_postprandial": 140,          // Target glucose level (mg/dL) 2 hours after meals.

  /* ========================================================
     MEDICATION & CGM USAGE
     ======================================================== */

  "treatment_types": ["metformin", "diet_only"], // [Array of VARCHAR]. Medications/treatments used.
  "insulin_regimen": "none",                     // Type of regimen ('basal_bolus', 'pump', 'none').
  "uses_cgm": true,                              // Boolean: Does the user track with a Continuous Glucose Monitor?
  "cgm_device": "dexcom_g6",                     // Device model.
  //"cgm_api_connected": true, Boolean: Is the device currently linked to the app?

  /* ========================================================
     ACTIVITY & LIFESTYLE GOALS
     ======================================================== */

  "activity_level": "lightly_active",          // [Constraint: sedentary, lightly_active, moderately_active, very_active, extremely_active]. User's general activity level.
  "daily_steps_goal": 8500,
  "weekly_exercise_goal_minutes": 150,         // ADA-recommended goal (150 mins/week).
  "preferred_activity_type_ids": [1, 3],       // Array of IDs referencing the 'activity_types' lookup table.

  /* === DIETARY TARGETS === */
  "dietary_pattern": "low_carb",               // E.g., 'low_carb', 'keto', 'standard'.
  "daily_carb_target_grams": 150,
  "daily_calorie_target": 1800,
  "daily_protein_target_grams": 90,
  "daily_fat_target_grams": 60,
  "meals_per_day": 3,
  "snacks_per_day": 2,

  /* ========================================================
     PREFERENCES & RESTRICTIONS
     ======================================================== */

  "food_allergies": ["shellfish"],                  // Array: Safety warning for AI.
  "food_intolerances": ["lactose"],                 // Array: For filtering/UX.
  "foods_to_avoid": ["rice_noodles", "sugar_soda"], // Array: User-defined food dislikes.
  "cultural_cuisines": ["asian", "mediterranean"],  // Array: Helps tailor recipe/restaurant suggestions.
  "dietary_restrictions": ["halal"],                // Array: 'halal', 'kosher', 'vegetarian', etc.

  /* ========================================================
     COMORBIDITIES (AI Safety Red Flags)
     ======================================================== */

  "has_hypertension": true,                    // Boolean: High Blood Pressure (AI must reduce sodium).
  "hypertension_medication": "Lisinopril",     // Contextual data.
  "has_kidney_disease": false,                 // Boolean: Kidney issues (AI must limit K/P if true).
  "kidney_disease_stage": 1,                   // [Constraint: 1-5]. Stage of kidney disease (if true).
  "egfr_value": 90.00,                         // Estimated Glomerular Filtration Rate (Kidney function).
  "has_cardiovascular_disease": false,
  "has_neuropathy": false,                     // Affects safety of high-impact activity.
  "has_retinopathy": false,                    // Affects safety of heavy lifting.
  "has_gastroparesis": false,                  // Affects meal timing/frequency.
  "has_hypoglycemia_unawareness": false,       // CRITICAL: Affects glucose alert thresholds.
  "other_conditions": ["thyroid_issues"],      // Array of text conditions.

  /* ========================================================
     LIFESTYLE FACTORS & APP SETTINGS
     ======================================================== */

  "smoking_status": "former",                  // [Constraint: 'never', 'former', 'current'].
  "smoking_years": 5,
  "alcohol_frequency": "rarely",               // [Constraint: 'never', 'rarely', 'weekly', 'daily'].
  "alcohol_drinks_per_week": 1,
  "stress_level": "moderate",                  // [Constraint: 'low', 'moderate', 'high', 'very_high'].
  "typical_sleep_hours": 7.5,
  "sleep_quality": "good",                     // [Constraint: 'poor', 'fair', 'good', 'excellent'].

  /* === PREGNANCY === */
  "is_pregnant": false,
  "is_breastfeeding": false,
  "expected_due_date": null,                   // YYYY-MM-DD (if is_pregnant is true)

  /* === APP SETTINGS === */
  "preferred_units": "metric",                 // [Constraint:'metric', 'imperial']
  "glucose_unit": "mg_dl",                     // [Constraint:'mg_dl', 'mmol_l']
  "timezone": "Asia/Jakarta",
  "language_code": "id",
  "enable_glucose_alerts": true,
  "enable_meal_reminders": true,
  "enable_activity_reminders": true,
  "enable_medication_reminders": true,
  "share_data_for_research": false,
  "share_anonymized_data": true                // Boolean
}




Hba1c

/health/hba1c

insert
get
Update
/health/hba1c/39f01827-597a-4e91-bda2-80c0f6d73483
delete
/health/hba1c/39f01827-597a-4e91-bda2-80c0f6d73483
{
    "test_date": "2025-12-01", //Mandatory
    "hba1c_percentage": 7.5, //Mandatory
    "estimated_avg_glucose": 162,
    "treatment_changed": false,
    "medication_changes": "None since last test.",
    "diet_changes": "None",
    "activity_changes": "None",
    "notes": "Test done after illness, may be slightly elevated.",
    "document_url": "https://s3.aws.com/user_documents/hba1c_nov_25.pdf"
}


Health Event
/health/events
insert
get
update
/health/events/354af170-8ff2-4336-9046-d5ebcdb690cd
delete
/health/events/354af170-8ff2-4336-9046-d5ebcdb690cd
{
    "event_date": "2025-11-18", //Mandatory
    "event_type": "illness",    //Constraint: ['hypoglycemia', 'hyperglycemia', 'illness', 'other']
    "severity": "moderate",     //Constraint: ['mild', 'moderate', 'severe', 'critical']
    "glucose_value": 310,       //Mandatory For ['Hypoglicemia', 'Hyperglycemia']
    "ketone_value_mmol": 1.5,   //Mandatory For ['Hyperglycemia']
    "symptoms": ["fever", "nausea"], //Mandatory
    "treatments": ["ibuprofen", "fluids"], //Mandatory
    "required_medical_attention": false,
    "notes": "Severe flu led to persistent hyperglycemia."
}