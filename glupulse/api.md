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


/health/medication
insert
{
    "display_name": "Novolog (Rapid Acting)",
    "medication_type": "INSULIN", //Constraint = ['INSULIN', 'BIGUANIDE', 'GLP', 'SGLT2', 'DPP4', 'OTC', 'SUPPLEMENT', 'OTHER_RX']
    "default_dose_unit": "units"
}

/*
INSULIN	    = All types of insulin (rapid, long-acting)	Core diabetes management.
BIGUANIDE   = Metformin.	Core oral diabetes drug.
GLP         = GLP-1 Agonists (e.g., Ozempic).	Diabetes and weight management.
SGLT2       = SGLT-2 Inhibitors (e.g., Jardiance).	Diabetes and cardio-renal protection.
DPP4        = DPP-4 Inhibitors (e.g., Januvia).	Oral diabetes drug.
OTC         = Over-The-Counter (e.g., Ibuprofen, Tylenol).	Critical for tracking illness effects on glucose and  Without prescription
SUPPLEMENT  = Vitamins, minerals, herbs.	For tracking overall nutritional intake.
OTHER_RX    = Other Prescribed Medication (non-diabetes).	General prescriptions General prescriptions (e.g., blood pressure, thyroid).
*/

get
[
    {
        "medication_id": 4,
        "user_id": "fd3ca976-b1f1-4981-952b-361073d8d831",
        "display_name": "Metformin",
        "medication_type": "BIGUANIDE",
        "default_dose_unit": "mg",
        "is_active": true,
        "created_at": "2025-11-25T10:52:48.252211+07:00",
        "updated_at": "2025-11-25T10:54:32.104342+07:00"
    },
    {
        "medication_id": 3,
        "user_id": "fd3ca976-b1f1-4981-952b-361073d8d831",
        "display_name": "Novolog (Rapid Acting)",
        "medication_type": "INSULIN",
        "default_dose_unit": "units",
        "is_active": true,
        "created_at": "2025-11-25T10:52:48.252211+07:00",
        "updated_at": "2025-11-25T10:52:48.252211+07:00"
    },
    {
        "medication_id": 5,
        "user_id": "fd3ca976-b1f1-4981-952b-361073d8d831",
        "display_name": "Novolog (Rapid Acting)",
        "medication_type": "INSULIN",
        "default_dose_unit": "units",
        "is_active": true,
        "created_at": "2025-11-25T10:52:48.252211+07:00",
        "updated_at": "2025-11-25T10:52:48.252211+07:00"
    }
]

update
/health/medication/4
delete
/health/medication/5

/health/medication/log
insert
{
    "medication_id": 3, 
    "medication_name": "Novolog Pen (Fast Acting)",
    "timestamp": "2025-11-24T12:45:00+07:00",
    "dose_amount": 8.5,
    "reason": "meal_bolus", //Constraint = ['meal_bolus', 'basal', 'correction', 'medication_schedule']
    "is_pump_delivery": false, //Only for Insulin medication type
    "delivery_duration_minutes": 0, //Only if is_pump_delivery = true
    "notes": "Taken for lunch carbs."
}

get
[
    {
        "medicationlog_id": "9c6a5e9a-a2df-40ec-9a6e-5c678560ebb4",
        "user_id": "fd3ca976-b1f1-4981-952b-361073d8d831",
        "medication_id": 3,
        "medication_name": "Novolog (Rapid Acting)",
        "timestamp": "2025-11-24T12:45:00+07:00",
        "dose_amount": 8.5,
        "reason": "meal_bolus",
        "is_pump_delivery": false,
        "delivery_duration_minutes": 0,
        "notes": "Taken for lunch carbs.",
        "created_at": "2025-11-25T14:03:40.02529+07:00",
        "updated_at": "2025-11-25T14:03:40.02529+07:00"
    }
]

update
/health/medication/log/9c6a5e9a-a2df-40ec-9a6e-5c678560ebb4

/health/medication/log/9c6a5e9a-a2df-40ec-9a6e-5c678560ebb4


/foods

