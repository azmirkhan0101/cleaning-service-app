import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/utils/ToastMsg/toast.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/features/main-layout/controllers/main_layout_controller.dart';
import 'package:cleaning_service_app/features/main-layout/screens/main_layout.dart';
import 'package:cleaning_service_app/features/owner/booking/controllers/owner_qr_scanner_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class OwnerScannerScreen extends StatefulWidget {
  const OwnerScannerScreen({super.key});

  @override
  State<OwnerScannerScreen> createState() => _OwnerScannerScreenState();
}

class _OwnerScannerScreenState extends State<OwnerScannerScreen>
    with SingleTickerProviderStateMixin {
  final controller = Get.put(OwnerQrScannerController());
  final ratingController = TextEditingController();
  double ratingValue = 5.0;
  late AnimationController _animController;
  late Animation<double> _scanAnimation;

  @override
  void initState() {
    super.initState();
    // Expect bookingId via args
    final args = Get.arguments;
    if (args is Map && args['bookingId'] != null) {
      controller.setBookingId(args['bookingId'].toString());
    }
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: false);
    _scanAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.linear));
    // Lock orientation if needed
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void dispose() {
    _animController.dispose();
    ratingController.dispose();
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  void _showRatingDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return Obx(
          () => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Completed',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                IconButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 4),
                const Text(
                  'Give your Rating',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                RatingBar.builder(
                  initialRating: ratingValue,
                  minRating: 1,
                  allowHalfRating: true,
                  itemSize: 32,
                  itemBuilder: (context, _) =>
                      const Icon(Icons.star, color: Colors.orangeAccent),
                  onRatingUpdate: (val) => ratingValue = val,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: ratingController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Write a review (optional)',
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: controller.isSubmittingReview.value
                            ? null
                            : () async {
                                Navigator.of(ctx).pop();
                                await _finishFlow(submitReview: false);
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade300,
                          foregroundColor: Colors.black87,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text('Skip'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: controller.isSubmittingReview.value
                            ? null
                            : () async {
                                controller.isSubmittingReview.value = true;
                                final res = await controller.submitRatingReview(
                                  rating: ratingValue,
                                  review: ratingController.text.trim(),
                                );
                                controller.isSubmittingReview.value = false;
                                res.fold(
                                  (l) {
                                    Toast.errorToast("Failed to submit review");
                                    // Get.snackbar(
                                    //   'Error',
                                    //   l,
                                    //   snackPosition: SnackPosition.BOTTOM,
                                    //   backgroundColor: Colors.red,
                                    //   colorText: Colors.white,
                                    // );
                                  },
                                  (r) async {
                                    Navigator.of(ctx).pop();
                                    await _finishFlow(submitReview: true);
                                  },
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.appColors,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: controller.isSubmittingReview.value
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _finishFlow({required bool submitReview}) async {
    // Refresh bookings and navigate to main layout -> Bookings tab -> Completed sub-tab
    await controller.refreshAndGoCompletedTab();

    // Navigate back to close scanner screen first
    Get.back();

    // Navigate to main layout with index=2 (Bookings). Then set internal tab
    if (Get.isRegistered<MainLayoutController>()) {
      final layout = Get.find<MainLayoutController>();
      layout.changeTab(2); // Bookings bottom nav

      // Show snackbar after navigation completes
      await Future.delayed(const Duration(milliseconds: 100));
      Toast.successToast(
        submitReview ? 'Thanks for your feedback!' : 'You skipped review.',
      );
      Get.offAll(MainLayout());
      // Get.snackbar(
      //   'Booking Completed',
      //   submitReview ? 'Thanks for your feedback!' : 'You skipped review.',
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.green,
      //   colorText: Colors.white,
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scanBoxSize = MediaQuery.of(context).size.width * 0.75;
    return Scaffold(
      appBar: CustomAppBar(title: "Scan Provider QR", backButton: true),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Camera Scanner
          MobileScanner(
            fit: BoxFit.cover,
            controller: MobileScannerController(
              facing: CameraFacing.back,
              formats: const [BarcodeFormat.qrCode],
              detectionSpeed: DetectionSpeed.noDuplicates,
            ),
            onDetect: (capture) {
              final codes = capture.barcodes;
              if (codes.isNotEmpty) {
                final raw = codes.first.rawValue ?? '';
                controller.onCodeDetected(raw);
              }
            },
          ),
          // Dark overlay with cutout
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // constraints available if needed later
                return Stack(
                  children: [
                    Container(color: Colors.black54),
                    Center(
                      child: Container(
                        width: scanBoxSize,
                        height: scanBoxSize,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white.withOpacity(0.9),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // Animated scan bar
                              AnimatedBuilder(
                                animation: _scanAnimation,
                                builder: (context, child) {
                                  return Align(
                                    alignment: Alignment(
                                      0,
                                      _scanAnimation.value * 2 - 1,
                                    ),
                                    child: Container(
                                      height: 4,
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            AppColors.appColors.withOpacity(
                                              0.0,
                                            ),
                                            AppColors.appColors,
                                            AppColors.appColors.withOpacity(
                                              0.0,
                                            ),
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Instructions & status
                    Positioned(
                      bottom: 40,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          Obx(
                            () => controller.errorMessage.isNotEmpty
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      controller.errorMessage.value,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Align the provider\'s QR within the frame',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Obx(
                            () => controller.isCompleting.value
                                ? const Text(
                                    'Completing booking...',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  )
                                : const Text(
                                    'Scanning...',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          // Trigger rating dialog after successful completion
          Obx(() {
            if (!controller.isCompleting.value &&
                controller.scannedCompletionCode.isNotEmpty &&
                controller.errorMessage.isEmpty) {
              // Show dialog once
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  controller.scannedCompletionCode.value = '';
                  _showRatingDialog();
                }
              });
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
