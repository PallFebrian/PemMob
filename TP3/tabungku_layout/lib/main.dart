import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TabungKu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7F8),
      ),
      home: const RingkasanPage(),
    );
  }
}

// Model sederhana untuk menyimpan data transaksi.
class Transaksi {
  final String judul;
  final String tanggal;
  final int nominal;
  final bool pemasukan;

  const Transaksi(this.judul, this.tanggal, this.nominal, this.pemasukan);
}

// Data transaksi sementara.
const daftarTransaksi = [
  Transaksi('Menabung bulanan', '10 November 2026', 500000, true),
  Transaksi('Beli perlengkapan', '8 November 2026', 150000, false),
  Transaksi('Uang tambahan', '5 November 2026', 250000, true),
];

class RingkasanPage extends StatelessWidget {
  const RingkasanPage({super.key});

  @override
  Widget build(BuildContext context) {
    const int saldo = 1850000;
    const int target = 5000000;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ringkasan Tabungan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFF5F7F8),
      ),

      // ScrollView mencegah overflow pada layar kecil.
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'TabungKu',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF123C3A),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Pantau tabungan dan transaksi kamu.',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 24),

              // Kartu informasi saldo dan target tabungan.
              Card(
                color: const Color(0xFF146B63),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.savings_outlined, color: Colors.white),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Tabungan Impian',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Saldo saat ini',
                        style: TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Rp ${formatRupiah(saldo)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 22),
                      const Text(
                        'Target tabungan',
                        style: TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Rp ${formatRupiah(target)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Indikator progres target tabungan.
                      LinearProgressIndicator(
                        value: saldo / target,
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(8),
                        backgroundColor: Colors.white24,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFFB8F2D5),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '37% dari target tercapai',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),
              const Text(
                'Aktivitas Tabungan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Tiga ikon kategori disusun menggunakan Row.
              const Row(
                children: [
                  Expanded(
                    child: KategoriItem(
                      icon: Icons.add_circle_outline,
                      label: 'Menabung',
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: KategoriItem(
                      icon: Icons.remove_circle_outline,
                      label: 'Tarik',
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: KategoriItem(icon: Icons.history, label: 'Riwayat'),
                  ),
                ],
              ),

              const SizedBox(height: 30),
              const Text(
                'Transaksi Terakhir',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // Daftar transaksi dari data statis.
              ...daftarTransaksi.map(
                (item) => Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  elevation: 0,
                  color: Colors.white,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: item.pemasukan
                          ? const Color(0xFFE0F5EA)
                          : const Color(0xFFFFEEE5),
                      child: Icon(
                        item.pemasukan
                            ? Icons.arrow_downward
                            : Icons.arrow_upward,
                        color: item.pemasukan
                            ? const Color(0xFF16805A)
                            : const Color(0xFFD66B36),
                      ),
                    ),
                    title: Text(
                      item.judul,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      item.tanggal,
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: Text(
                      '${item.pemasukan ? '+' : '-'}Rp ${formatRupiah(item.nominal)}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: item.pemasukan
                            ? const Color(0xFF16805A)
                            : const Color(0xFFD66B36),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget untuk menampilkan kategori aktivitas.
class KategoriItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const KategoriItem({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, size: 30, color: const Color(0xFF146B63)),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

// Mengubah angka menjadi format ribuan sederhana.
String formatRupiah(int angka) {
  final teks = angka.toString();
  final hasil = StringBuffer();

  for (int i = 0; i < teks.length; i++) {
    if (i > 0 && (teks.length - i) % 3 == 0) {
      hasil.write('.');
    }
    hasil.write(teks[i]);
  }

  return hasil.toString();
}