get aja
[
    {
        "food_id": "cce04c78-054e-47c3-a5ed-0509cfc7779d",
        "seller_id": "8760aa72-c990-4008-a81b-ec139aed224e",
        "food_name": "Classic Grilled Chicken Salad",
        "description": "Tender grilled chicken breast served over fresh mixed greens, cherry tomatoes, and cucumbers. Comes with a light lemon vinaigrette.",
        "price": 75000,
        "currency": "IDR",
        "photo_url": "https://placehold.co/600x400/556B2F/FFFFFF?text=Grilled+Chicken+Salad",
        "thumbnail_url": "https://placehold.co/200x200/556B2F/FFFFFF?text=Salad",
        "is_available": true,
        "stock_count": 50,
        "tags": [
            "healthy",
            "low-carb",
            "high-protein",
            "gluten-free"
        ],
        "created_at": "2025-11-17T16:15:00.798699+07:00",
        "updated_at": "2025-11-17T16:15:00.798699+07:00",
        "serving_size": null,
        "serving_size_grams": null,
        "quantity": null,
        "calories": null,
        "carbs_grams": null,
        "fiber_grams": null,
        "protein_grams": null,
        "fat_grams": null,
        "sugar_grams": null,
        "sodium_mg": null,
        "glycemic_index": null,
        "glycemic_load": null,
        "food_category": null
    },
    {
        "food_id": "2e766c3b-e374-4ab2-8b2a-ac1a3738c27b",
        "seller_id": "8760aa72-c990-4008-a81b-ec139aed224e",
        "food_name": "Fresh Squeezed Orange Juice",
        "description": "250ml of 100% pure, fresh squeezed orange juice. No added sugar.",
        "price": 30000,
        "currency": "IDR",
        "photo_url": "https://placehold.co/600x400/FFA500/FFFFFF?text=Orange+Juice",
        "thumbnail_url": "https://placehold.co/200x200/FFA500/FFFFFF?text=Juice",
        "is_available": true,
        "stock_count": 100,
        "tags": [
            "drink",
            "fresh",
            "no-sugar-added",
            "vegan"
        ],
        "created_at": "2025-11-17T16:15:00.798699+07:00",
        "updated_at": "2025-11-17T16:15:00.798699+07:00",
        "serving_size": null,
        "serving_size_grams": null,
        "quantity": null,
        "calories": null,
        "carbs_grams": null,
        "fiber_grams": null,
        "protein_grams": null,
        "fat_grams": null,
        "sugar_grams": null,
        "sodium_mg": null,
        "glycemic_index": null,
        "glycemic_load": null,
        "food_category": null
    },
    {
        "food_id": "362f0eaa-4321-4d1e-8c22-00b6c3c3ef6e",
        "seller_id": "8760aa72-c990-4008-a81b-ec139aed224e",
        "food_name": "Hearty Lentil Soup",
        "description": "A warm and comforting classic lentil soup with carrots, celery, and onions.",
        "price": 45000,
        "currency": "IDR",
        "photo_url": "https://placehold.co/600x400/8B4513/FFFFFF?text=Lentil+Soup",
        "thumbnail_url": "https://placehold.co/200x200/8B4513/FFFFFF?text=Soup",
        "is_available": true,
        "stock_count": 30,
        "tags": [
            "healthy",
            "vegan",
            "high-fiber",
            "soup"
        ],
        "created_at": "2025-11-17T16:15:00.798699+07:00",
        "updated_at": "2025-11-17T16:15:00.798699+07:00",
        "serving_size": null,
        "serving_size_grams": null,
        "quantity": null,
        "calories": null,
        "carbs_grams": null,
        "fiber_grams": null,
        "protein_grams": null,
        "fat_grams": null,
        "sugar_grams": null,
        "sodium_mg": null,
        "glycemic_index": null,
        "glycemic_load": null,
        "food_category": null
    },
    {
        "food_id": "f617bd1e-1986-4463-807f-aaea3eef3ad3",
        "seller_id": "8760aa72-c990-4008-a81b-ec139aed224e",
        "food_name": "Quinoa & Avocado Power Bowl",
        "description": "A hearty bowl of red quinoa, sliced avocado, black beans, corn, and a cilantro-lime dressing.",
        "price": 68000,
        "currency": "IDR",
        "photo_url": "https://placehold.co/600x400/8A9A5B/FFFFFF?text=Quinoa+Bowl",
        "thumbnail_url": "https://placehold.co/200x200/8A9A5B/FFFFFF?text=Bowl",
        "is_available": true,
        "stock_count": 40,
        "tags": [
            "healthy",
            "vegan",
            "high-fiber",
            "gluten-free"
        ],
        "created_at": "2025-11-17T16:15:00.798699+07:00",
        "updated_at": "2025-11-17T16:15:00.798699+07:00",
        "serving_size": null,
        "serving_size_grams": null,
        "quantity": null,
        "calories": null,
        "carbs_grams": null,
        "fiber_grams": null,
        "protein_grams": null,
        "fat_grams": null,
        "sugar_grams": null,
        "sodium_mg": null,
        "glycemic_index": null,
        "glycemic_load": null,
        "food_category": null
    },
    {
        "food_id": "c99f7a66-46d0-4b8c-8b72-5ccc31bf1890",
        "seller_id": "8760aa72-c990-4008-a81b-ec139aed224e",
        "food_name": "Steamed Salmon with Brown Rice",
        "description": "Flaky steamed salmon fillet served with a side of wholesome brown rice and steamed broccoli.",
        "price": 110000,
        "currency": "IDR",
        "photo_url": "https://placehold.co/600x400/FA8072/FFFFFF?text=Steamed+Salmon",
        "thumbnail_url": "https://placehold.co/200x200/FA8072/FFFFFF?text=Salmon",
        "is_available": true,
        "stock_count": 25,
        "tags": [
            "healthy",
            "high-protein",
            "omega-3"
        ],
        "created_at": "2025-11-17T16:15:00.798699+07:00",
        "updated_at": "2025-11-17T16:15:00.798699+07:00",
        "serving_size": null,
        "serving_size_grams": null,
        "quantity": null,
        "calories": null,
        "carbs_grams": null,
        "fiber_grams": null,
        "protein_grams": null,
        "fat_grams": null,
        "sugar_grams": null,
        "sodium_mg": null,
        "glycemic_index": null,
        "glycemic_load": null,
        "food_category": null
    }
]



