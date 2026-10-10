# Modul 5 - Penyimpanan Data Lokal pada Flutter

**Nama:** Muhammad Naufal Febrian  
**NIM:** 20240801068  
**Mata Kuliah:** Pemrograman Mobile

## 1. Tujuan Praktikum

Pada praktikum ini, saya mempelajari cara menyimpan data secara lokal pada aplikasi Flutter menggunakan SQLite dan SharedPreferences. Materi ini diterapkan dalam aplikasi Expense Tracker atau aplikasi pencatat pengeluaran.

Tujuan praktikum:
- Memahami penggunaan database SQLite pada Flutter.
- Memahami cara menyimpan pengaturan menggunakan SharedPreferences.
- Menerapkan fitur CRUD (Create, Read, Update, Delete).
- Membuat form dengan validasi input.
- Menampilkan total pengeluaran dari data yang tersimpan.
- Memahami cara agar data tetap tersimpan meskipun aplikasi ditutup.

## 2. Instalasi Package

Sebelum menggunakan SQLite dan SharedPreferences, kita perlu menambahkan package yang dibutuhkan ke dalam project Flutter.

Buka terminal pada folder project, kemudian jalankan perintah berikut.

### A. SharedPreferences

```bash
flutter pub add shared_preferences
```

**Fungsi:** Menambahkan package `shared_preferences` untuk menyimpan data sederhana dalam bentuk key-value.

Contoh penggunaannya:
- Menyimpan pilihan mode gelap.
- Menyimpan nama pengguna.
- Menyimpan preferensi aplikasi.

Contoh kode:

```dart
final prefs = await SharedPreferences.getInstance();
await prefs.setBool('gelap', true);
```

Kode tersebut menyimpan nilai `true` dengan key `gelap`, yang dapat digunakan untuk mengingat pilihan mode gelap pengguna.

### B. SQLite dan Path

```bash
flutter pub add sqflite path
```

Perintah tersebut menambahkan dua package sekaligus.

**1. `sqflite`**

Digunakan untuk mengakses database SQLite dari Flutter. Package ini menyediakan fungsi untuk membuat database, menjalankan query, serta melakukan operasi CRUD.

**2. `path`**

Digunakan untuk menyusun lokasi file database dengan format path yang sesuai dengan sistem operasi.

Contoh kode:

```dart
final path = p.join(
  await getDatabasesPath(),
  'pengeluaran.db',
);
```

Kode tersebut menentukan lokasi file database bernama `pengeluaran.db`.

Setelah package ditambahkan, Flutter akan memperbarui konfigurasi dependency pada `pubspec.yaml`.

## 3. Perbedaan SQLite dan SharedPreferences

| SQLite | SharedPreferences |
|---|---|
| Digunakan untuk menyimpan data terstruktur. | Digunakan untuk menyimpan pengaturan sederhana. |
| Data disimpan dalam tabel dan baris. | Data disimpan dalam pasangan key-value. |
| Cocok untuk banyak catatan. | Cocok untuk sedikit data pengaturan. |
| Contoh: data pengeluaran. | Contoh: pilihan mode gelap. |

Pada aplikasi Expense Tracker, SQLite digunakan untuk menyimpan catatan pengeluaran, sedangkan SharedPreferences digunakan untuk menyimpan pilihan mode gelap.

## 4. Membuat Model Data

Model digunakan untuk merepresentasikan data pengeluaran dalam kode Dart.

Pada project ini, class `Pengeluaran` memiliki beberapa atribut:
- `id`: identitas unik setiap data.
- `nama`: nama pengeluaran.
- `jumlah`: nominal pengeluaran dalam bentuk integer.
- `kategori`: kategori pengeluaran.
- `tanggal`: tanggal pengeluaran.

Model juga memiliki dua fungsi penting:

**`toMap()`**

Mengubah objek Dart menjadi `Map` agar dapat disimpan ke database SQLite.

**`fromMap()`**

Mengubah data hasil query database menjadi objek `Pengeluaran` agar mudah digunakan dalam aplikasi.

## 5. Membuat Database SQLite

Database dikelola melalui class `DbHelper`. Database yang digunakan bernama `pengeluaran.db`, dengan tabel `pengeluaran`.

Struktur tabel:

| Kolom | Tipe Data | Fungsi |
|---|---|---|
| `id` | INTEGER | Primary key dan bertambah otomatis. |
| `nama` | TEXT | Menyimpan nama pengeluaran. |
| `jumlah` | INTEGER | Menyimpan nominal pengeluaran. |
| `kategori` | TEXT | Menyimpan kategori pengeluaran. |
| `tanggal` | TEXT | Menyimpan tanggal pengeluaran. |

