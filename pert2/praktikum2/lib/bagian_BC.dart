import 'package:flutter/material.dart';

class Makanan {
  final String nama;
  final int harga;
  final String deskripsi;

  const Makanan(this.nama, this.harga, this.deskripsi);
}

String formatRupiah(int harga) {
  return harga.toString().replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
        (match) => '.',
  );
}

const daftarMenu = [
  Makanan('Nasi Goreng', 15000, "Nasi Goreng enak bangett!!!"),
  Makanan('Mie Ayam', 12000, "Mie Ayam enak bangett!!!"),
  Makanan('Es Teh', 4000, "Es Teh seger bangett!!!"),
  Makanan('Ayam Bakar', 20000, "Ayam Bakar enak bangett!!!"),
  Makanan('Seblak', 15000, "Seblak enak bangett!!!"),
  Makanan('Baso Aci', 10000, "Basi Aci enak bangett!!!"),
  Makanan('Nasi Bakar', 12000, "Nasi Bakar enak bangett!!!"),
];

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Menu', style: TextStyle(color: Colors.white),), backgroundColor: Colors.blueGrey),
      body: ListView.builder(
        itemCount: daftarMenu.length,
        itemBuilder: (context, index) {
          final item = daftarMenu[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: Colors.blueGrey, borderRadius: BorderRadius.circular(25)),
            child: ListTile(
              leading: const Icon(Icons.restaurant),
              title: Text(item.nama, style: TextStyle(color: Colors.white),),
              subtitle: Text('Rp ${formatRupiah(item.harga)}', style: TextStyle(color: Colors.white)),
              trailing: const Icon(Icons.chevron_right, color: Colors.white,),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DetailPage(makanan: item)),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Praktikum 2',
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
      home: const MenuPage(),
    );
  }
}

class DetailPage extends StatelessWidget {
  final Makanan makanan;

  const DetailPage({super.key, required this.makanan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(makanan.nama)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.restaurant_menu, size: 80),
            const SizedBox(height: 16),
            Text(makanan.nama, style: const TextStyle(fontSize: 24)),
            Text('Rp ${formatRupiah(makanan.harga)}'),
            Text(makanan.deskripsi, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }
}

