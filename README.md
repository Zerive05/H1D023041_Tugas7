# H1D023041_Tugas7 - Sudoku by Zerive05

Aplikasi permainan Sudoku berbasis Flutter dengan fitur autentikasi pengguna sederhana, pilihan tingkat kesulitan, dan penyimpanan skor waktu terbaik (Local Storage).

## Identitas
**NIM:** H1D023041  
**Nama Aplikasi:** Sudoku by Zerive05

## Fitur Utama
1.  **User Auth:** Login sederhana menggunakan Username (disimpan di Shared Preferences).
2.  **Sudoku Game:** Papan permainan interaktif 9x9.
3.  **Tingkat Kesulitan:** 5 Level (Pemula, Mudah, Normal, Susah, Profesional) yang menentukan jumlah sel kosong.
4.  **Best Time Score:** Mencatat waktu tercepat penyelesaian game untuk setiap level.
5.  **Side Menu (Drawer):** Navigasi antar halaman.

## Tech Stack
* **Framework:** Flutter
* **Language:** Dart
* **State Management:** Provider
* **Local Storage:** Shared Preferences
* **IDE:** VSCode

## Screenshot Aplikasi

| Login Screen | Home / Level Selection |
| :---: | :---: |
|  |  |
| *Halaman Login Pengguna* | *Menu Pemilihan Level* |

| Game Play | Side Menu (Drawer) |
| :---: | :---: |
|  |  |
| *Tampilan Permainan Sudoku* | *Navigasi Side Menu* |

*(Catatan: Silakan ganti placeholder [Image of...] dengan screenshot asli dari emulator Anda)*

## Penjelasan Kode

### 1. `main.dart`
Titik masuk aplikasi. Di sini `MultiProvider` disiapkan untuk membungkus aplikasi agar state bisa diakses global. Routing (`routes`) juga didefinisikan di sini untuk navigasi (`/login`, `/home`, `/game`, `/history`). Logika `initialRoute` mengecek apakah user sudah login atau belum.

### 2. `providers/game_provider.dart`
Menggunakan `ChangeNotifier` untuk memisahkan logika bisnis dari UI.
* `login()`: Menyimpan sesi username ke Local Storage.
* `saveScore()`: Membandingkan waktu penyelesaian baru dengan data lama di `SharedPreferences`. Jika lebih cepat, data diperbarui.
* `loadUserData()`: Memuat data persisten saat aplikasi dibuka kembali.

### 3. `screens/game_screen.dart`
Inti permainan.
* `GridView.builder`: Membuat papan 9x9.
* `_initializeBoard()`: Menyiapkan papan berdasarkan tingkat kesulitan (semakin susah, semakin banyak angka yang diubah menjadi `null` atau kosong).
* `Timer`: Menghitung durasi permainan dalam detik.
* `_checkWin()`: Memvalidasi apakah input user sesuai dengan kunci jawaban.

### 4. `widgets/app_drawer.dart`
Komponen UI reusable untuk Side Menu. Menampilkan informasi user yang sedang login (diambil dari Provider) dan menu navigasi ke halaman Home atau History.

## Cara Menjalankan
1.  Pastikan Flutter SDK terinstal.
2.  Clone atau buka folder proyek ini.
3.  Jalankan `flutter pub get`.
4.  Jalankan `flutter run`.