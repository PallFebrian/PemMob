
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// MODEL POST
class Post {
  final int id;
  final int userId;
  final String title;
  final String body;

  const Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int,
      userId: json['userId'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }
}

// MODEL KOMENTAR
class Komentar {
  final int id;
  final String name;
  final String email;
  final String body;

  const Komentar({
    required this.id,
    required this.name,
    required this.email,
    required this.body,
  });

  factory Komentar.fromJson(Map<String, dynamic> json) {
    return Komentar(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      body: json['body'] as String,
    );
  }
}

// API POSTINGAN
Future<List<Post>> ambilPostingan() async {
  final uri = Uri.parse(
    'https://jsonplaceholder.typicode.com/posts',
  );

  final response = await http
      .get(uri)
      .timeout(const Duration(seconds: 10));

  if (response.statusCode != 200) {
    throw Exception(
      'Gagal memuat postingan (kode ${response.statusCode})',
    );
  }

  final List<dynamic> data = jsonDecode(response.body);

  return data
      .map((e) => Post.fromJson(e as Map<String, dynamic>))
      .toList();
}

// API KOMENTAR
Future<List<Komentar>> ambilKomentar(int idPost) async {
  final uri = Uri.parse(
    'https://jsonplaceholder.typicode.com/posts/$idPost/comments',
  );

  final response = await http
      .get(uri)
      .timeout(const Duration(seconds: 10));

  if (response.statusCode != 200) {
    throw Exception(
      'Gagal memuat komentar (kode ${response.statusCode})',
    );
  }

  final List<dynamic> data = jsonDecode(response.body);

  return data
      .map((e) => Komentar.fromJson(e as Map<String, dynamic>))
      .toList();
}

void main() {
  runApp(const MyApp());
}

// APLIKASI UTAMA
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daftar Postingan',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const PostinganPage(),
    );
  }
}

// HALAMAN DAFTAR POSTINGAN
class PostinganPage extends StatefulWidget {
  const PostinganPage({super.key});

  @override
  State<PostinganPage> createState() => _PostinganPageState();
}

class _PostinganPageState extends State<PostinganPage> {
  late Future<List<Post>> _future;

  @override
  void initState() {
    super.initState();
    _future = ambilPostingan();
  }

  Future<void> _muatUlang() async {
    final futureBaru = ambilPostingan();

    setState(() {
      _future = futureBaru;
    });

    // Error ditangani oleh FutureBuilder.
    try {
      await futureBaru;
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<List<Post>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(
                'Daftar Postingan (${snapshot.data!.length})',
              );
            }

            return const Text('Daftar Postingan');
          },
        ),
        actions: [
          IconButton(
            tooltip: 'Muat ulang',
            icon: const Icon(Icons.refresh),
            onPressed: _muatUlang,
          ),
        ],
      ),
      body: FutureBuilder<List<Post>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Gagal memuat postingan:\n${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _muatUlang,
                      child: const Text('Coba lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          final posts = snapshot.data!;

          if (posts.isEmpty) {
            return const Center(
              child: Text('Tidak ada postingan'),
            );
          }

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];

              return ListTile(
                title: Text(post.title),
                subtitle: Text(
                  post.body,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailPostinganPage(
                        post: post,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

// HALAMAN DETAIL POSTINGAN
class DetailPostinganPage extends StatefulWidget {
  final Post post;

  const DetailPostinganPage({
    super.key,
    required this.post,
  });

  @override
  State<DetailPostinganPage> createState() =>
      _DetailPostinganPageState();
}

class _DetailPostinganPageState
    extends State<DetailPostinganPage> {
  late Future<List<Komentar>> _futureKomentar;

  @override
  void initState() {
    super.initState();
    _futureKomentar = ambilKomentar(widget.post.id);
  }

  Future<void> _muatUlangKomentar() async {
    final futureBaru = ambilKomentar(widget.post.id);

    setState(() {
      _futureKomentar = futureBaru;
    });

    try {
      await futureBaru;
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Postingan'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            widget.post.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          Text(widget.post.body),
          const Divider(height: 32),
          Text(
            'Komentar',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),

          FutureBuilder<List<Komentar>>(
            future: _futureKomentar,
            builder: (context, snapshot) {
              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gagal memuat komentar:\n${snapshot.error}',
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _muatUlangKomentar,
                      child: const Text('Coba lagi'),
                    ),
                  ],
                );
              }

              final komentar = snapshot.data!;

              if (komentar.isEmpty) {
                return const Text('Belum ada komentar.');
              }

              return Column(
                children: komentar.map((k) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(k.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(k.email),
                        const SizedBox(height: 4),
                        Text(k.body),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
