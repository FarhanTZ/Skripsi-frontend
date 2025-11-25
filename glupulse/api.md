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


/health/glucose

ini buat insert
{
    "glucose_value": 250, //Constraint >= 20 and <= 600
    "reading_type": "post_meal_2h", //Constraint = ['fasting', 'pre_meal', 'post_meal_1h', 'post_meal_2h', 'bedtime', 'overnight', 'random', 'exercise', 'sick_day']
    "reading_timestamp": "2025-11-24T03:50:00Z",
    "source": "glucose_meter", //Constraint = ['manual', 'cgm', 'glucose_meter', 'lab_test']
    "device_name": "Accu-Chek Guide",
    "device_id": "Test123",
    "notes": "Ate a large lunch. Will take a short walk.",
    "symptoms": ["fatigue"]
}

ini get datanya
[
    {
        "reading_id": "55737996-f2b4-4478-ad1d-5eb5f7d6f22c",
        "user_id": "fd3ca976-b1f1-4981-952b-361073d8d831",
        "glucose_value": 250,
        "reading_timestamp": "2025-11-24T10:50:00+07:00",
        "reading_type": "post_meal_2h",
        "trend_arrow": "rising_rapidly",
        "rate_of_change": 2,
        "source": "glucose_meter",
        "device_id": "Test123",
        "device_name": "Accu-Chek Guide",
        "is_flagged": false,
        "flag_reason": null,
        "is_outlier": false,
        "notes": "Ate a large lunch. Will take a short walk.",
        "symptoms": [
            "fatigue"
        ],
        "created_at": "2025-11-24T11:57:54.481787+07:00",
        "updated_at": "2025-11-24T11:57:54.481787+07:00"
    },
    {
        "reading_id": "57e00e48-b934-45af-8153-c608ee4dc416",
        "user_id": "fd3ca976-b1f1-4981-952b-361073d8d831",
        "glucose_value": 180,
        "reading_timestamp": "2025-11-24T10:20:00+07:00",
        "reading_type": "random",
        "trend_arrow": "falling_rapidly",
        "rate_of_change": -2,
        "source": "manual",
        "device_id": null,
        "device_name": null,
        "is_flagged": false,
        "flag_reason": null,
        "is_outlier": false,
        "notes": "Test for falling trend.",
        "symptoms": [],
        "created_at": "2025-11-24T11:50:51.372439+07:00",
        "updated_at": "2025-11-24T11:50:51.372439+07:00"
    },
    {
        "reading_id": "a472a083-6aee-4246-a75a-8ea4cd3ed849",
        "user_id": "fd3ca976-b1f1-4981-952b-361073d8d831",
        "glucose_value": 200,
        "reading_timestamp": "2025-11-24T10:10:00+07:00",
        "reading_type": "post_meal_1h",
        "trend_arrow": "rising_rapidly",
        "rate_of_change": 5,
        "source": "manual",
        "device_id": null,
        "device_name": null,
        "is_flagged": false,
        "flag_reason": null,
        "is_outlier": false,
        "notes": "Test for rising rapidly trend.",
        "symptoms": [],
        "created_at": "2025-11-24T11:48:08.338863+07:00",
        "updated_at": "2025-11-24T11:48:08.338863+07:00"
    },
    {
        "reading_id": "6a3179c6-c80c-4200-983c-aa1324e92b87",
        "user_id": "fd3ca976-b1f1-4981-952b-361073d8d831",
        "glucose_value": 150,
        "reading_timestamp": "2025-11-24T10:00:00+07:00",
        "reading_type": "random",
        "trend_arrow": "unknown",
        "rate_of_change": 0,
        "source": "manual",
        "device_id": null,
        "device_name": null,
        "is_flagged": false,
        "flag_reason": null,
        "is_outlier": false,
        "notes": "Baseline reading before tests.",
        "symptoms": [],
        "created_at": "2025-11-24T11:47:59.496942+07:00",
        "updated_at": "2025-11-24T11:47:59.496942+07:00"
    }
]

