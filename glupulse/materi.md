# Ringkasan Materi Proyek Glupulse untuk Skripsi

Dokumen ini berisi rangkuman teknis dan fungsional dari aplikasi Glupulse sebagai referensi penulisan skripsi.

## 1. Profil Proyek
- **Nama Aplikasi**: Glupulse
- **Platform**: Flutter (Cross-platform Android & iOS)
- **Tujuan Utama**: Membantu penderita diabetes dan individu yang peduli kesehatan dalam mengelola kadar gula darah, nutrisi, aktivitas fisik, dan pengobatan melalui pendekatan data-driven dan AI.

## 2. Arsitektur Perangkat Lunak: Clean Architecture
Aplikasi ini menerapkan **Clean Architecture**, yang memisahkan kode menjadi lapisan-lapisan independen untuk meningkatkan *maintainability* dan *testability*:

1.  **Presentation Layer (UI & Logic)**:
    - Menggunakan **Cubit** (bagian dari Flutter BLoC) untuk State Management.
    - Berisi widget UI dan Cubit yang mengelola state layar.
2.  **Domain Layer (Business Logic)**:
    - **Entities**: Objek bisnis dasar (contoh: `GlucoseRecord`, `FoodItem`).
    - **Use Cases**: Logika spesifik aplikasi (contoh: `AddGlucoseRecord`, `GetAIRecommendations`).
    - **Repositories (Interfaces)**: Kontrak untuk data, tanpa memedulikan asal data.
3.  **Data Layer (Implementation)**:
    - **Repositories Implementation**: Implementasi dari kontrak di domain layer.
    - **Data Sources**: Pengambilan data dari Remote (REST API) atau Local (SharedPreferences).

## 3. Tech Stack & Library Utama
- **Framework**: Flutter & Dart.
- **State Management**: Flutter BLoC (Cubit).
- **Dependency Injection**: `get_it`.
- **Networking**: `http`, `ApiClient` (Custom wrapper).
- **Authentication**: OAuth (Google Sign-In) & Manual Auth (Email/OTP).
- **Data Persistence**: `shared_preferences`.
- **Connectivity**: `internet_connection_checker`.

## 4. Fitur-Fitur Utama (Bahan Bahasan Skripsi)

### A. Health Monitoring & Tracking
- **Manajemen Gula Darah (Glucose)**: Pencatatan rutin dengan pelacakan fluktuasi data.
- **HbA1c Tracker**: Pendokumentasian hasil laboratorium untuk melihat rata-rata jangka panjang.
- **Health Events**: Pencatatan insiden atau gejala spesifik untuk analisis medis.

### B. Nutrisi & Aktivitas (Lifestyle)
- **Meal Log**: Jurnal makanan yang mencakup rincian nutrisi (kalori, karbohidrat, protein, lemak, serat).
- **Activity & Sleep Log**: Pemantauan durasi tidur dan aktivitas fisik harian untuk melihat korelasinya dengan kadar gula darah.
- **Medication Management**: Sistem pengingat dan log konsumsi obat (Adherence).

### C. Personalisasi & AI
- **AI Recommendations**: Memberikan saran kesehatan, nutrisi, dan aktivitas yang dipersonalisasi berdasarkan profil kesehatan pengguna.
- **Health Profile**: Penentuan target metabolisme (HbA1c target, glucose target) berdasarkan diagnosis medis.

### D. Ecosystem & Marketplace
- **E-commerce**: Pembelian produk kesehatan, manajemen keranjang belanja, dan pelacakan pesanan.
- **Seller Side**: Dashboard untuk penjual makanan/produk kesehatan khusus diabetes.

## 5. Alur Data (Data Flow) Contoh: Input Gula Darah
1.  **User Interface**: Pengguna memasukkan angka gula darah di `GlucoseScreen`.
2.  **Cubit**: `GlucoseCubit` memanggil fungsi `AddGlucoseRecord` (Use Case).
3.  **Use Case**: Memproses logika dan memanggil `GlucoseRepository`.
4.  **Repository**: `GlucoseRepositoryImpl` memutuskan untuk mengirim data ke `GlucoseRemoteDataSource`.
5.  **Data Source**: Mengirim request POST ke API backend melalui `ApiClient`.

## 6. Potensi Topik Penelitian Skripsi
1.  **Implementasi Arsitektur**: "Penerapan Clean Architecture pada Pengembangan Aplikasi Manajemen Diabetes Glupulse Berbasis Flutter".
2.  **State Management**: "Efisiensi Cubit State Management dalam Sinkronisasi Data Kesehatan Real-time pada Aplikasi Android".
3.  **User Experience**: "Analisis User Experience pada Aplikasi Monitoring Diabetes Glupulse Menggunakan Metode [Metode UX]".
4.  **AI Integration**: "Rancang Bangun Sistem Rekomendasi Kesehatan Berbasis AI pada Aplikasi Glupulse".

---
*Dokumen ini diperbarui secara otomatis berdasarkan struktur kode terbaru.*
