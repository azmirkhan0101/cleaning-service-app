import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Figma to Flutter Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two cards per row
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 1, // To maintain square shape of cards
          ),
          itemCount: 4, // Number of items
          itemBuilder: (context, index) {
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () {
                  // Action on tap
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outline, // Placeholder icon, replace with actual
                      size: 40,
                    ),
                    SizedBox(height: 10),
                    Text(
                      _getCardTitle(index),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      _getCardDescription(index),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        // View button action
                      },
                      child: Text('View'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String _getCardTitle(int index) {
    switch (index) {
      case 0:
        return 'Education & Training';
      case 1:
        return 'Legal & Regulatory Updates';
      case 2:
        return 'Industry Trends';
      case 3:
        return 'Bribk Opportunities';
      default:
        return '';
    }
  }

  String _getCardDescription(int index) {
    switch (index) {
      case 0:
        return 'Practical guides on Property management and operation';
      case 1:
        return 'New laws short-changes, and compliance requirements';
      case 2:
        return 'Insights into real estate and custodiate factions';
      case 3:
        return 'New features-reals and programme from Bribk';
      default:
        return '';
    }
  }
}
