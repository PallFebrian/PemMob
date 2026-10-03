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
      home: Scaffold(
        appBar: AppBar(backgroundColor: Colors.pinkAccent,title: const Text('Perkenalan', style: TextStyle(color: Colors.white),)),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.account_circle,
                size: 100,
                color: Colors.pinkAccent,
              ),
              SizedBox(height: 16),
              Text(
                'Halo, nama saya Febrian!',
                style: TextStyle(fontSize: 24),
              ),
              Text(
                'NIM saya 20240801068!',
                style: TextStyle(fontSize: 24),
              ),
              Text(
                'Teknik Informatika!',
                style: TextStyle(fontSize: 24),
              ),
              Text(
                'Hobi Ngoding',
                style: TextStyle(fontSize: 24),
              ),
            ],
          )
        ),
      ),
    );
  }
}
