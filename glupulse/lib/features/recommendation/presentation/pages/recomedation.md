1️⃣ Header – Status Kesehatan Singkat (Ringkas & Menenangkan)

📌 Tampilkan:

Judul: Health Insight Mingguan

Tanggal berlaku:
Berlaku sampai 8 Des 2025

Indicator warna (opsional):

🔴 HbA1c perlu perhatian

🟡 Waspada

🟢 Terkontrol

📄 Ambil dari:

analysis_summary

expires_at

✅ Kenapa penting?
User langsung paham kondisi dia saat ini, tanpa baca teks panjang.

2️⃣ Ringkasan Utama (Insight Card – Highlight)

📌 UI bentuk Card

🎯 Fokus Utama Minggu Ini
HbA1c: 7.5% → Target < 7.0%
Prioritas: Kontrol gula setelah makan & aktivitas rutin


📄 Ambil dari:

analysis_summary

✅ Kenapa?
User jarang mau baca paragraf panjang. Card ini jadi ringkasan eksekutif.

3️⃣ Insight Detail (Expandable Section / Accordion)

📌 Judul: Insight & Rencana Perbaikan
📌 Isi ringkas (dipecah jadi bullet):

🍽️ Karbohidrat ≤ 150g/hari

🥗 Prioritaskan GL < 10

🚶 Jalan kaki 20–30 menit setelah makan besar

🍗 Protein target 90g/hari

🔥 Kalori harian 1800 kcal

📄 Ambil dari:

insights_response (di-parse & diringkas di frontend)

✅ UX tips:

Default: collapsed

Ada tombol “Baca Detail”

4️⃣ Activity Recommendation (Section Paling Penting)

📌 Judul: Aktivitas yang Disarankan
📌 List Card (urut berdasarkan rank)

🔹 Card Activity Contoh:

Casual Stroll

🕒 30 menit

⚡ Intensitas: Ringan

🕓 Waktu terbaik: Malam

✅ Manfaat: Turunkan gula setelah makan

⚠️ Catatan: Minum sebelum mulai

🎯 Action Button:

Mulai Aktivitas

Tambahkan ke Jadwal

📄 Ambil dari:

activity_recommendations[]

✅ Kenapa ini penting?
Ini bagian actionable, bukan cuma bacaan.

5️⃣ Empty State – Food Recommendation

Karena:

"food_recommendations": []


📌 Tampilkan:

🍽️ Rekomendasi Makanan
Belum tersedia untuk sesi ini.
Silakan input log makan terbaru agar rekomendasi lebih akurat.


✅ Kenapa?

Jangan kosong polos → bikin user bingung

Dorong user isi data lagi

6️⃣ Footer – Informasi Session (Opsional)

📌 Tampilkan kecil saja:

Sesi dibuat: 1 Des 2025

Session ID (hidden / developer mode)

📄 Ambil dari:

created_at

session_id


