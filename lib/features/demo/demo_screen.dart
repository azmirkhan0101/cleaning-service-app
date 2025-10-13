import 'package:cleaning_service_app/core/assets-gen/assets.gen.dart';
import 'package:flutter/material.dart';

class DemoScreen extends StatelessWidget {
  const DemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: -40,
            bottom: -60,
            child: Image.asset(
              Assets.images.onboardingBg.path,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
