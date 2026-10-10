# Modul 4 - Mengambil Data dari API pada Flutter

Nama: Muhammad Naufal Febrian NIM: 20240801068

## 1. Tujuan Pembelajaran

- Memahami cara mengambil data dari API.
- Mengubah data JSON menjadi objek Dart.
- Menampilkan data menggunakan `FutureBuilder`.
- Menangani kondisi loading dan error.

## 2. Mengambil Data dari API

API digunakan agar aplikasi bisa mengambil data dari server. Pada modul ini, API yang digunakan adalah:

`https://jsonplaceholder.typicode.com/users`

Untuk melakukan HTTP request, tambahkan package `http` pada `pubspec.yaml`, lalu jalankan:

```
flutter pub get
```

Tambahkan import berikut:

```
import 'dart:convert';
import 'package:http/http.dart' as http;
```

## 3. Model Data

Data JSON sebaiknya diubah menjadi class model agar lebih mudah dikelola.

Contohnya, class `Pengguna` memiliki atribut `id`, `name`, `email`, `phone`, dan `website`. Method `fromJson()` digunakan untuk mengubah data JSON menjadi objek Dart.

## 4. Mengambil Data dengan Future

`Future` digunakan untuk proses yang membutuhkan waktu, seperti mengambil data dari internet.

Alur kerjanya:

1. Mengirim request menggunakan `http.get()`.
2. Memeriksa `response.statusCode`.
3. Mengubah JSON menggunakan `jsonDecode()`.
4. Mengubah data menjadi objek `Pengguna`.
5. Menampilkan hasilnya pada aplikasi.

Status kode `200` berarti request berhasil.

## 5. Menampilkan Data dengan FutureBuilder

`FutureBuilder` membantu menampilkan UI sesuai kondisi proses pengambilan data.

- `snapshot.connectionState == ConnectionState.waiting`: data sedang dimuat.
- `snapshot.hasError`: terjadi kesalahan.
- `snapshot.hasData`: data tersedia dan bisa ditampilkan.

Future sebaiknya dibuat di `initState()`, bukan langsung di `build()`, supaya request API tidak dipanggil berulang kali setiap UI dibangun ulang.

## 6. Kesimpulan

Pada Modul 4, aplikasi Flutter belajar mengambil data dari API, mengubah JSON menjadi objek Dart, dan menampilkan data menggunakan `FutureBuilder`. Aplikasi juga perlu menangani kondisi loading dan error agar lebih mudah digunakan.
