// Archivo: lib/screens/posts_screen.dart
import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../services/api_service.dart';
import 'post_detail_screen.dart'; 
import 'users_screen.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});
  @override
  State<PostsScreen> createState() => _PostsScreenState();
}
class _PostsScreenState extends State<PostsScreen> {
  late Future<List<Post>> _futurePosts;
  final ApiService _apiService = ApiService();
  @override
  void initState() {
    super.initState();
    // La llamada a la API se hace UNA sola vez,
    // al crear la pantalla
    _futurePosts = _apiService.fetchPosts();
  }
  // Vuelve a pedir los datos (botón Reintentar)
  void _reintentar() {
    setState(() {
      _futurePosts = _apiService.fetchPosts();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Móvil: Consumo API REST'),
        actions: [
          IconButton( // reto 4
            icon: const Icon(Icons.people),
            tooltip: 'Ver Usuarios',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UsersScreen(), 
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Post>>(
        future: _futurePosts,
        builder: (context, snapshot) {
        // Estado 1: la petición está viajando por la red
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        // Estado 2: error de conexión o fallo del servidor
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _reintentar,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
          );
        }
        // Estado 3: los datos llegaron con éxito
       if (snapshot.hasData) {
        final posts = snapshot.data!;
        return RefreshIndicator( // Reto 2
          onRefresh: () async {
            setState(() {
              _futurePosts = _apiService.fetchPosts();
            });
            await _futurePosts; // Espera a que termine de cargar la nueva data
          },
          child: ListView.builder( 
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return ListTile(
                leading: CircleAvatar(child: Text('${post.id}')),
                title: Text(
                  post.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text( //reto 1 
                  'Usuario ID: ${post.userId}\n${post.body}'),
                onTap: () {  // reto 3
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostDetailScreen(post: post),
                    ),
                  );
                },
              );
            },
          ),
        );
      }
      return const Center(child: Text('No hay datos disponibles.'));
      },
      ),
    );
  }
}