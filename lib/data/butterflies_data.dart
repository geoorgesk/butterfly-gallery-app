// lib/data/butterflies_data.dart
import '../models/butterfly.dart';

List<Butterfly> getButterflies() {
  return [
    Butterfly(
      id: 1,
      science: "Danaus plexippus", // Scientific name for Monarch Butterfly
      origin: "North America", // Origin
      imagePath: 'assets/images/butterfly_1.jpg',
      details:
          'This is Butterfly 1: A beautiful Monarch with orange wings and black veins.',
    ),
    Butterfly(
      id: 2,
      science: "Morpho helenor", // Scientific name for Blue Morpho
      origin: "Central and South America", // Origin
      imagePath: 'assets/images/butterfly_2.jpg',
      details:
          'This is Butterfly 2: A vibrant Blue Morpho known for its iridescent blue color.',
    ),
    Butterfly(
      id: 3,
      science: "Papilio machaon", // Scientific name for Swallowtail
      origin: "Europe and Asia", // Origin
      imagePath: 'assets/images/butterfly_3.jpg',
      details:
          'This is Butterfly 3: A common Swallowtail with striking yellow and black patterns.',
    ),
    // Continue adding for the rest
    Butterfly(
      id: 4,
      science: "Vanessa cardui", // Scientific name for Painted Lady
      origin: "Worldwide", // Origin
      imagePath: 'assets/images/butterfly_4.jpg',
      details:
          'This is Butterfly 4: A delicate Painted Lady with migratory habits.',
    ),
    Butterfly(
      id: 5,
      science: "Heliconius melpomene", // Example for another species
      origin: "South America", // Origin
      imagePath: 'assets/images/butterfly_5.jpg',
      details:
          'This is Butterfly 5: A colorful species with red and black wings.',
    ),
    // Add more entries up to 47...
    // For example:
    Butterfly(
      id: 6,
      science: "Papilio glaucus", // Scientific name
      origin: "North America", // Origin
      imagePath: 'assets/images/butterfly_6.jpg',
      details:
          'This is Butterfly 6: A large butterfly with yellow and black markings.',
    ),
    // ...
    Butterfly(
      id: 46,
      science: "Junonia coenia", // Scientific name for Buckeye Butterfly
      origin: "North America", // Origin
      imagePath: 'assets/images/butterfly_46.jpg',
      details:
          'This is Butterfly 46: A butterfly with eye-like spots for protection.',
    ),
    Butterfly(
      id: 47,
      science: "Actias luna", // Scientific name for Luna Moth (as an example)
      origin: "North America", // Origin
      imagePath: 'assets/images/butterfly_47.jpg',
      details:
          'This is Butterfly 47: A rare species with unique patterns and vibrant colors.',
    ),
    // Make sure to add all 47 entries with accurate data.
  ];
}
