import 'package:flutter/material.dart';
import 'data/butterflies_data.dart';
import 'models/butterfly.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Modern Butterfly App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor:
            Colors.white, // Removed transparent for no blur
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
  final List<Butterfly> _butterflies = getButterflies();
  List<Butterfly> _filteredButterflies = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
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
        final details = butterfly.details.toLowerCase();
        final science = butterfly.science.toLowerCase();
        final origin = butterfly.origin.toLowerCase();
        final idStr = butterfly.id.toString();
        return details.contains(_searchQuery) ||
            science.contains(_searchQuery) ||
            origin.contains(_searchQuery) ||
            idStr.contains(_searchQuery);
      }).toList();
      if (_filteredButterflies.isNotEmpty) {
        _startStaggeredAnimation();
      }
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
            SizedBox(height: 20), // Added space to lower the search bar
            Padding(
              padding: EdgeInsets.all(16),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(
                    0.8,
                  ), // Subtle background without blur
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Search by science, origin, or details',
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
                    padding: EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: _filteredButterflies.length,
                    itemBuilder: (context, index) {
                      if (index >= _filteredButterflies.length)
                        return SizedBox.shrink();
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
                      final butterfly = _filteredButterflies[index];
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
                                      (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                      ) => DetailsPage(butterfly: butterfly),
                                  transitionsBuilder:
                                      (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                        child,
                                      ) {
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
                                  title: Text(butterfly.science),
                                  content: Text(
                                    '${butterfly.origin}\n$detailsPreview',
                                  ),
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
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              clipBehavior: Clip
                                  .antiAlias, // ensures content respects rounded corners
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    20,
                                  ), // moved here
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.teal.withOpacity(0.1),
                                      Colors.blue.withOpacity(0.1),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
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
                                                  child: Center(
                                                    child: Text('Image Error'),
                                                  ),
                                                ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        butterfly.science,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.teal,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      butterfly.origin,
                                      style: TextStyle(color: Colors.blueGrey),
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

class DetailsPage extends StatefulWidget {
  final Butterfly butterfly;
  DetailsPage({required this.butterfly});

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.down,
      onDismissed: (_) => Navigator.pop(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Butterfly Details'),
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
                    tag: 'butterfly-${widget.butterfly.id}',
                    child: Image.asset(
                      widget.butterfly.imagePath,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 250,
                        color: Colors.grey[300],
                        child: Center(child: Text('Image Error')),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    widget.butterfly.science,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  Text(
                    'Origin: ${widget.butterfly.origin}',
                    style: TextStyle(fontSize: 18, color: Colors.blueGrey),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      widget.butterfly.details,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Back to Gallery'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(150, 50),
                      backgroundColor: Colors.teal.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
