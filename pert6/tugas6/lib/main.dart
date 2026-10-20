import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeMode = ValueNotifier<ThemeMode>(ThemeMode.light);
final seedColor = ValueNotifier<Color>(Colors.indigo);

final ValueNotifier<Set<String>> favoritIds = ValueNotifier<Set<String>>({});

Future<void> muatFavorit() async {
  final prefs = await SharedPreferences.getInstance();

  favoritIds.value = (prefs.getStringList('favoritVespa') ?? []).toSet();
}

Future<void> toggleFavorit(String id) async {
  final favoritBaru = Set<String>.from(favoritIds.value);

  if (favoritBaru.contains(id)) {
    favoritBaru.remove(id);
  } else {
    favoritBaru.add(id);
  }

  favoritIds.value = favoritBaru;

  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList('favoritVespa', favoritBaru.toList());
}

const pilihanWarna = [
  Colors.indigo,
  Colors.teal,
  Colors.deepOrange,
  Colors.pink,
];

ThemeData buatTema(Color seed, Brightness brightness) {
  return ThemeData(
    useMaterial3: true,
    colorSchemeSeed: seed,
    brightness: brightness,
    appBarTheme: const AppBarTheme(centerTitle: true),
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('isDarkMode') ?? false;
  final warnaIndex = prefs.getInt('warnaTema') ?? 0;

  themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
  seedColor.value =
      pilihanWarna[warnaIndex >= 0 && warnaIndex < pilihanWarna.length
          ? warnaIndex
          : 0];

  themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;

  seedColor.value =
      pilihanWarna[warnaIndex >= 0 && warnaIndex < pilihanWarna.length
          ? warnaIndex
          : 0];

  await muatFavorit();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([themeMode, seedColor]),
      builder: (context, _) {
        return MaterialApp(
          title: 'Praktikum 6',
          debugShowCheckedModeBanner: false,
          theme: buatTema(seedColor.value, Brightness.light),
          darkTheme: buatTema(seedColor.value, Brightness.dark),
          themeMode: themeMode.value,
          routes: {'/': (_) => const ShellPage()},
          onGenerateRoute: (settings) {
            if (settings.name == '/detail') {
              final item = settings.arguments;

              if (item is! Item) {
                return MaterialPageRoute<void>(
                  settings: settings,
                  builder: (_) => const Scaffold(
                    body: Center(child: Text('Data detail tidak valid')),
                  ),
                );
              }

              return PageRouteBuilder<void>(
                settings: settings,
                pageBuilder: (context, animation, secondaryAnimation) {
                  return DetailPage(item: item);
                },
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                transitionDuration: const Duration(milliseconds: 500),
              );
            }

            return null;
          },
          onUnknownRoute: (settings) {
            return MaterialPageRoute<void>(
              settings: settings,
              builder: (context) => Scaffold(
                appBar: AppBar(title: const Text('404')),
                body: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline, size: 80, color: Colors.red),
                      SizedBox(height: 16),
                      Text(
                        '404 - Halaman tidak ditemukan',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class PengaturanTab extends StatelessWidget {
  const PengaturanTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([themeMode, seedColor]),
      builder: (context, _) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SwitchListTile(
              title: const Text('Mode gelap'),
              value: themeMode.value == ThemeMode.dark,
              onChanged: (value) async {
                themeMode.value = value ? ThemeMode.dark : ThemeMode.light;

                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isDarkMode', value);
              },
            ),
            const SizedBox(height: 8),
            Text('Warna tema', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              children: [
                for (final color in pilihanWarna)
                  GestureDetector(
                    onTap: () async {
                      seedColor.value = color;

                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setInt(
                        'warnaTema',
                        pilihanWarna.indexOf(color),
                      );
                    },
                    child: CircleAvatar(
                      backgroundColor: color,
                      child: seedColor.value == color
                          ? const Icon(Icons.check, color: Colors.white)
                          : null,
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class Item {
  final String id;
  final String nama;
  final String deskripsi;
  final IconData ikon;

  const Item({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.ikon,
  });
}

const daftarItem = [
  Item(
    id: 'sprint',
    nama: 'Vespa Sprint',
    deskripsi: 'Vespa bergaya sporty dengan desain tegas dan modern.',
    ikon: Icons.two_wheeler,
  ),
  Item(
    id: 'primavera',
    nama: 'Vespa Primavera',
    deskripsi: 'Vespa dengan desain elegan dan klasik untuk berkendara.',
    ikon: Icons.two_wheeler,
  ),
  Item(
    id: 'gts',
    nama: 'Vespa GTS',
    deskripsi: 'Vespa berukuran besar dengan karakter touring.',
    ikon: Icons.two_wheeler,
  ),
  Item(
    id: 'sxl',
    nama: 'Vespa LX',
    deskripsi: 'Vespa dengan desain sederhana yang ikonik.',
    ikon: Icons.two_wheeler,
  ),
];

class BerandaTab extends StatelessWidget {
  const BerandaTab({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Katalog Vespa', style: tema.textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text(
          'Kenali berbagai model Vespa favoritmu.',
          style: tema.textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        for (final item in daftarItem)
          Card(
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: Hero(
                tag: 'ikon-${item.id}',
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: tema.colorScheme.primaryContainer,
                  child: Icon(
                    item.ikon,
                    size: 30,
                    color: tema.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              title: Text(item.nama),
              subtitle: Text(item.deskripsi),
              trailing: ValueListenableBuilder<Set<String>>(
                valueListenable: favoritIds,
                builder: (context, ids, child) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: ids.contains(item.id)
                            ? 'Hapus dari favorit'
                            : 'Tambah ke favorit',
                        onPressed: () => toggleFavorit(item.id),
                        icon: Icon(
                          ids.contains(item.id)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: ids.contains(item.id)
                              ? tema.colorScheme.primary
                              : tema.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  );
                },
              ),
              onTap: () {
                Navigator.pushNamed(context, '/detail', arguments: item);
              },
            ),
          ),
      ],
    );
  }
}

class FavoritTab extends StatelessWidget {
  const FavoritTab({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return ValueListenableBuilder<Set<String>>(
      valueListenable: favoritIds,
      builder: (context, ids, child) {
        final daftarFavorit = daftarItem
            .where((item) => ids.contains(item.id))
            .toList();

        if (daftarFavorit.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 64,
                  color: tema.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 12),
                Text(
                  'Belum ada Vespa favorit',
                  style: tema.textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Pilih ikon hati di halaman Beranda.',
                  style: tema.textTheme.bodyMedium,
                ),
              ],
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Vespa Favorit', style: tema.textTheme.headlineSmall),
            const SizedBox(height: 12),
            for (final item in daftarFavorit)
              Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: tema.colorScheme.primaryContainer,
                    child: Icon(
                      item.ikon,
                      color: tema.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  title: Text(item.nama),
                  subtitle: Text(item.deskripsi),
                  trailing: IconButton(
                    tooltip: 'Hapus dari favorit',
                    onPressed: () => toggleFavorit(item.id),
                    icon: Icon(Icons.favorite, color: tema.colorScheme.primary),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/detail', arguments: item);
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}

class DetailPage extends StatelessWidget {
  final Item item;

  const DetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(item.nama)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Hero(
                tag: 'ikon-${item.id}',
                child: CircleAvatar(
                  radius: 64,
                  backgroundColor: tema.colorScheme.primaryContainer,
                  child: Icon(
                    item.ikon,
                    size: 64,
                    color: tema.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                item.nama,
                style: tema.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                item.deskripsi,
                style: tema.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimasiTab extends StatefulWidget {
  const AnimasiTab({super.key});

  @override
  State<AnimasiTab> createState() => _AnimasiTabState();
}

class _AnimasiTabState extends State<AnimasiTab>
    with SingleTickerProviderStateMixin {
  double ukuran = 100;
  bool tampil = true;
  bool diperbesar = false;
  bool tampilKartu = true;

  late final AnimationController controller;
  late final Animation<double> animasi;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    animasi = Tween<double>(begin: 0, end: 300).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'AnimatedContainer',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            width: ukuran,
            height: ukuran,
            decoration: BoxDecoration(
              color: diperbesar
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.tertiary,
              borderRadius: BorderRadius.circular(diperbesar ? 80 : 12),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              diperbesar = !diperbesar;
              ukuran = diperbesar ? 180 : 100;
            });
          },
          child: const Text('Ubah Ukuran'),
        ),
        const Divider(height: 32),
        Text(
          'AnimatedSwitcher',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: Icon(
              tampil ? Icons.favorite : Icons.star,
              key: ValueKey(tampil),
              size: 80,
              color: tampil ? Colors.pink : Colors.amber,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              tampil = !tampil;
            });
          },
          child: const Text('Ganti Ikon'),
        ),
        const Divider(height: 32),
        Text(
          'AnimationController',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        AnimatedBuilder(
          animation: animasi,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(animasi.value, 0),
              child: const Icon(
                Icons.flutter_dash,
                size: 48,
                color: Colors.blue,
              ),
            );
          },
        ),
        Wrap(
          spacing: 8,
          children: [
            ElevatedButton(
              onPressed: () => controller.forward(from: 0),
              child: const Text('Mulai'),
            ),
            ElevatedButton(
              onPressed: () => controller.reverse(),
              child: const Text('Balik'),
            ),
            ElevatedButton(
              onPressed: () => controller.stop(),
              child: const Text('Stop'),
            ),
          ],
        ),
        const Divider(height: 32),
        Text('AnimatedOpacity', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        AnimatedOpacity(
          opacity: tampilKartu ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Column(
                  children: [
                    const Icon(Icons.auto_awesome, size: 48),
                    const SizedBox(height: 8),
                    Text(
                      'Kartu Animasi',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Text('Efek fade in dan fade out'),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            setState(() {
              tampilKartu = !tampilKartu;
            });
          },
          child: Text(tampilKartu ? 'Sembunyikan Kartu' : 'Tampilkan Kartu'),
        ),
      ],
    );
  }
}

class ShellPage extends StatefulWidget {
  const ShellPage({super.key});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  int _index = 0;

  static const List<Widget> _halaman = [
    BerandaTab(),
    FavoritTab(),
    AnimasiTab(),
    PengaturanTab(),
  ];

  static const List<String> _judul = [
    'Beranda',
    'Favorit',
    'Animasi',
    'Pengaturan',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_judul[_index])),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: const Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Menu Praktikum 6',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Beranda'),
              selected: _index == 0,
              onTap: () {
                setState(() => _index = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite_border),
              title: const Text('Favorit'),
              selected: _index == 1,
              onTap: () {
                setState(() => _index = 1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.animation),
              title: const Text('Animasi'),
              selected: _index == 2,
              onTap: () {
                setState(() => _index = 2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan'),
              selected: _index == 3,
              onTap: () {
                setState(() => _index = 3);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(index: _index, children: _halaman),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) {
          setState(() => _index = i);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favorit',
          ),
          NavigationDestination(icon: Icon(Icons.animation), label: 'Animasi'),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }
}
