import 'package:flutter/material.dart';

class DesignScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0), // A light gray background
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0),
        child: Column(
          children: [
            // Owner Card
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Owner',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'As a Owner, you can easily book trusted services in just a few taps. Browse available providers, compare options, and schedule at your convenience. The app ensures a seamless experience, from booking to payment, so you can get the service you need without any hassle',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF555555),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0), // Spacing between cards

            // Service Provider Card
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: const Color(0xFF1E88E5), // The blue border
                  width: 2.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Service Provider',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'As a Service provider, you get a powerful platform to showcase your skills and connect with new clients. Manage your availability, accept bookings, and grow your business with ease. Our app gives you the tools to build trust, increase visibility, and succeed in your profession.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF555555),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}