import 'package:flutter/material.dart';
import 'data/butterflies_data.dart'; // Import your data source
import 'models/butterfly.dart'; // Import the model
import 'package:flutter/services.dart'; // For clipboard sharing
import 'dart:async'; // For delays in animations

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interactive Butterfly App',
      theme: ThemeData(
        primarySwatch: Colors.teal, // Updated to a more vibrant color
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor:
            Colors.lightGreen[50], // Subtle background for interest
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Butterfly> _butterflies = getButterflies(); // Fetch butterflies
  List<Butterfly> _filteredButterflies = []; // For search
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _filteredButterflies = _butterflies; // Initialize with full list
    _startStaggeredAnimation(); // Start grid animation on load
  }

  void _startStaggeredAnimation() {
    _controller.forward();
  }

  void _filterButterflies(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _filteredButterflies = _butterflies.where((butterfly) {
        return butterfly.details.toLowerCase().contains(query.toLowerCase()) ||
            butterfly.id.toString().contains(query);
      }).toList();
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
        title: Text('Butterfly Gallery'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Already handled in the body, but you can add more here if needed
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search by ID or details',
                border: OutlineBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: _filterButterflies, // Real-time search
            ),
          ),
          Expanded(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return GridView.builder(
                  padding: EdgeInsets.all(16.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: _filteredButterflies.length,
                  itemBuilder: (context, index) {
                    final delayedAnimation = Tween<double>(begin: 0.0, end: 1.0)
                        .animate(
                          CurvedAnimation(
                            parent: _controller,
                            curve: Interval(
                              (index / _filteredButterflies.length).clamp(
                                0.0,
                                1.0,
                              ),
                              1.0,
                              curve: Curves.easeOut,
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
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        DetailsPage(
                                          butterfly:
                                              _filteredButterflies[index],
                                        ),
                                transitionsBuilder:
                                    (
                                      context,
                                      animation,
                                      secondaryAnimation,
                                      child,
                                    ) {
                                      return ScaleTransition(
                                        scale: CurvedAnimation(
                                          parent: animation,
                                          curve: Curves.fastOutSlowIn,
                                        ),
                                        child: child,
                                      );
                                    },
                              ),
                            );
                          },
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Quick Preview'),
                                content: Text(
                                  _filteredButterflies[index].details.substring(
                                        0,
                                        50,
                                      ) +
                                      '...',
                                ), // Snippet of details
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Close'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Hero(
                                  tag:
                                      'butterfly-${_filteredButterflies[index].id}',
                                  child: Image.asset(
                                    _filteredButterflies[index].imagePath,
                                    height: 120,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 120,
                                        color: Colors.grey[300],
                                        child: Center(
                                          child: Text('Image Error'),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Tap for details',
                                    style: TextStyle(
                                      color: Colors.teal,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
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
    );
  }
}

class DetailsPage extends StatelessWidget {
  final Butterfly butterfly;

  DetailsPage({required this.butterfly});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Butterfly Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () async {
              await Share.share(
                'Check out this butterfly: ${butterfly.details}',
              ); // Simple share
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          // For better scrolling if details are long
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'butterfly-${butterfly.id}',
                child: GestureDetector(
                  onDoubleTap: () {
                    // Add zoom effect or alert for fun
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Zooming in on ${butterfly.id}!')),
                    );
                  },
                  child: Image.asset(
                    butterfly.imagePath,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 250,
                        color: Colors.grey[300],
                        child: Center(child: Text('Image Error')),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  butterfly.details,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.teal[800]),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Back to Gallery'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal, // Themed button
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
