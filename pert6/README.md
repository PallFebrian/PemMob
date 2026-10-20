# Modul 6 - Galeri dan Katalog Interaktif Flutter

**Nama:** Muhammad Naufal Febrian  
**NIM:** 20240801068  
**Mata Kuliah:** Pemrograman Mobile

## 1. Tujuan Praktikum

Pada modul ini, saya mempelajari cara membuat aplikasi Flutter yang interaktif melalui navigasi, animasi, pengelolaan tema, dan state. Materi diterapkan pada aplikasi katalog Vespa dengan gambar dari URL online.

Tujuan praktikum:
- Memahami navigasi menggunakan `Navigator`.
- Memahami penggunaan `IndexedStack`.
- Menerapkan animasi implisit dan eksplisit.
- Memahami transisi halaman menggunakan `Hero`.
- Mengatur tampilan menggunakan `ThemeData`.
- Membuat fitur favorit pada katalog Vespa.

## 2. Navigasi Halaman

`Navigator` digunakan untuk berpindah antarhalaman.

| Fungsi | Kegunaan |
|---|---|
| `Navigator.push()` | Membuka halaman baru. |
| `Navigator.pop()` | Kembali ke halaman sebelumnya. |

Contoh:

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const DetailPage(),
  ),
);
```

**Penerapan:** Membuka halaman detail ketika pengguna memilih Vespa dari katalog.

## 3. Navigasi Tab dengan IndexedStack

`IndexedStack` menampilkan satu halaman berdasarkan indeks yang dipilih dan dapat mempertahankan state halaman lainnya.

```dart
IndexedStack(
  index: _selectedIndex,
  children: const [
    BerandaPage(),
    FavoritPage(),
  ],
);
```

- `index`: menentukan halaman yang ditampilkan.
- `children`: daftar halaman yang tersedia.

**Perbedaan:** `IndexedStack` cocok untuk navigasi tab, sedangkan `Navigator` cocok untuk membuka halaman baru seperti detail Vespa.

## 4. Animasi Implisit dan Eksplisit

| Jenis | Penjelasan | Contoh |
|---|---|---|
| Implisit | Animasi berjalan otomatis ketika properti berubah. | `AnimatedContainer`, `AnimatedOpacity` |
| Eksplisit | Animasi dikontrol menggunakan controller. | `AnimationController`, `Animation` |

Contoh animasi implisit:

```dart
AnimatedContainer(
  duration: const Duration(milliseconds: 300),
  width: isExpanded ? 200 : 100,
  color: isExpanded ? Colors.green : Colors.grey,
);
```

**Intinya:** Gunakan animasi implisit untuk perubahan sederhana dan animasi eksplisit jika membutuhkan kontrol animasi lebih lanjut.

## 5. Hero Animation

`Hero` membuat transisi visual antarhalaman, misalnya gambar Vespa pada katalog membesar menuju gambar yang sama di halaman detail.

```dart
Hero(
  tag: 'vespa-sprint',
  child: Image.network(imageUrl),
);
```

**Hal yang perlu diperhatikan:** Kedua widget `Hero` harus memiliki `tag` yang sama dan tag tersebut harus unik di antara Hero yang tampil bersamaan pada setiap halaman.

## 6. Tema Aplikasi

`ThemeData` digunakan untuk mengatur tampilan aplikasi secara konsisten, sedangkan `Theme.of(context)` digunakan untuk mengambil tema yang aktif.

```dart
ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.green,
  ),
  useMaterial3: true,
);
```

Mengambil warna dari tema:

```dart
Theme.of(context).colorScheme.primary
```

**Keuntungan:** Warna dan tampilan lebih konsisten serta lebih mudah disesuaikan tanpa mengubah setiap widget satu per satu.

## 7. Fitur Favorit

Fitur favorit memungkinkan pengguna menandai Vespa yang disukai.

Contoh ikon favorit:

```dart
IconButton(
  onPressed: () {
    setState(() {
      isFavorite = !isFavorite;
    });
  },
  icon: Icon(
    isFavorite ? Icons.favorite : Icons.favorite_border,
  ),
);
```

- `setState()` memperbarui tampilan setelah nilai berubah.
- `isFavorite` menentukan ikon yang ditampilkan.
- `Icons.favorite` menunjukkan item sudah disukai.
- `Icons.favorite_border` menunjukkan item belum disukai.

*Catatan: Contoh ini menggunakan state sederhana. Penyimpanan favorit secara permanen memerlukan mekanisme penyimpanan tambahan.*

## 8. Menjalankan Project

Masuk ke folder project yang ingin dijalankan.

**Praktikum:**

```bash
cd pert6/praktikum6
flutter pub get
flutter run
```

**Tugas:**

```bash
cd pert6/tugas6
flutter pub get
flutter run
```

- `flutter pub get`: mengunduh dependency yang dibutuhkan.
- `flutter run`: menjalankan aplikasi pada emulator atau perangkat yang terhubung.

Pastikan perangkat memiliki koneksi internet karena katalog menggunakan gambar dari URL online.

## 9. Kesimpulan

Modul 6 mengajarkan penggunaan navigasi, animasi, tema, dan state untuk membangun aplikasi Flutter yang lebih interaktif. Materi tersebut diterapkan dalam katalog Vespa yang memiliki tampilan gambar, halaman detail, serta fitur favorit.