/checkout
post
{
    "address_id": "edfd21bd-2c3c-43b7-82f0-add81f8641f6",
    "payment_method": "Mastercard"
}

/orders/track
Get
[
    {
        "order_id": "ea5fc55c-d834-4c49-b97e-712086e8cab5",
        "store_name": "Kwetiau Apeng",
        "store_phone": "081231916455",
        "seller_lat": -7.27,
        "seller_long": 112.73,
        "total_price": 150000,
        "status": "Pending Payment",
        "payment_status": "unpaid",
        "delivery_address": {
            "user_id": "fd3ca976-b1f1-4981-952b-361073d8d831",
            "is_active": true,
            "address_id": "b3e2c522-776c-465a-9b76-aeaaf95344bd",
            "created_at": "2025-11-15T21:24:01.158607+07:00",
            "is_default": false,
            "updated_at": "2025-11-20T21:46:08.124144+07:00",
            "address_city": "Jakarta",
            "address_label": "Apart",
            "address_line1": "123 Main Street",
            "address_line2": "Block 1 No 1",
            "delivery_notes": "Call upon arrival",
            "recipient_name": "Marvel Stefano",
            "recipient_phone": "081234567890",
            "address_district": "Kelapa Gading",
            "address_latitude": -6.106908626211207,
            "address_province": "DKI Jakarta",
            "address_longitude": 106.74657744414517,
            "address_postalcode": "12345"
        },
        "created_at": "2025-12-18T20:27:47.689488+07:00",
        "items": [
            {
                "food_name": "anejo cheese",
                "quantity": 1,
                "price": 150000
            }
        ]
    }
]



