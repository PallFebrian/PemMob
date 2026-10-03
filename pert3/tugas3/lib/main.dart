import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Tugas {
  String nama;
  int jumlah;
  String kategori;
  bool selesai;

  Tugas(
      this.nama,
      this.jumlah,
      this.kategori, {
        this.selesai = false,
      });
}

class TugasModel extends ChangeNotifier {
  final List<Tugas> _items = [];

  List<Tugas> get items => List.unmodifiable(_items);

  int get jumlahBelumDibeli =>
      _items.where((t) => !t.selesai).length;

  void tambah(String nama, int jumlah, String kategori) {
    _items.add(Tugas(nama, jumlah, kategori));
    notifyListeners();
  }

  void toggle(int index) {
    _items[index].selesai = !_items[index].selesai;
    notifyListeners();
  }

  void hapus(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void hapusSelesai() {
    _items.removeWhere((t) => t.selesai);
    notifyListeners();
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => TugasModel(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daftar Tugas',
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
      home: const TugasPage(),
    );
  }
}

class TugasPage extends StatelessWidget {
  const TugasPage({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<TugasModel>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Belanja (${model.jumlahBelumDibeli})'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () {
              context.read<TugasModel>().hapusSelesai();
            },
          ),
        ],
      ),
      body: model.items.isEmpty
          ? const Center(child: Text('Belum ada barang kamu'))
          : ListView.builder(
        itemCount: model.items.length,
        itemBuilder: (context, i) {
          final t = model.items[i];
          return ListTile(
            leading: Checkbox(
              value: t.selesai,
              onChanged: (_) => context.read<TugasModel>().toggle(i),
            ),
            title: Text(
              t.nama,
              style: TextStyle(
                decoration: t.selesai ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: Text(
              'Jumlah: ${t.jumlah} • Kategori: ${t.kategori}',
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => context.read<TugasModel>().hapus(i),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TambahPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TambahPage extends StatefulWidget {
  const TambahPage({super.key});

  @override
  State<TambahPage> createState() => _TambahPageState();
}

class _TambahPageState extends State<TambahPage> {
  final _controller = TextEditingController();
  final _jumlahController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _kategori;

  @override
  void dispose() {
    _controller.dispose();
    _jumlahController.dispose();
    super.dispose();
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;

    final nama = _controller.text.trim();
    final jumlah = int.parse(_jumlahController.text);
    final kategori = _kategori!;

    context.read<TugasModel>().tambah(nama, jumlah, kategori);

    Navigator.pop(context);

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(content: Text('Barang ditambahkan')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Barang')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                controller: _controller,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Nama Barang',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama barang wajib diisi';
                  }
                  return null;
                },
                onFieldSubmitted: (_) => _simpan(),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _jumlahController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Jumlah',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final jumlah = int.tryParse(value ?? '');

                  if (jumlah == null || jumlah <= 0) {
                    return 'Jumlah harus berupa angka lebih dari 0';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _kategori,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Makanan',
                    child: Text('Makanan'),
                  ),
                  DropdownMenuItem(
                    value: 'Minuman',
                    child: Text('Minuman'),
                  ),
                  DropdownMenuItem(
                    value: 'Kebutuhan Rumah',
                    child: Text('Kebutuhan Rumah'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _kategori = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kategori wajib dipilih';
                  }
                  return null;
                },
              ),
              ElevatedButton(onPressed: _simpan, child: const Text('Simpan')),
            ],
          ),
        ),
      ),
    );
  }
}
