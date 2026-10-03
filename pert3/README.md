# Praktikum Pemrograman Mobile - Modul 3

Modul 3 berisi latihan mengelola data dan state pada aplikasi Flutter menggunakan `Provider`. Pada modul ini aplikasi mulai dibuat lebih interaktif karena data dapat berubah dan perubahan tersebut akan langsung ditampilkan pada halaman.

## Materi yang dipelajari

### 1. Class dan Model Data

Mempelajari cara membuat `class` untuk menyimpan data dengan lebih terstruktur.

Pada latihan ini dibuat model `Tugas` yang memiliki beberapa data seperti nama tugas, jumlah, kategori, dan status selesai.

### 2. ChangeNotifier

`ChangeNotifier` digunakan untuk memberi tahu widget ketika terdapat perubahan pada data.

Dengan menggunakan `ChangeNotifier`, perubahan data dapat diteruskan ke bagian aplikasi yang membutuhkan data tersebut.

### 3. Provider

`Provider` digunakan untuk menghubungkan data atau state dengan widget yang ada di dalam aplikasi.

Dengan Provider, widget dapat mengambil data dari model tanpa harus mengirim data secara manual dari satu widget ke widget lainnya.

### 4. notifyListeners()

`notifyListeners()` digunakan setelah data mengalami perubahan untuk memberi tahu widget agar melakukan pembaruan tampilan.

Contohnya ketika status sebuah tugas berubah menjadi selesai, tampilan jumlah tugas selesai juga ikut berubah.

### 5. Consumer

`Consumer` digunakan untuk mengambil data dari Provider dan membangun ulang bagian widget yang membutuhkan data tersebut ketika terjadi perubahan.

### 6. ListView.builder

`ListView.builder` digunakan untuk menampilkan daftar tugas dari data yang tersimpan di dalam model.

Dengan cara ini, jumlah item yang ditampilkan dapat mengikuti jumlah data yang ada.

### 7. Mengubah Status Data

Pada modul ini pengguna dapat mengubah status tugas, misalnya dari belum selesai menjadi selesai.

Ketika status berubah, data pada model diperbarui dan tampilan aplikasi ikut berubah secara otomatis.

## Hasil

Pada modul ini saya membuat aplikasi sederhana untuk menampilkan dan mengelola daftar tugas.

Aplikasi dapat menampilkan daftar tugas, kategori, jumlah tugas yang selesai, serta mengubah status tugas menjadi selesai menggunakan `Provider` dan `ChangeNotifier`.

**Nama:** Muhammad Naufal Febrian
**NIM:** 20240801068
**Program Studi:** Teknik Informatika
