import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Butterfly App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

// Model for Butterfly
class Butterfly {
  final int
  id; // You can add more properties like String imagePath, String details, etc.

  Butterfly({required this.id});
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Generate a list of 47 butterflies
    final List<Butterfly> butterflies = List.generate(
      47,
      (index) => Butterfly(id: index + 1),
    );

    return Scaffold(
      appBar: AppBar(title: Text('Butterfly Gallery')),
      body: GridView.builder(
        padding: EdgeInsets.all(16.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 columns for a grid layout
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.0, // Square items
        ),
        itemCount: butterflies.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              // Navigate to DetailsPage with fade and Hero animation
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      DetailsPage(butterfly: butterflies[index]),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
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
                  // Hero widget for animated transition of the "image"
                  Hero(
                    tag:
                        'butterfly-${butterflies[index].id}', // Unique tag for each butterfly
                    child: Container(
                      height: 120, // Placeholder height for the image
                      decoration: BoxDecoration(
                        color: Colors.grey[300], // Placeholder background
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(10),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Butterfly ${butterflies[index].id}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Tap for details',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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
      appBar: AppBar(title: Text('Butterfly Details')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hero widget to continue the animation from HomePage
            Hero(
              tag: 'butterfly-${butterfly.id}', // Same tag as in HomePage
              child: Container(
                height: 250, // Larger size for details page
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300], // Placeholder background
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'Butterfly ${butterfly.id}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Details for Butterfly ${butterfly.id} will go here.', // Replace with actual details
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Go back to HomePage
              },
              child: Text('Back to Gallery'),
            ),
          ],
        ),
      ),
    );
  }
}
