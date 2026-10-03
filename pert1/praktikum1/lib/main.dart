import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Praktikum 1',
      home: const CounterPage(),
      // Scaffold(
      //   appBar: AppBar(title: const Text('Hello Flutter')),
      //   body: Center(
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: const [
      //         Icon(
      //           Icons.flutter_dash,
      //           size: 80,
      //           color: Colors.blue,
      //         ),
      //         SizedBox(height: 16),
      //         Text(
      //           'Halo, nama saya Febrian!',
      //           style: TextStyle(fontSize: 24),
      //         ),
      //         Text('NIM: 20240801068'),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff6200EE),
        title: const Text('Counter Saya'),
      ),
      body: Center(
        child: Text('$_count', style: const TextStyle(fontSize: 48)),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FloatingActionButton(
            onPressed: () => setState(() => _count = 0),
            child: const Icon(Icons.refresh),
          ),
          FloatingActionButton(
            onPressed: () {
              if (_count > 0) {
                setState(() => _count--);
              }
            },
            child: const Icon(Icons.remove),
          ),
          FloatingActionButton(
            onPressed: () => setState(() => _count++),
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
