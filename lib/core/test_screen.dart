import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const FilePickerDemo(),
    );
  }
}

class FilePickerDemo extends StatelessWidget {
  const FilePickerDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 300,
          height: 120,
          decoration: BoxDecoration(
            color: const Color(0xF0F2F7FF), // light background
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              // Handle file selection logic here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Select file tapped")),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.image_outlined,
                  size: 32,
                  color: Colors.black54,
                ),
                const SizedBox(height: 8),
                Text(
                  "Select file",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