/recommendations
{
    "type": ["food", "activity", "insights"],
    "meal_type": "dinner",
    "food_category_code": ["MEDITERRANEAN", "VEGETABLES"],
    "food_preferences": "vegetarian, high fiber",
    "activity_type_code": ["YOGA", "WALKING"],
    "activity_preferences": "low-impact evening exercise",
    "insights": "How can I lower my HbA1c from 7.5% to 6.5% in 3 months?"
  }

  responya
  { "session_id": "02590eec-66bc-47bc-bf78-558cdf046d6c", "analysis_summary": "Your recent HbA1c of 7.5% indicates the need for stricter glucose control, aiming toward your target of 7.0% and below. Given your current management plan for Type 2 Diabetes and hypertension, nutritional consistency and regular post-meal movement are crucial focus areas.", "insights_response": "Lowering your HbA1c from 7.5% to 6.5% in three months requires stringent focus on reducing postprandial glucose spikes. This can be achieved by prioritizing meals with a Glycemic Load (GL) consistently under 10, emphasizing high-fiber non-starchy vegetables (like those found in Mediterranean cuisine), and strictly controlling carbohydrate intake below your 150g target, focusing on whole, unprocessed sources. Strategically incorporating physical activity, specifically a 20-30 minute brisk walk 60-90 minutes after your largest meals, is crucial as it significantly enhances insulin sensitivity and directly lowers peak glucose levels. Given your current weight goal, maintaining your 1800 calorie target while ensuring adequate protein intake (90g) will support weight loss, which is one of the most effective ways to improve HbA1c.", "food_recommendations": [], "activity_recommendations": [ { "activity_id": 1, "activity_code": "WALKING", "activity_name": "Casual Stroll", "description": "Slow walking on a level surface, perfect for recovery or beginners.", "image_url": "https://s3.example.com/act/walk_slow.jpg", "met_value": 2, "measurement_unit": "TIME", "recommended_min_value": 30, "reason": "A light, low-impact stroll after dinner is highly effective for reducing the postprandial glucose spike safely, fitting your preference for evening exercise.", "recommended_duration_minutes": 30, "recommended_intensity": "light", "safety_note": "A light post-meal walk is safe; ensure hydration before starting.", "best_time": "evening", "rank": 1 }, { "activity_id": 2, "activity_code": "WALKING", "activity_name": "Brisk Walking", "description": "Walking at a pace where you breathe heavier but can still talk.", "image_url": "https://s3.example.com/act/walk_brisk.jpg", "met_value": 4.3, "measurement_unit": "STEPS", "recommended_min_value": 5000, "reason": "Incorporating brisk walking into your routine will help improve overall cardiovascular health and enhance insulin sensitivity over time.", "recommended_duration_minutes": 40, "recommended_intensity": "moderate", "safety_note": "Monitor your glucose after 20 minutes to observe its effect, especially if you haven't eaten recently.", "best_time": "morning", "rank": 2 } ], "created_at": "2025-12-01T17:14:01.177279+07:00", "expires_at": "2025-12-08T17:14:01.17728+07:00" }




  {
    "session_id": "4005d9bd-6269-42f7-933f-62c396ff0f7e",
    "analysis_summary": "Your recent HbA1c is 7.5%, indicating suboptimal glucose control but an improvement from previous readings, moving closer to your 7.0% target. Focus must remain on strict low-carb adherence and increasing consistent physical activity to achieve your ambitious 6.5% goal.",
    "insights_response": "To reduce your HbA1c from 7.5% to 6.5% within 3 months, you must focus on four areas: strict carbohydrate control, consistent activity, portion management for weight loss, and medication adherence. Strict adherence to your low-carb diet (under 150g/day) prioritizing fiber-rich, low-GI vegetables and lean protein is critical to minimizing glucose spikes. Increase your daily activity consistency by ensuring you take a 15-20 minute walk immediately after your largest meal to improve postprandial glucose handling. Given your current weight (BMI 30.04), achieving a 5-8kg weight loss over the next three months will significantly improve insulin sensitivity, which is crucial for reaching the 6.5% target. Finally, work closely with your physician to ensure your Novolog insulin dosing is optimized for your meals and activity levels.",
    "food_recommendations": [
        {
            "food_id": "d41dc48e-02be-45e9-b386-81b8cb72643b",
            "seller_id": "8760aa72-c990-4008-a81b-ec139aed224e",
            "food_name": "parmesan cheese",
            "description": "Keju Parmesan: Rendah Karbo, Tinggi Protein, Pilihan Cerdas untuk Gula Darah!\n\nNikmati cita rasa keju Parmesan yang kaya dan gurih tanpa khawatir! Dengan Indeks Glikemik yang sangat rendah (hanya 15) dan Beban Glikemik yang dapat diabaikan (0.09), keju ini adalah tambahan yang fantastis untuk diet diabetes Anda.\n\nSangat rendah karbohidrat (hanya 0.6 gram) dan gula (0.046 gram), Keju Parmesan kami kaya akan protein (6.4 gram) dan lemak sehat (4.5 gram) yang membantu menjaga rasa kenyang dan menstabilkan kadar gula darah Anda.\n\nCocok untuk camilan sehat, taburan pasta rendah karbo, atau sebagai penambah rasa dalam masakan Anda. Jaga kesehatan, tetap nikmat!",
            "price": 15000,
            "currency": "IDR",
            "is_available": true,
            "stock_count": 24,
            "tags": [
                "Cheese",
                "Dairy",
                "Low Carb",
                "High Protein",
                "Low Glycemic Index",
                "Keto Friendly",
                "Healthy Fats",
                "Diabetes Diet"
            ],
            "serving_size": "1 tbsp",
            "serving_size_grams": 5,
            "quantity": 1,
            "calories": 71,
            "carbs_grams": 0.6,
            "protein_grams": 6.4,
            "fat_grams": 4.5,
            "sugar_grams": 0.05,
            "sodium_mg": 0.2,
            "glycemic_index": 15,
            "glycemic_load": 0.09,
            "food_category": [
                "Dairy & Cheese",
                "European"
            ],
            "saturated_fat_grams": 2.7,
            "monounsaturated_fat_grams": 1.4,
            "polyunsaturated_fat_grams": 0.1,
            "cholesterol_mg": 12.2,
            "reason": "This hard cheese is naturally very low in lactose and zero-carb, aligning perfectly with your low-carb, Type 2 Diabetes dietary plan.",
            "nutrition_highlight": "Zero Carbs, High Protein, European",
            "suggested_meal_type": "dinner",
            "portion_suggestion": "30g shaved",
            "rank": 1
        },
        {
            "food_id": "e94bb8cd-6255-42cd-b4d0-91b0ed9acc0e",
            "seller_id": "8760aa72-c990-4008-a81b-ec139aed224e",
            "food_name": "provolone cheese reduced fat",
            "description": "Keju Provolone Rendah Lemak: Pilihan Lezat dan Sehat!\n\nNikmati kelezatan keju provolone dengan rasa yang kaya, kini dengan kandungan lemak yang lebih rendah! Ideal untuk Anda yang menjalani pola makan sehat, terutama penderita diabetes.\n\nSetiap porsi mengandung nutrisi istimewa:  * Karbohidrat dan Gula Sangat Rendah: Hanya 4g karbohidrat dan 0.6g gula, membantu menjaga kadar gula darah stabil.\n  * Protein Tinggi: Dengan 27.9g protein, membantu Anda kenyang lebih lama dan mendukung kesehatan otot.\n  * Sodium Rendah: Hanya 1mg sodium per porsi.\n  * Bebas Indeks Glikemik (GI = 0, GL = 0): Pilihan aman tanpa perlu khawatir lonjakan gula darah.Cocok untuk camilan sehat, tambahan sandwich, atau bahan masakan favorit Anda. Jadikan Keju Provolone Rendah Lemak ini bagian dari diet harian Anda!",
            "price": 80000,
            "currency": "IDR",
            "is_available": true,
            "stock_count": 23,
            "tags": [
                "Provolone Cheese",
                "Reduced Fat",
                "Low Carb",
                "Low Sugar",
                "High Protein",
                "Low Sodium",
                "Diabetes Friendly",
                "Zero GI",
                "Zero GL"
            ],
            "serving_size": "1 slice",
            "serving_size_grams": 20,
            "quantity": 1,
            "calories": 310,
            "carbs_grams": 4,
            "protein_grams": 27.9,
            "fat_grams": 19.9,
            "sugar_grams": 0.6,
            "sodium_mg": 1,
            "food_category": [
                "Dairy & Cheese",
                "European"
            ],
            "saturated_fat_grams": 12.8,
            "monounsaturated_fat_grams": 5.5,
            "polyunsaturated_fat_grams": 0.6,
            "cholesterol_mg": 62.2,
            "reason": "Choosing a reduced-fat variety supports your weight loss goal while providing protein and fitting the European cuisine theme.",
            "nutrition_highlight": "Zero Carbs, Reduced Fat",
            "suggested_meal_type": "dinner",
            "portion_suggestion": "2 slices (approx 40g)",
            "rank": 2
        },
        {
            "food_id": "400e40a2-80cf-431f-afc9-f24845e6249b",
            "seller_id": "8760aa72-c990-4008-a81b-ec139aed224e",
            "food_name": "spinach souffle",
            "description": "Souffle Bayam Sehat (Rendah GI)\n\nNikmati kelezatan klasik Eropa dengan Souffle Bayam! Dibuat dengan bayam segar, hidangan ini kaya akan protein (10,7g) untuk membantu Anda kenyang lebih lama. Dengan Indeks Glikemik (GI) sangat rendah yaitu 35 dan Beban Glikemik (GL) hanya 2,45, Souffle Bayam adalah pilihan cerdas untuk menjaga kadar gula darah tetap stabil. Rendah karbohidrat (8g) dan mengandung serat (1g). Cocok sebagai hidangan utama sehat Anda.",
            "price": 69000,
            "currency": "IDR",
            "is_available": true,
            "stock_count": 5,
            "tags": [
                "spinach souffle",
                "souffle",
                "French",
                "European",
                "high protein",
                "low GI",
                "low glycemic index",
                "low carb",
                "healthy main dish",
                "bayam"
            ],
            "serving_size": "1/2 cup",
            "serving_size_grams": 68,
            "quantity": 1,
            "calories": 230,
            "carbs_grams": 8,
            "fiber_grams": 1,
            "protein_grams": 10.7,
            "fat_grams": 17.6,
            "sugar_grams": 2.5,
            "sodium_mg": 0.8,
            "glycemic_index": 35,
            "glycemic_load": 2.45,
            "food_category": [
                "Prepared/Mixed Meals",
                "European"
            ],
            "saturated_fat_grams": 10.1,
            "monounsaturated_fat_grams": 5,
            "polyunsaturated_fat_grams": 1,
            "cholesterol_mg": 160.5,
            "reason": "This classic European dish fits the requested zero-carb and low-GL profile provided in the database, making it a safe dinner component.",
            "nutrition_highlight": "Zero Carbs, Low GL 0.0",
            "suggested_meal_type": "dinner",
            "portion_suggestion": "1 small serving",
            "rank": 3
        }
    ],
    "activity_recommendations": [
        {
            "activity_id": 1,
            "activity_code": "WALKING",
            "activity_name": "Casual Stroll",
            "description": "Slow walking on a level surface, perfect for recovery or beginners.",
            "image_url": "https://s3.example.com/act/walk_slow.jpg",
            "met_value": 2,
            "measurement_unit": "TIME",
            "recommended_min_value": 30,
            "reason": "A low-impact walk is highly effective for safely utilizing glucose, especially after dinner, supporting better overnight blood sugar control.",
            "recommended_duration_minutes": 45,
            "recommended_intensity": "light",
            "safety_note": "This activity is low-impact and safe for evening, but ensure you carry water.",
            "best_time": "evening",
            "rank": 1
        }
    ],
    "created_at": "2025-12-04T12:45:14.869746+07:00",
    "expires_at": "2025-12-11T12:45:14.869746+07:00"
}



