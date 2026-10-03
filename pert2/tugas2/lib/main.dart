import 'package:flutter/material.dart';

class Kontak {
  final String nama;
  final String nomorTelepon;
  final String email;

  const Kontak(this.nama, this.nomorTelepon, this.email);
}

const daftarKontak = [
  Kontak('Muhammad', '08123456781', 'muhammad@gmail.com'),
  Kontak('Naufal', '08123456782', 'naufal@gmail.com'),
  Kontak('Febrian', '08123456783', 'febrian@gmail.com'),
  Kontak('Candra', '08123456784', 'candra@gmail.com'),
  Kontak('Sudiman', '08123456785', 'sudiman@gmail.com'),
  Kontak('Suparno', '08123456786', 'suparno@gmail.com'),
  Kontak('Upri', '08123456789', 'upri@gmail.com'),
];

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Kontak',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueGrey,
      ),
      body: ListView.builder(
        itemCount: daftarKontak.length,
        itemBuilder: (context, index) {
          final item = daftarKontak[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(25)),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(
                  item.nama[0],
                ),
              ),
              title: Text(item.nama),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.email),
                  Text(item.nomorTelepon),
                ],
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DetailPage(nomor: item)),
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
  final Kontak nomor;

  const DetailPage({super.key, required this.nomor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nomor.nama),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 70,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.person,
                    size: 50,
                  ),
                  Text(
                    nomor.nama[0],
                    style: const TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Text(
              nomor.nama,
              style: const TextStyle(
                fontSize: 24,
              ),
            ),

            Text(nomor.nomorTelepon),

            Text(
              nomor.email,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),

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