ini update
/health/glucose/55737996-f2b4-4478-ad1d-5eb5f7d6f22c

ini delete
/health/glucose/55737996-f2b4-4478-ad1d-5eb5f7d6f22c



/health/log/sleep
insert
{
    "sleep_date": "2025-11-24",
    "bed_time": "2025-11-24T23:00:00+07:00",
    "wake_time": "2025-11-25T06:45:00+07:00",
    
    "quality_rating": 4, //Constraint > 1 & < 5
    "tracker_score": 0, //Constraint > 0 & < 100, for integration with smartwatch

    "deep_sleep_minutes": 90,
    "rem_sleep_minutes": 20, //Penjelasan cari di google panjang soale
    "light_sleep_minutes": 240,
    "awake_minutes": 15,
    "average_hrv": 50,//Penjelasan cari di google panjang soale
    "resting_heart_rate": 70,
    "tags": [""],
    "source": "manual", //Constraint = ['manual', 'wearable_sync']
    "notes": "Felt rested, but woke up once at 3 AM."
}

get
[
    {
        "sleep_id": "bc6e1d27-e3b8-4c58-9685-a62716a3be31",
        "user_id": "fd3ca976-b1f1-4981-952b-361073d8d831",
        "sleep_date": "2025-11-24",
        "bed_time": "2025-11-24T23:00:00+07:00",
        "wake_time": "2025-11-25T06:45:00+07:00",
        "quality_rating": 4,
        "tracker_score": 0,
        "deep_sleep_minutes": 90,
        "rem_sleep_minutes": 20,
        "light_sleep_minutes": 240,
        "awake_minutes": 15,
        "average_hrv": 50,
        "resting_heart_rate": 70,
        "tags": [
            ""
        ],
        "source": "manual",
        "notes": "Felt rested, but woke up once at 3 AM.",
        "created_at": "2025-11-24T23:35:50.983415+07:00",
        "updated_at": "2025-11-24T23:35:50.983415+07:00"
    }
]

update
/health/log/sleep/bc6e1d27-e3b8-4c58-9685-a62716a3be31
delete
/health/log/sleep/bc6e1d27-e3b8-4c58-9685-a62716a3be31



get aktivity
/health/activity_type
[
    {
        "activity_type_id": 12,
        "activity_code": "CALISTHENICS",
        "display_name": "Calisthenics (Pushups/Situps)",
        "intensity_level": "MODERATE"
    },
    {
        "activity_type_id": 8,
        "activity_code": "CYCLING_LIGHT",
        "display_name": "Cycling (Leisure)",
        "intensity_level": "MODERATE"
    },
    {
        "activity_type_id": 9,
        "activity_code": "CYCLING_INTENSE",
        "display_name": "Cycling (Vigorous)",
        "intensity_level": "HIGH"
    },
    {
        "activity_type_id": 3,
        "activity_code": "DANCE",
        "display_name": "Dancing (Zumba, Ballroom, etc.)",
        "intensity_level": "MODERATE"
    },
    {
        "activity_type_id": 1,
        "activity_code": "HIIT",
        "display_name": "High Intensity Interval Training",
        "intensity_level": "HIGH"
    },
    {
        "activity_type_id": 6,
        "activity_code": "HIKING",
        "display_name": "Hiking",
        "intensity_level": "MODERATE"
    },
    {
        "activity_type_id": 16,
        "activity_code": "HOUSEWORK",
        "display_name": "Household Chores",
        "intensity_level": "LOW"
    },
    {
        "activity_type_id": 2,
        "activity_code": "MARTIAL_ARTS",
        "display_name": "Martial Arts & Boxing",
        "intensity_level": "HIGH"
    },
    {
        "activity_type_id": 4,
        "activity_code": "OCCUPATIONAL",
        "display_name": "Occupational Labor",
        "intensity_level": "MODERATE"
    },
    {
        "activity_type_id": 15,
        "activity_code": "RACKET_SPORTS",
        "display_name": "Racket Sports (Badminton, Tennis)",
        "intensity_level": "MODERATE"
    },
    {
        "activity_type_id": 7,
        "activity_code": "RUNNING",
        "display_name": "Running / Jogging",
        "intensity_level": "HIGH"
    },
    {
        "activity_type_id": 10,
        "activity_code": "SWIMMING",
        "display_name": "Swimming",
        "intensity_level": "HIGH"
    },
    {
        "activity_type_id": 14,
        "activity_code": "TEAM_SPORTS",
        "display_name": "Team Sports (Soccer, Basketball)",
        "intensity_level": "HIGH"
    },
    {
        "activity_type_id": 5,
        "activity_code": "WALKING",
        "display_name": "Walking (Casual)",
        "intensity_level": "LOW"
    },
    {
        "activity_type_id": 11,
        "activity_code": "WEIGHT_LIFTING",
        "display_name": "Weight Lifting",
        "intensity_level": "MODERATE"
    },
    {
        "activity_type_id": 13,
        "activity_code": "YOGA_PILATES",
        "display_name": "Yoga & Pilates",
        "intensity_level": "LOW"
    }
]


