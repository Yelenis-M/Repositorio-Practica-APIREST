// Archivo: lib/models/post_model.dart
class Post {
  final int userId;
  final int id;
  final String title;
  final String body;
  Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });
  // Constructor factory: crea un Post a partir del Map
  // que resulta de decodificar el JSON
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'] as int? ?? 0, // Si es nulo, asigna 0 por defecto
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }
}