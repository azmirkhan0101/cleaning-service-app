import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ServiceCardScreen(),
    );
  }
}

class ServiceCardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cleaning Service"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Service info (name, price, rating)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cleaning Service',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '€25/hr',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '4.8',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Our professional cleaning service is designed to keep your home and office spotless, hygienic, and fresh. From floor to ceiling, we handle dusting, mopping, bathroom cleaning, kitchen deep cleaning, and more. Flexible scheduling and trusted cleaners ensure you get the service you need at the time that suits you best.',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.justify,
                ),
              ),

              // Photos
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  height: 200,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Image.asset('assets/photo1.jpg', width: 150, fit: BoxFit.cover),
                      SizedBox(width: 8),
                      Image.asset('assets/photo2.jpg', width: 150, fit: BoxFit.cover),
                      SizedBox(width: 8),
                      Image.asset('assets/photo3.jpg', width: 150, fit: BoxFit.cover),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
