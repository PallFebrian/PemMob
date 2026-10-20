import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeMode = ValueNotifier<ThemeMode>(ThemeMode.light);
final seedColor = ValueNotifier<Color>(Colors.indigo);

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
  seedColor.value = pilihanWarna[
  warnaIndex >= 0 && warnaIndex < pilihanWarna.length
      ? warnaIndex
      : 0
  ];

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
          routes: {
            '/': (_) => const ShellPage(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/detail') {
              final item = settings.arguments;

              if (item is! Item) {
                return MaterialPageRoute<void>(
                  settings: settings,
                  builder: (_) => const Scaffold(
                    body: Center(
                      child: Text('Data detail tidak valid'),
                    ),
                  ),
                );
              }

              return PageRouteBuilder<void>(
                settings: settings,
                pageBuilder: (context, animation, secondaryAnimation) {
                  return DetailPage(item: item);
                },
                transitionsBuilder: (
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                    ) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
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
                appBar: AppBar(
                  title: const Text('404'),
                ),
                body: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 80,
                        color: Colors.red,
                      ),
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
                themeMode.value =
                value ? ThemeMode.dark : ThemeMode.light;

                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isDarkMode', value);
              },
            ),
            const SizedBox(height: 8),
            Text(
              'Warna tema',
              style: Theme.of(context).textTheme.titleMedium,
            ),
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
                          ? const Icon(
                        Icons.check,
                        color: Colors.white,
                      )
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
  final String nama;
  final IconData ikon;
  final Color warna;

  const Item(this.nama, this.ikon, this.warna);
}

const daftarItem = [
  Item('Flutter', Icons.flutter_dash, Colors.blue),
  Item('Musik', Icons.music_note, Colors.pink),
  Item('Kamera', Icons.camera_alt, Colors.orange),
  Item('Peta', Icons.map, Colors.green),
];

class BerandaTab extends StatelessWidget {
  const BerandaTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/halaman-tidak-ada');
          },
          child: const Text('Tes Halaman 404'),
        ),
        const SizedBox(height: 12),
        for (final item in daftarItem)
          ListTile(
            leading: Hero(
              tag: 'ikon-${item.nama}',
              child: CircleAvatar(
                backgroundColor: item.warna,
                child: Icon(
                  item.ikon,
                  color: Colors.white,
                ),
              ),
            ),
            title: Text(item.nama),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/detail',
                arguments: item,
              );
            },
          ),
      ],
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Hero(
              tag: 'ikon-${item.nama}',
              child: CircleAvatar(
                radius: 64,
                backgroundColor: item.warna,
                child: Icon(
                  item.ikon,
                  size: 64,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              item.nama,
              style: tema.textTheme.headlineMedium,
            ),
            Text(
              'Detail untuk ${item.nama}',
              style: tema.textTheme.bodyMedium,
            ),
          ],
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

    animasi = Tween<double>(
      begin: 0,
      end: 300,
    ).animate(controller);
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
              borderRadius: BorderRadius.circular(
                diperbesar ? 80 : 12,
              ),
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
        Text(
          'AnimatedOpacity',
          style: Theme.of(context).textTheme.titleMedium,
        ),
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
                    const Icon(
                      Icons.auto_awesome,
                      size: 48,
                    ),
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
          child: Text(
            tampilKartu
                ? 'Sembunyikan Kartu'
                : 'Tampilkan Kartu',
          ),
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
    AnimasiTab(),
    PengaturanTab(),
  ];

  static const List<String> _judul = [
    'Beranda',
    'Animasi',
    'Pengaturan',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_judul[_index]),
      ),
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
              leading: const Icon(Icons.animation),
              title: const Text('Animasi'),
              selected: _index == 1,
              onTap: () {
                setState(() => _index = 1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan'),
              selected: _index == 2,
              onTap: () {
                setState(() => _index = 2);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _index,
        children: _halaman,
      ),
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
            icon: Icon(Icons.animation),
            label: 'Animasi',
          ),
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