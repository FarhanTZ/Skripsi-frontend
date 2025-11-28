RINGKASAN ALUR MEAL LOG SYSTEM (BERBASIS TEKS)
1. Pembuatan Catatan Makan (Create Meal Log)

Pengguna memulai dengan membuat satu catatan makan (meal log) yang merepresentasikan satu sesi makan, seperti sarapan, makan siang, atau makan malam.
Pada tahap ini, sistem hanya menyimpan informasi umum seperti waktu makan, jenis makan, deskripsi, dan tag. Nilai total nutrisi dapat diisi nol terlebih dahulu karena detail makanan belum ditambahkan.

2. Penambahan Detail Makanan (Add Meal Items)

Setelah catatan makan berhasil dibuat dan menghasilkan meal_id, pengguna dapat menambahkan satu atau lebih item makanan ke dalam catatan tersebut.
Setiap item makanan berisi informasi detail seperti nama makanan, jumlah, serta kandungan nutrisi (karbohidrat, protein, lemak, dan lainnya).
Semua item makanan terhubung ke satu catatan makan melalui meal_id.

3. Perhitungan dan Rekapitulasi Nutrisi

Sistem menghitung total nutrisi dengan menjumlahkan seluruh nilai nutrisi dari item makanan yang terdapat dalam satu catatan makan.
Hasil perhitungan tersebut disimpan pada data catatan makan sebagai ringkasan nutrisi (total calories, total protein, total karbohidrat, dan sebagainya).
Perhitungan ini dapat dilakukan secara otomatis setiap kali item ditambahkan atau diperbarui.

4. Penampilan Daftar Riwayat Makan (Meal Log List)

Pengguna dapat melihat riwayat makan dalam bentuk daftar catatan makan.
Pada tampilan ini, sistem hanya menampilkan informasi ringkas seperti waktu makan, jenis makan, deskripsi singkat, serta total nutrisi.
Detail item makanan tidak ditampilkan untuk menjaga performa dan kejelasan tampilan.

5. Penampilan Detail Catatan Makan (Meal Log Detail)

Ketika pengguna memilih salah satu catatan makan dari daftar, sistem akan menampilkan detail lengkap dari catatan tersebut.
Tampilan ini mencakup informasi umum catatan makan serta daftar seluruh item makanan yang dikonsumsi beserta nilai nutrisinya masing-masing.

6. Pengelolaan Data (Update dan Delete)

Pengguna dapat memperbarui atau menghapus catatan makan maupun item makanan di dalamnya.
Setiap perubahan pada item makanan akan secara otomatis memengaruhi perhitungan total nutrisi pada catatan makan terkait sehingga data tetap konsisten.

RANGKUMAN SINGKAT (1 PARAGRAF – SIAP COPY)

Sistem pencatatan makan diawali dengan pembuatan catatan makan sebagai induk data yang menyimpan informasi umum waktu dan jenis makan. Selanjutnya, pengguna menambahkan detail makanan sebagai data turunan yang terhubung melalui identitas catatan makan. Sistem melakukan perhitungan nutrisi berdasarkan seluruh item makanan dan menyimpannya sebagai ringkasan pada catatan makan. Riwayat makan ditampilkan dalam bentuk daftar ringkas, sedangkan detail lengkap makanan hanya ditampilkan ketika pengguna memilih salah satu catatan makan.