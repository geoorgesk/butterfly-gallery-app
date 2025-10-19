// lib/models/butterfly.dart
class Butterfly {
  final int id;
  final String commonName;
  final String science;
  final String origin;
  final String imagePath;
  final String details;
  final String family;
  final int numberOfIndividuals;

  Butterfly({
    required this.id,
    required this.commonName,
    required this.science,
    required this.origin,
    required this.imagePath,
    required this.details,
    required this.family,
    required this.numberOfIndividuals,
  });

  factory Butterfly.fromJson(Map<String, dynamic> json) {
    return Butterfly(
      id: json['id'],
      commonName: json['commonName'],
      science: json['science'],
      origin: json['origin'],
      imagePath: json['imagePath'],
      details: json['details'],
      family: json['family'],
      numberOfIndividuals: json['numberOfIndividuals'],
    );
  }
}
