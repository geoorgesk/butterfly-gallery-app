import 'package:flutter/material.dart';
import 'data/butterflies_data.dart';
import 'models/butterfly.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Added const constructor and key

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Modern Butterfly App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal.withOpacity(0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 5,
            shadowColor: Colors.teal.withOpacity(0.5),
          ),
        ),
      ),
      home: const HomePage(), // added const
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Butterfly> _butterflies;
  late List<Butterfly> _filteredButterflies;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _butterflies = getButterflies(); // Load data
    _filteredButterflies = List.from(_butterflies);
    _startStaggeredAnimation();
  }

  void _startStaggeredAnimation() {
    _controller.reset();
    _controller.forward();
  }

  void _filterButterflies(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _filteredButterflies = _butterflies.where((butterfly) {
        return butterfly.details.toLowerCase().contains(_searchQuery) ||
            butterfly.science.toLowerCase().contains(_searchQuery) ||
            butterfly.origin.toLowerCase().contains(_searchQuery) ||
            butterfly.commonName.toLowerCase().contains(_searchQuery) ||
            butterfly.family.toLowerCase().contains(_searchQuery) ||
            butterfly.id.toString().contains(_searchQuery);
      }).toList();
      _startStaggeredAnimation();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Butterfly Gallery'),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.teal.withOpacity(0.1),
              Colors.blueGrey.withOpacity(0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  decoration: const InputDecoration(
                    labelText:
                        'Search by common name, science, origin, family, or details',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Colors.teal),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                  onChanged: _filterButterflies,
                ),
              ),
            ),
            Expanded(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.8,
                        ),
                    itemCount: _filteredButterflies.length,
                    itemBuilder: (context, index) {
                      final butterfly = _filteredButterflies[index];
                      final delayedAnimation =
                          Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                              parent: _controller,
                              curve: Interval(
                                (index /
                                        (_filteredButterflies.isEmpty
                                            ? 1
                                            : _filteredButterflies.length))
                                    .clamp(0.0, 1.0),
                                1.0,
                                curve: Curves.easeInOut,
                              ),
                            ),
                          );

                      return FadeTransition(
                        opacity: delayedAnimation,
                        child: ScaleTransition(
                          scale: delayedAnimation,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, _) =>
                                      DetailsPage(butterfly: butterfly),
                                  transitionsBuilder:
                                      (context, animation, _, child) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: ScaleTransition(
                                            scale: CurvedAnimation(
                                              parent: animation,
                                              curve: Curves.elasticInOut,
                                            ),
                                            child: child,
                                          ),
                                        );
                                      },
                                ),
                              );
                            },
                            onLongPress: () {
                              final detailsPreview =
                                  butterfly.details.length > 50
                                  ? '${butterfly.details.substring(0, 50)}...'
                                  : butterfly.details;
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(butterfly.commonName),
                                  content: Text(
                                    '${butterfly.family}\n${butterfly.origin}\nIndividuals: ${butterfly.numberOfIndividuals}\n\n$detailsPreview',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Close'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Card(
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    20,
                                  ), // ✅ Correct place for border radius
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.teal.withOpacity(0.1),
                                      Colors.blue.withOpacity(0.1),
                                    ],
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Hero(
                                      tag: 'butterfly-${butterfly.id}',
                                      child: Image.asset(
                                        butterfly.imagePath,
                                        height: 120,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                                  height: 120,
                                                  color: Colors.grey[300],
                                                  child: const Center(
                                                    child: Text('Image Error'),
                                                  ),
                                                ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        butterfly.commonName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.teal,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      butterfly.family,
                                      style: const TextStyle(
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                    Text(
                                      'Individuals: ${butterfly.numberOfIndividuals}',
                                      style: const TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  final Butterfly butterfly;
  const DetailsPage({super.key, required this.butterfly});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Butterfly Details'),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.teal.withOpacity(0.1),
              Colors.blueGrey.withOpacity(0.1),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Hero(
                  tag: 'butterfly-${butterfly.id}',
                  child: Image.asset(
                    butterfly.imagePath,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 250,
                      color: Colors.grey[300],
                      child: const Center(child: Text('Image Error')),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  butterfly.commonName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                Text(
                  butterfly.science,
                  style: const TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    color: Colors.teal,
                  ),
                ),
                Text(
                  'Family: ${butterfly.family}',
                  style: const TextStyle(fontSize: 18, color: Colors.blueGrey),
                ),
                Text(
                  'Origin: ${butterfly.origin}',
                  style: const TextStyle(fontSize: 18, color: Colors.blueGrey),
                ),
                Text(
                  'Number of Individuals: ${butterfly.numberOfIndividuals}',
                  style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    butterfly.details,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150, 50),
                    backgroundColor: Colors.teal.withOpacity(0.3),
                  ),
                  child: const Text('Back to Gallery'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
