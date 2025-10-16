// lib/models/butterfly.dart
class Butterfly {
  final int id; // Unique identifier
  final String
  imagePath; // Path to the photo, e.g., 'assets/images/butterfly_1.jpg'
  final String details; // Description or other details
  final String science; //scientific name
  final String origin; // origin name

  Butterfly({
    required this.id,
    required this.imagePath,
    required this.details,
    required this.science,
    required this.origin,
  });
}
