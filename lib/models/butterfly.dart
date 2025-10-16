// lib/models/butterfly.dart
class Butterfly {
  final int id; // Unique identifier
  final String
  imagePath; // Path to the photo, e.g., 'assets/images/butterfly_1.jpg'
  final String details; // Description or other details

  Butterfly({required this.id, required this.imagePath, required this.details});
}