/orders/history?limit=10&offset=0
Get
[
    {
        "order_id": "ea5fc55c-d834-4c49-b97e-712086e8cab5",
        "store_name": "Kwetiau Apeng",
        "store_slug": "kwetiau-apeng-ybdj",
        "store_logo": "",
        "total_price": 150000,
        "status": "completed",
        "payment_status": "unpaid",
        "created_at": "2025-12-18T20:27:47.689488+07:00",
        "items": [
            {
                "food_name": "anejo cheese",
                "quantity": 1,
                "price": 150000
            }
        ]
    }
]

/seller/profile
{
    "seller_id": "71c8d315-bf7d-4806-a31e-e02bfb74a271",
    "user_id": "d4d549e7-a63a-4e5d-b0b2-3bf593173f36",
    "created_at": "2025-12-14T10:13:06.720238+07:00",
    "updated_at": "2025-12-14T10:13:06.720238+07:00",
    "store_name": "Kwetiau Apeng",
    "store_description": "Kwetiau Apeng Surabaya",
    "store_phone_number": "081231916455",
    "is_open": false,
    "business_hours": "eyJmcmlkYXkiOiB7Im9wZW4iOiAiMDk6MDAiLCAiY2xvc2UiOiAiMjE6MDAiLCAiY2xvc2VkIjogZmFsc2V9LCAibW9uZGF5IjogeyJvcGVuIjogIjA5OjMwIiwgImNsb3NlIjogIjIxOjAwIiwgImNsb3NlZCI6IGZhbHNlfSwgInN1bmRheSI6IHsib3BlbiI6ICIwOTozMCIsICJjbG9zZSI6ICIyMTozMCIsICJjbG9zZWQiOiBmYWxzZX0sICJ0dWVzZGF5IjogeyJvcGVuIjogIjA5OjAwIiwgImNsb3NlIjogIjIxOjAwIiwgImNsb3NlZCI6IGZhbHNlfSwgInNhdHVyZGF5IjogeyJvcGVuIjogIjA5OjAwIiwgImNsb3NlIjogIjIxOjAwIiwgImNsb3NlZCI6IHRydWV9LCAidGh1cnNkYXkiOiB7Im9wZW4iOiAiMDk6MDAiLCAiY2xvc2UiOiAiMjE6MDAiLCAiY2xvc2VkIjogZmFsc2V9LCAid2VkbmVzZGF5IjogeyJvcGVuIjogIjA5OjAwIiwgImNsb3NlIjogIjIxOjAwIiwgImNsb3NlZCI6IGZhbHNlfX0=",
    "verification_status": "pending",
    "logo_url": null,
    "banner_url": null,
    "address_line1": "Jl. Kedung Doro No.267",
    "address_line2": "Kwetiau Apeng",
    "district": "Wonorejo",
    "city": "Surabaya",
    "province": "East Java",
    "postal_code": "60261",
    "latitude": -7.27,
    "longitude": 112.73,
    "gmaps_link": null,
    "store_slug": "kwetiau-apeng-ybdj",
    "store_email": "marvelstefano@gmail.com",
    "website_url": null,
    "social_media_links": null,
    "is_active": true,
    "cuisine_type": [
        "Indonesian",
        "Chinese Food",
        "Masakan jawa"
    ],
    "price_range": 2,
    "rejection_reason": null,
    "verified_at": null,
    "average_rating": 0,
    "review_count": 0
}



