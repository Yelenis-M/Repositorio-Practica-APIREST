// Archivo: lib/services/api_service.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/post_model.dart';
import '../models/user_model.dart';

class ApiService {
  final String _baseUrl = 'https://jsonplaceholder.typicode.com';
  // Método asíncrono que consume el endpoint /posts
  Future<List<Post>> fetchPosts() async {
    
    final url = Uri.parse('$_baseUrl/posts');
    try {
      // Petición HTTP GET con tiempo límite para redes lentas
      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
      );
      if (response.statusCode == 200) {
        // 1. Decodificamos el texto JSON a una lista de Maps
        final List<dynamic> jsonList = jsonDecode(response.body);
        // 2. Convertimos cada Map en un objeto Post
         return jsonList.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception(
          'El servidor respondió con un error. '
          'Estado: ${response.statusCode}',
        );
      }
    } on TimeoutException {
      throw Exception('La conexión tardó demasiado. Intenta de nuevo.');
    } on SocketException {
      throw Exception('Sin conexión a internet. Revisa tu señal.');
    }
  }
  // Método asíncrono que consume el endpoint /users
  Future<List<User>> fetchUsers() async {
    final url = Uri.parse('$_baseUrl/users');
    try {
      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
      );
      if (response.statusCode == 200) {
        // 1. Decodificamos el texto JSON a una lista de Maps
        final List<dynamic> jsonList = jsonDecode(response.body);
        // 2. Convertimos cada Map en un objeto User
        return jsonList.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception(
          'El servidor respondió con un error al cargar usuarios. '
          'Estado: ${response.statusCode}',
        );
      }
    } on TimeoutException {
      throw Exception('La conexión tardó demasiado. Intenta de nuevo.');
    } on SocketException {
      throw Exception('Sin conexión a internet. Revisa tu señal.');
    }
  }
}