{
    "type": ["food", "activity", "insights"],
    "meal_type": "dinner",
    "food_category": ["European"],
    "food_preferences": "",
    "activity_type_code": ["YOGA", "WALKING"],
    "activity_preferences": "low-impact evening exercise",
    "insights": "How can I lower my HbA1c from 7.5% to 6.5% in 3 months?"
  }



  /foods
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


recomendatio by id ini untuk ambil 1 recomednation terbarunya
/recommendation/dd81dec6-0030-46ff-aa62-96451815b3e1
{
    "sessions": [
        {
            "session_id": "dd81dec6-0030-46ff-aa62-96451815b3e1",
            "created_at": "2025-12-04T13:50:03.576988+07:00",
            "expires_at": "2025-12-11T13:50:03.576988+07:00",
            "is_expired": false,
            "requested_types": [
                "food",
                "activity",
                "insights"
            ],
            "meal_type": "dinner",
            "food_category_codes": [
                "European"
            ],
            "activity_type_codes": [
                "YOGA",
                "WALKING"
            ],
            "activity_preferences": "low-impact evening exercise",
            "insights_question": "How can I lower my HbA1c from 7.5% to 6.5% in 3 months?",
            "analysis_summary": "Your recent HbA1c of 7.5% shows improvement but remains above your target, indicating a continued need for strict glucose control and consistent adherence to your low-carb plan. Focusing on low glycemic load foods and structured activity will be key to achieving your 6.5% goal and managing co-occurring hypertension.",
            "insights_response": "Lowering your HbA1c from 7.5% to 6.5% in three months requires stricter consistency across diet, physical activity, and medication adherence. Focus intensely on keeping carbohydrate intake consistently below your 150g target, prioritizing whole, low-GI foods, and carefully monitoring portion sizes, especially as you also manage hypertension. Incorporate at least 30 minutes of moderate activity, such as brisk walking, daily, ideally 30-60 minutes after your largest meal, as this greatly improves postprandial glucose control. Since your BMI is 30, achieving your target weight loss will be the most potent way to improve insulin sensitivity; aim for a sustainable calorie deficit (targeting your 1800 kcal limit) while ensuring adequate protein intake (90g) to maintain satiety and muscle mass. Finally, ensure timely administration of your Metformin and Novolog doses as prescribed.",
            "latest_glucose_value": 180,
            "latest_hba1c": 7.5,
            "user_condition_id": 1,
            "was_viewed": false,
            "viewed_at": "0001-01-01T00:00:00Z",
            "foods_count": 3,
            "activities_count": 2,
            "foods_purchased": 0,
            "activities_completed": 0
        },
        {
            "session_id": "4005d9bd-6269-42f7-933f-62c396ff0f7e",
            "created_at": "2025-12-04T12:45:14.824078+07:00",
            "expires_at": "2025-12-11T12:45:14.824078+07:00",
            "is_expired": false,
            "requested_types": [
                "food",
                "activity",
                "insights"
            ],
            "meal_type": "dinner",
            "food_category_codes": [
                "European"
            ],
            "activity_type_codes": [
                "YOGA",
                "WALKING"
            ],
            "activity_preferences": "low-impact evening exercise",
            "insights_question": "How can I lower my HbA1c from 7.5% to 6.5% in 3 months?",
            "analysis_summary": "Your recent HbA1c is 7.5%, indicating suboptimal glucose control but an improvement from previous readings, moving closer to your 7.0% target. Focus must remain on strict low-carb adherence and increasing consistent physical activity to achieve your ambitious 6.5% goal.",
            "insights_response": "To reduce your HbA1c from 7.5% to 6.5% within 3 months, you must focus on four areas: strict carbohydrate control, consistent activity, portion management for weight loss, and medication adherence. Strict adherence to your low-carb diet (under 150g/day) prioritizing fiber-rich, low-GI vegetables and lean protein is critical to minimizing glucose spikes. Increase your daily activity consistency by ensuring you take a 15-20 minute walk immediately after your largest meal to improve postprandial glucose handling. Given your current weight (BMI 30.04), achieving a 5-8kg weight loss over the next three months will significantly improve insulin sensitivity, which is crucial for reaching the 6.5% target. Finally, work closely with your physician to ensure your Novolog insulin dosing is optimized for your meals and activity levels.",
            "latest_glucose_value": 180,
            "latest_hba1c": 7.5,
            "user_condition_id": 1,
            "was_viewed": false,
            "viewed_at": "0001-01-01T00:00:00Z",
            "foods_count": 3,
            "activities_count": 1,
            "foods_purchased": 0,
            "activities_completed": 0
        },
        {
            "session_id": "94b42cfa-7f33-40d3-a40b-7141ae74c8c5",
            "created_at": "2025-12-04T12:44:49.255413+07:00",
            "expires_at": "2025-12-11T12:44:49.255413+07:00",
            "is_expired": false,
            "requested_types": [
                "food",
                "activity",
                "insights"
            ],
            "meal_type": "dinner",
            "food_category_codes": [
                "European"
            ],
            "food_preferences": "high fiber",
            "activity_type_codes": [
                "YOGA",
                "WALKING"
            ],
            "activity_preferences": "low-impact evening exercise",
            "insights_question": "How can I lower my HbA1c from 7.5% to 6.5% in 3 months?",
            "analysis_summary": "Your recent HbA1c of 7.5% is above target, indicating a need for stricter glucose management to avoid long-term complications. Achieving your aggressive goal of 6.5% in 3 months requires maximum adherence to your low-carb plan and consistent post-meal activity.",
            "insights_response": "Lowering your HbA1c from 7.5% to 6.5% in three months is an aggressive but achievable goal requiring a focused, three-pillar strategy:\n\n1. Strict Nutritional Control: Adhere strictly to your low-carb target (around 150g/day, focusing on fiber-rich non-starchy vegetables and lean protein). Eliminate all sugar and highly processed carbohydrates. Prioritize foods with a Glycemic Index (GI) below 55 to prevent sharp glucose spikes.\n\n2. Consistent Activity: Aim for at least 150 minutes of moderate-intensity cardio (like Brisk Walking) per week, plus two days of resistance training. Crucially, implement a 15-30 minute walk after every main meal to maximize postprandial glucose reduction, as this is one of the most effective non-pharmacological methods to lower blood sugar.\n\n3. Medication and Monitoring Optimization: Work closely with your endocrinologist to ensure your Metformin and insulin doses are optimized for your current activity and diet, especially if you see consistent high readings (above 180 mg/dL). Use your CGM data daily to identify and correct patterns of high glucose, adjusting basal/bolus timing as needed.",
            "latest_glucose_value": 180,
            "latest_hba1c": 7.5,
            "user_condition_id": 1,
            "was_viewed": false,
            "viewed_at": "0001-01-01T00:00:00Z",
            "foods_count": 0,
            "activities_count": 1,
            "foods_purchased": 0,
            "activities_completed": 0
        },
        {
            "session_id": "d5f8079b-9471-4c23-a191-8c98e30060db",
            "created_at": "2025-12-04T12:44:25.678673+07:00",
            "expires_at": "2025-12-11T12:44:25.678673+07:00",
            "is_expired": false,
            "requested_types": [
                "food",
                "activity",
                "insights"
            ],
            "meal_type": "dinner",
            "food_category_codes": [
                "EEuropean"
            ],
            "food_preferences": "high fiber",
            "activity_type_codes": [
                "YOGA",
                "WALKING"
            ],
            "activity_preferences": "low-impact evening exercise",
            "insights_question": "How can I lower my HbA1c from 7.5% to 6.5% in 3 months?",
            "analysis_summary": "Your recent HbA1c of 7.5% shows improvement but remains significantly above your personalized target, requiring tighter glucose control. Since you have Type 2 Diabetes and hypertension, focus must be on high-fiber, low-carb options and consistent cardiovascular activity.",
            "insights_response": "Targeting a 1% reduction in HbA1c (from 7.5% to 6.5%) within three months requires significant and consistent adherence to your low-carb diet and activity goals. To achieve this, maintain strict adherence to your 150g daily carb limit, prioritizing non-starchy vegetables and whole proteins to keep meal Glycemic Load (GL) below 5. Crucially, integrate a 10-15 minute post-meal walk after every large meal to improve immediate insulin sensitivity. Finally, increase your moderate-intensity exercise, aiming for at least 225 minutes per week to boost metabolic control and support your weight loss goal.",
            "latest_glucose_value": 180,
            "latest_hba1c": 7.5,
            "user_condition_id": 1,
            "was_viewed": false,
            "viewed_at": "0001-01-01T00:00:00Z",
            "foods_count": 0,
            "activities_count": 2,
            "foods_purchased": 0,
            "activities_completed": 0
        },
        {
            "session_id": "e46241d6-fd2b-49cc-bafc-86dbdf4eb39f",
            "created_at": "2025-12-04T11:13:10.592313+07:00",
            "expires_at": "2025-12-11T11:13:10.592313+07:00",
            "is_expired": false,
            "requested_types": [
                "food"
            ],
            "meal_type": "snack",
            "food_category_codes": [
                "European"
            ],
            "analysis_summary": "Your HbA1c has recently stabilized around 7.5%, showing good progress from your previous levels, but remains above your 7.0% target and requires continued strict glucose control. Focusing on low-carb, high-protein snacks is essential, especially given your Type 2 Diabetes, obesity, and hypertension management goals.",
            "latest_glucose_value": 180,
            "latest_hba1c": 7.5,
            "user_condition_id": 1,
            "was_viewed": false,
            "viewed_at": "0001-01-01T00:00:00Z",
            "foods_count": 3,
            "activities_count": 0,
            "foods_purchased": 0,
            "activities_completed": 0
        },
        {
            "session_id": "afce5bda-301e-4360-a5e2-d87282a98373",
            "created_at": "2025-12-04T10:48:41.62132+07:00",
            "expires_at": "2025-12-11T10:48:41.62132+07:00",
            "is_expired": false,
            "requested_types": [
                "food"
            ],
            "meal_type": "snack",
            "food_category_codes": [
                "European"
            ],
            "analysis_summary": "Your last recorded HbA1c was 7.5%, which is above the target of 7.0%, indicating a need for stricter glucose management and low-carb adherence. Since you are managing Type 2 Diabetes and aiming for weight loss, prioritizing low glycemic index and low-carb snacks is crucial.",
            "latest_glucose_value": 180,
            "latest_hba1c": 7.5,
            "user_condition_id": 1,
            "was_viewed": false,
            "viewed_at": "0001-01-01T00:00:00Z",
            "foods_count": 3,
            "activities_count": 0,
            "foods_purchased": 0,
            "activities_completed": 0
        },
        {
            "session_id": "c244933b-31a8-443e-9051-b76337452ee6",
            "created_at": "2025-12-04T10:24:36.199225+07:00",
            "expires_at": "2025-12-11T10:24:36.199225+07:00",
            "is_expired": false,
            "requested_types": [
                "food"
            ],
            "meal_type": "snack",
            "food_category_codes": [
                "European"
            ],
            "analysis_summary": "Your current HbA1c of 7.5% indicates that stricter glucose management is necessary to meet your target, reinforcing the need for low GI and low-carb food choices. You are managing Type 2 Diabetes and maintaining a low-carb diet, which is an excellent foundation for improving your control. ",
            "latest_glucose_value": 180,
            "latest_hba1c": 7.5,
            "user_condition_id": 1,
            "was_viewed": false,
            "viewed_at": "0001-01-01T00:00:00Z",
            "foods_count": 3,
            "activities_count": 0,
            "foods_purchased": 0,
            "activities_completed": 0
        },
        {
            "session_id": "2a037948-0827-46ac-bc09-1ed996d1f42f",
            "created_at": "2025-12-03T23:08:29.322282+07:00",
            "expires_at": "2025-12-10T23:08:29.322282+07:00",
            "is_expired": false,
            "requested_types": [
                "food"
            ],
            "meal_type": "snack",
            "food_category_codes": [
                "Dairy & Cheese"
            ],
            "analysis_summary": "Your recent HbA1c remains elevated at 7.5%, indicating a need for stricter glucose management and adherence to your low-carb plan. Focusing on low-glycemic, high-protein snacks will support your weight loss and blood sugar targets.",
            "latest_glucose_value": 180,
            "latest_hba1c": 7.5,
            "user_condition_id": 1,
            "was_viewed": false,
            "viewed_at": "0001-01-01T00:00:00Z",
            "foods_count": 0,
            "activities_count": 0,
            "foods_purchased": 0,
            "activities_completed": 0
        },
        {
            "session_id": "78a1b5a8-7a94-4d47-9fa5-648486c3e5bb",
            "created_at": "2025-12-03T23:05:52.109583+07:00",
            "expires_at": "2025-12-10T23:05:52.109583+07:00",
            "is_expired": false,
            "requested_types": [
                "food"
            ],
            "meal_type": "dinner",
            "food_category_codes": [
                "Prepared/Mixed Meals"
            ],
            "analysis_summary": "Your recent HbA1c of 7.5% shows continued effort but remains above the target of 7.0%, indicating a need for stricter carbohydrate management to improve overall glucose control. Given your Type 2 Diabetes and low-carb dietary goals, every meal must prioritize very low GI and high protein content.",
            "latest_glucose_value": 180,
            "latest_hba1c": 7.5,
            "user_condition_id": 1,
            "was_viewed": false,
            "viewed_at": "0001-01-01T00:00:00Z",
            "foods_count": 0,
            "activities_count": 0,
            "foods_purchased": 0,
            "activities_completed": 0
        },
        {
            "session_id": "59f419b4-0614-429a-8797-5841cb8e8c10",
            "created_at": "2025-12-03T23:04:53.191243+07:00",
            "expires_at": "2025-12-10T23:04:53.191243+07:00",
            "is_expired": false,
            "requested_types": [
                "food"
            ],
            "meal_type": "dinner",
            "food_category_codes": [
                "Refined Grains"
            ],
            "analysis_summary": "Your recent HbA1c of 7.5% shows continued glucose control challenges, suggesting a need for even stricter adherence to low glycemic index foods and portion control. Given your current weight and hypertension, focusing on fiber and controlled carbohydrates remains critical for better metabolic health.",
            "latest_glucose_value": 180,
            "latest_hba1c": 7.5,
            "user_condition_id": 1,
            "was_viewed": false,
            "viewed_at": "0001-01-01T00:00:00Z",
            "foods_count": 0,
            "activities_count": 0,
            "foods_purchased": 0,
            "activities_completed": 0
        }
    ],
    "total_count": 28,
    "page": 1,
    "page_size": 10,
    "has_more": true
}