/food/categories
[
    {
        "category_id": 31,
        "category_code": "AFRICAN",
        "display_name": "African",
        "description": null
    },
    {
        "category_id": 16,
        "category_code": "BEVERAGE_ALCOHOL",
        "display_name": "Alcohol",
        "description": null
    },
    {
        "category_id": 26,
        "category_code": "WESTERN_AMERICAN",
        "display_name": "American",
        "description": null
    },
    {
        "category_id": 21,
        "category_code": "ASIAN_GENERIC",
        "display_name": "Asian (General)",
        "description": null
    },
    {
        "category_id": 14,
        "category_code": "BEVERAGE_COFFEE_TEA",
        "display_name": "Coffee & Tea",
        "description": null
    },
    {
        "category_id": 10,
        "category_code": "DAIRY_ALT",
        "display_name": "Dairy Alternatives",
        "description": null
    },
    {
        "category_id": 9,
        "category_code": "DAIRY",
        "display_name": "Dairy & Cheese",
        "description": null
    },
    {
        "category_id": 23,
        "category_code": "ASIAN_EAST",
        "display_name": "East Asian (Chinese, Japanese, Korean)",
        "description": null
    },
    {
        "category_id": 27,
        "category_code": "WESTERN_EUROPEAN",
        "display_name": "European",
        "description": null
    },
    {
        "category_id": 11,
        "category_code": "FATS_OILS",
        "display_name": "Fats & Oils",
        "description": null
    },
    {
        "category_id": 3,
        "category_code": "FRUIT",
        "display_name": "Fruits",
        "description": null
    },
    {
        "category_id": 32,
        "category_code": "FUSION",
        "display_name": "Fusion / Modern",
        "description": null
    },
    {
        "category_id": 30,
        "category_code": "LATIN_AMERICAN",
        "display_name": "Latin American / Mexican",
        "description": null
    },
    {
        "category_id": 6,
        "category_code": "PROTEIN_MEAT",
        "display_name": "Meat & Poultry",
        "description": null
    },
    {
        "category_id": 28,
        "category_code": "MEDITERRANEAN",
        "display_name": "Mediterranean",
        "description": null
    },
    {
        "category_id": 29,
        "category_code": "MIDDLE_EASTERN",
        "display_name": "Middle Eastern",
        "description": null
    },
    {
        "category_id": 1,
        "category_code": "VEG_NON_STARCHY",
        "display_name": "Non-Starchy Vegetables",
        "description": null
    },
    {
        "category_id": 12,
        "category_code": "NUTS_SEEDS",
        "display_name": "Nuts & Seeds",
        "description": null
    },
    {
        "category_id": 8,
        "category_code": "PROTEIN_PLANT",
        "display_name": "Plant-Based Protein",
        "description": null
    },
    {
        "category_id": 20,
        "category_code": "PREPARED_MEAL",
        "display_name": "Prepared/Mixed Meals",
        "description": null
    },
    {
        "category_id": 5,
        "category_code": "GRAIN_REFINED",
        "display_name": "Refined Grains",
        "description": null
    },
    {
        "category_id": 19,
        "category_code": "CONDIMENTS",
        "display_name": "Sauces & Condiments",
        "description": null
    },
    {
        "category_id": 18,
        "category_code": "SNACKS",
        "display_name": "Savory Snacks",
        "description": null
    },
    {
        "category_id": 7,
        "category_code": "PROTEIN_SEAFOOD",
        "display_name": "Seafood",
        "description": null
    },
    {
        "category_id": 24,
        "category_code": "ASIAN_SOUTH",
        "display_name": "South Asian (Indian, Pakistani)",
        "description": null
    },
    {
        "category_id": 22,
        "category_code": "ASIAN_SE",
        "display_name": "Southeast Asian (Indonesian, Thai, Viet)",
        "description": null
    },
    {
        "category_id": 2,
        "category_code": "VEG_STARCHY",
        "display_name": "Starchy Vegetables",
        "description": null
    },
    {
        "category_id": 15,
        "category_code": "BEVERAGE_SUGARY",
        "display_name": "Sugary Drinks",
        "description": null
    },
    {
        "category_id": 17,
        "category_code": "SWEETS",
        "display_name": "Sweets & Desserts",
        "description": null
    },
    {
        "category_id": 13,
        "category_code": "BEVERAGE_WATER",
        "display_name": "Water",
        "description": null
    },
    {
        "category_id": 25,
        "category_code": "WESTERN_GENERIC",
        "display_name": "Western (General)",
        "description": null
    },
    {
        "category_id": 4,
        "category_code": "GRAIN_WHOLE",
        "display_name": "Whole Grains",
        "description": null
    }
]


/profile/update-email

{
    "new_email": "marvelstefano001300@gmail.com",
    "password": "P@ssw0rd"
}