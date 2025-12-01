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