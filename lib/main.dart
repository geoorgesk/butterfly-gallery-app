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
  List<Butterfly> _butterflies = [];
  List<Butterfly> _filteredButterflies = [];
  String _searchQuery = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _loadButterflies();
  }

  Future<void> _loadButterflies() async {
    final butterflies = await getButterflies();
    setState(() {
      _butterflies = butterflies;
      _filteredButterflies = List.from(_butterflies);
      _isLoading = false;
      _startStaggeredAnimation();
    });
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

  double _staggerStartForIndex(int index, int total) {
    // return a start time for staggered animation in [0.0, 0.9]
    if (total <= 1) return 0.0;
    final maxStart = 0.9;
    return (index / total) * maxStart;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
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
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.all(16),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  decoration: InputDecoration(
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
                    padding: EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: _filteredButterflies.length,
                    itemBuilder: (context, index) {
                      final butterfly = _filteredButterflies[index];

                      // compute a safe interval start for this tile
                      final start = _staggerStartForIndex(
                        index,
                        _filteredButterflies.length,
                      );
                      final delayedAnimation =
                          Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                              parent: _controller,
                              curve: Interval(
                                start.clamp(0.0, 1.0),
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
                                  title: Text(butterfly.commonName),
                                  content: Text(
                                    '${butterfly.family}\n${butterfly.origin}\nIndividuals: ${butterfly.numberOfIndividuals}\n$detailsPreview',
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
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
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
                                                  child: Center(
                                                    child: Text('Image Error'),
                                                  ),
                                                ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        butterfly.commonName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.teal,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      butterfly.family,
                                      style: TextStyle(color: Colors.blueGrey),
                                    ),
                                    Text(
                                      'Individuals: ${butterfly.numberOfIndividuals}',
                                      style: TextStyle(
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
                    widget.butterfly.commonName,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  Text(
                    widget.butterfly.science,
                    style: TextStyle(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      color: Colors.teal,
                    ),
                  ),
                  Text(
                    'Family: ${widget.butterfly.family}',
                    style: TextStyle(fontSize: 18, color: Colors.blueGrey),
                  ),
                  Text(
                    'Origin: ${widget.butterfly.origin}',
                    style: TextStyle(fontSize: 18, color: Colors.blueGrey),
                  ),
                  Text(
                    'Number of Individuals: ${widget.butterfly.numberOfIndividuals}',
                    style: TextStyle(fontSize: 16, color: Colors.blueGrey),
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