Tabel dibuat menggunakan perintah SQL `CREATE TABLE`.

### Fungsi Database

- **`tambah()`**: memasukkan data pengeluaran baru.
- **`semua()`**: mengambil seluruh data pengeluaran.
- **`ubah()`**: memperbarui data berdasarkan ID.
- **`hapus()`**: menghapus data berdasarkan ID.

Database lokal membuat data tetap tersedia setelah aplikasi ditutup dan dibuka kembali.

## 6. Menerapkan CRUD

CRUD adalah empat operasi utama untuk mengelola data.

### A. Create (Tambah)

Pengguna mengisi form pengeluaran, kemudian menekan tombol Simpan. Data yang valid akan dimasukkan ke database menggunakan `DbHelper.tambah()`.

### B. Read (Tampilkan)

Data diambil dari database menggunakan `DbHelper.semua()`. Pada halaman utama, `FutureBuilder` digunakan untuk menampilkan status loading, menangani error, dan menampilkan data setelah selesai dimuat.

### C. Update (Ubah)

Pengguna membuka data yang sudah ada, mengubah informasi pada form, lalu menyimpannya. Data diperbarui menggunakan `DbHelper.ubah()` berdasarkan ID pengeluaran.

### D. Delete (Hapus)

Pengguna menekan tombol hapus pada catatan pengeluaran. Data tersebut dihapus dari database menggunakan `DbHelper.hapus()`.

## 7. Validasi Form

Validasi digunakan untuk mencegah pengguna memasukkan data yang tidak sesuai.

Pada aplikasi ini:
- Nama pengeluaran wajib diisi.
- Jumlah harus berupa angka dan lebih dari 0.
- Kategori dipilih melalui dropdown.

Validasi dilakukan menggunakan `TextFormField`, `validator`, dan `DropdownButtonFormField`.

Dengan validasi, data yang masuk ke database menjadi lebih sesuai dengan kebutuhan aplikasi.

## 8. Menghitung Total Pengeluaran

Total pengeluaran ditampilkan pada halaman utama. Perhitungannya dilakukan di Dart menggunakan fungsi `fold()`.

Contoh kode:

```dart
final total = data.fold<int>(
  0,
  (jumlah, item) => jumlah + item.jumlah,
);
```

Kode tersebut menjumlahkan nilai `jumlah` dari seluruh catatan pengeluaran yang berhasil diambil dari database.

## 9. Menyimpan Pengaturan dengan SharedPreferences

Pada aplikasi ini, SharedPreferences digunakan untuk menyimpan pilihan mode gelap.

Ketika pengguna mengubah mode, aplikasi menyimpan nilainya:

```dart
final prefs = await SharedPreferences.getInstance();
await prefs.setBool('gelap', nilai);
```

Saat aplikasi dibuka kembali, pilihan tersebut dibaca menggunakan:

```dart
final prefs = await SharedPreferences.getInstance();
final gelap = prefs.getBool('gelap') ?? false;
```

Jika belum pernah ada pilihan yang tersimpan, nilai default-nya adalah `false`, yaitu mode terang.

Nilai tersebut digunakan untuk menentukan `ThemeMode` pada `MaterialApp`, sehingga tampilan aplikasi mengikuti pilihan pengguna.

## 10. Memuat Ulang Data

Setelah pengguna kembali dari halaman tambah atau edit, daftar pengeluaran perlu dimuat ulang agar perubahan terbaru langsung terlihat.

Pada project ini, halaman form dibuka menggunakan `Navigator.push()`. Setelah halaman form ditutup, fungsi `_muatData()` dipanggil kembali di dalam `setState()`.

Setelah itu, `FutureBuilder` menerima Future terbaru dan menampilkan data yang sudah diperbarui.

## 11. Hasil Praktikum

Aplikasi Expense Tracker yang dibuat memiliki fitur:
- Menampilkan daftar pengeluaran.
- Menambah, mengubah, dan menghapus catatan pengeluaran.
- Memvalidasi input nama, jumlah, dan kategori.
- Menampilkan total seluruh pengeluaran.
- Menyimpan catatan pengeluaran menggunakan SQLite.
- Menyimpan pilihan mode gelap menggunakan SharedPreferences.
- Mempertahankan data pengeluaran dan pilihan tema setelah aplikasi ditutup dan dibuka kembali.


Materi ini menjadi dasar untuk mengembangkan aplikasi mobile yang membutuhkan penyimpanan data lokal tanpa harus selalu terhubung ke server.