/health/log/activity
insert
{
    "activity_timestamp": "2025-11-24T14:30:00+07:00",
    "activity_code": "SWIMMING", //Constraint = 1-16
    "intensity": "moderate", //Constraint = ['low', 'moderate', 'high']
    "duration_minutes": 45, //Constraint > 0
    
    "perceived_exertion": 5, //Constraint 1 - 10, penjelasan e panjang cari di google / gpt
    "steps_count": 5500, 
    "pre_activity_carbs": 15,
    "water_intake_ml": 500,
    "issue_description": "None",
    "sync_id": "", //Biarin kosong user gk perlu isi. Dipake buat integrasi ke smartwatch
    "source": "fitness_tracker", //Constraint ['manual', 'fitness_tracker', 'cgm_integrated']
    "notes": "Walked through the park before afternoon meeting."
}

get log aktivity
[
    {
        "activity_id": "63134815-df63-4589-951f-952ead5112b6",
        "user_id": "fd3ca976-b1f1-4981-952b-361073d8d831",
        "activity_timestamp": "2025-11-24T14:30:00+07:00",
        "activity_code": "SWIMMING",
        "intensity": "moderate",
        "perceived_exertion": 5,
        "duration_minutes": 45,
        "steps_count": 5500,
        "pre_activity_carbs": 15,
        "water_intake_ml": 500,
        "issue_description": "None",
        "source": "fitness_tracker",
        "sync_id": "",
        "notes": "Walked through the park before afternoon meeting.",
        "created_at": "2025-11-24T22:35:11.099285+07:00",
        "updated_at": "2025-11-24T22:35:11.099285+07:00"
    },
    {
        "activity_id": "dd7068a6-c4ef-4aa3-b08d-2406701300a3",
        "user_id": "fd3ca976-b1f1-4981-952b-361073d8d831",
        "activity_timestamp": "2025-11-24T14:30:00+07:00",
        "activity_code": "SWIMMING",
        "intensity": "moderate",
        "perceived_exertion": 5,
        "duration_minutes": 45,
        "steps_count": 5500,
        "pre_activity_carbs": 15,
        "water_intake_ml": 500,
        "issue_description": "None",
        "source": "fitness_tracker",
        "sync_id": "",
        "notes": "Walked through the park before afternoon meeting.",
        "created_at": "2025-11-24T22:41:29.313099+07:00",
        "updated_at": "2025-11-24T22:41:29.313099+07:00"
    }
]

update
/health/log/activity/63134815-df63-4589-951f-952ead5112b6

delete
/health/log/activity/63134815-df63-4589-951f-952ead5112b6