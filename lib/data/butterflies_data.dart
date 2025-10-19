// lib/data/butterflies_data.dart
import '../models/butterfly.dart';

List<Butterfly> getButterflies() {
  return [
    Butterfly(
      id: 1,
      commonName: "Monarch Butterfly", // New: Common name
      science: "Danaus plexippus", // Scientific name
      origin: "North America", // Origin
      imagePath: 'assets/images/butterfly_1.jpg',
      details:
          'This is Butterfly 1: A beautiful Monarch with orange wings and black veins.',
      family: "Nymphalidae", // New: Family
      numberOfIndividuals: 1000000, // New: Estimated population
    ),
    Butterfly(
      id: 2,
      commonName: "Blue Morpho", // New: Common name
      science: "Morpho helenor", // Scientific name
      origin: "Central and South America", // Origin
      imagePath: 'assets/images/butterfly_2.jpg',
      details:
          'This is Butterfly 2: A vibrant Blue Morpho known for its iridescent blue color.',
      family: "Nymphalidae", // New: Family
      numberOfIndividuals: 500000, // New: Estimated population
    ),
    Butterfly(
      id: 3,
      commonName: "Swallowtail", // New: Common name
      science: "Papilio machaon", // Scientific name
      origin: "Europe and Asia", // Origin
      imagePath: 'assets/images/butterfly_3.jpg',
      details:
          'This is Butterfly 3: A common Swallowtail with striking yellow and black patterns.',
      family: "Papilionidae", // New: Family
      numberOfIndividuals: 2000000, // New: Estimated population
    ),
    Butterfly(
      id: 4,
      commonName: "Painted Lady", // New: Common name
      science: "Vanessa cardui", // Scientific name
      origin: "Worldwide", // Origin
      imagePath: 'assets/images/butterfly_4.jpg',
      details:
          'This is Butterfly 4: A delicate Painted Lady with migratory habits.',
      family: "Nymphalidae", // New: Family
      numberOfIndividuals: 5000000, // New: Estimated population
    ),
    Butterfly(
      id: 5,
      commonName:
          "Postman Butterfly", // New: Common name (example for Heliconius melpomene)
      science: "Heliconius melpomene", // Scientific name
      origin: "South America", // Origin
      imagePath: 'assets/images/butterfly_5.jpg',
      details:
          'This is Butterfly 5: A colorful species with red and black wings.',
      family: "Nymphalidae", // New: Family
      numberOfIndividuals: 100000, // New: Estimated population
    ),
    Butterfly(
      id: 6,
      commonName: "Eastern Tiger Swallowtail", // New: Common name
      science: "Papilio glaucus", // Scientific name
      origin: "North America", // Origin
      imagePath: 'assets/images/butterfly_6.jpg',
      details:
          'This is Butterfly 6: A large butterfly with yellow and black markings.',
      family: "Papilionidae", // New: Family
      numberOfIndividuals: 1500000, // New: Estimated population
    ),
    // Add the remaining butterflies (IDs 7-45) here with the same structure
    // Example for ID 7:
    Butterfly(
      id: 7,
      commonName: "Common Buckeye", // Replace with actual common name
      science: "Junonia coenia", // Replace with actual scientific name
      origin: "North America", // Replace with actual origin
      imagePath: 'assets/images/butterfly_7.jpg',
      details:
          'This is Butterfly 7: Description here.', // Replace with actual details
      family: "Nymphalidae", // Replace with actual family
      numberOfIndividuals: 200000, // Replace with actual estimated population
    ),
    // Continue for IDs 8-45...
    // For ID 46:
    Butterfly(
      id: 46,
      commonName: "Buckeye Butterfly", // New: Common name
      science: "Junonia coenia", // Scientific name
      origin: "North America", // Origin
      imagePath: 'assets/images/butterfly_46.jpg',
      details:
          'This is Butterfly 46: A butterfly with eye-like spots for protection.',
      family: "Nymphalidae", // New: Family
      numberOfIndividuals: 500000, // New: Estimated population
    ),
    Butterfly(
      id: 47,
      commonName: "Luna Moth", // New: Common name
      science: "Actias luna", // Scientific name
      origin: "North America", // Origin
      imagePath: 'assets/images/butterfly_47.jpg',
      details:
          'This is Butterfly 47: A rare species with unique patterns and vibrant colors.',
      family: "Saturniidae", // New: Family
      numberOfIndividuals: 10000, // New: Estimated population
    ),
    // Ensure all 47 entries are added. Copy-paste the structure and fill in real data.
  ];
}
