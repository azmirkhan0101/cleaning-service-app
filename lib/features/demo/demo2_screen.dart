import 'package:flutter/material.dart';

class Demo2Screen extends StatelessWidget {
  const Demo2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Demo 2 Screen')),
      body: SafeArea(
        child: Column(
          children: [
            // demo hero section
            _buildHeroSection(),

            // demo content section
            _buildContentSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      height: 200,
      width: double.infinity,
      color: Colors.blueAccent,
      child: const Center(
        child: Text(
          'Demo Hero Section',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildContentSection() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            Text(
              'This is a demo content section. You can add more widgets here to showcase features of your app.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 12),
            Text(
              'Feel free to customize this screen as per your requirements.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
