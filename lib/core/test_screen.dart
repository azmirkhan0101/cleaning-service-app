import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Discount Banner"),
        ),
        body: Center(
          child: DiscountBanner(),
        ),
      ),
    );
  }
}

class DiscountBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "30% Off",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Special Deals",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blue.shade800,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Get discount for every Cleaning order",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue.shade600,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              // Define the action when the button is pressed
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue),
              padding: MaterialStateProperty.all(
                EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            child: Text(
              "Order Now",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
