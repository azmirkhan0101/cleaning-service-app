import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WithdrawSuccessDialog extends StatelessWidget {
  const WithdrawSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFF4899D1), width: 1.6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success icon
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: const Color(0xFF4899D1).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                size: 50,
                color: Color(0xFF4899D1),
              ),
            ),

            const SizedBox(height: 8),

            // Success title
            const Text(
              'Success!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF0F0B18),
                fontSize: 32,
                fontFamily: 'Lexend',
                fontWeight: FontWeight.w600,
                height: 1.3,
                letterSpacing: -1,
              ),
            ),

            const SizedBox(height: 8),

            // Success message
            const Text(
              'Your withdrawal processed successfully.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF4F4F59),
                fontSize: 16,
                fontFamily: 'Lexend',
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 16),

            // Ok button
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () {
                  Get.back(); // Close dialog
                  Get.back(
                    result: true,
                  ); // Close redeem screen with success result
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF7A51D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 100,
                    vertical: 10,
                  ),
                ),
                child: const Text(
                  'Ok',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
