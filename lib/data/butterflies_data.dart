// lib/data/butterflies_data.dart
import '../models/butterfly.dart';

List<Butterfly> getButterflies() {
  return [
    Butterfly(
      id: 1,
      imagePath: 'assets/images/butterfly_1.jpg',
      details:
          'This is Butterfly 1: A beautiful Monarch with orange wings and black veins.',
    ),
    Butterfly(
      id: 2,
      imagePath: 'assets/images/butterfly_2.jpg',
      details:
          'This is Butterfly 2: A vibrant Blue Morpho known for its iridescent blue color.',
    ),
    Butterfly(
      id: 3,
      imagePath: 'assets/images/butterfly_3.jpg',
      details:
          'This is Butterfly 3: A common Swallowtail with striking yellow and black patterns.',
    ),
    // Add the remaining butterflies up to 47
    // For example:
    Butterfly(
      id: 4,
      imagePath: 'assets/images/butterfly_4.jpg',
      details:
          'This is Butterfly 4: A delicate Painted Lady with migratory habits.',
    ),
    // ...
    Butterfly(
      id: 47,
      imagePath: 'assets/images/butterfly_47.jpg',
      details:
          'This is Butterfly 47: A rare species with unique patterns and vibrant colors.',
    ),
    // Make sure to add all 47 entries. You can copy-paste and modify as needed.
  ];
}
