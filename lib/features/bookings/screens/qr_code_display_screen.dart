import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/features/bookings/controllers/booking_qr_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QrCodeDisplayScreen extends StatefulWidget {
  const QrCodeDisplayScreen({super.key});

  @override
  State<QrCodeDisplayScreen> createState() => _QrCodeDisplayScreenState();
}

class _QrCodeDisplayScreenState extends State<QrCodeDisplayScreen> {
  final BookingQrController controller = Get.put(BookingQrController());

  @override
  void initState() {
    super.initState();
    _initFromArgs();
  }

  void _initFromArgs() {
    final args = Get.arguments;
    String? id;
    if (args is List && args.isNotEmpty) {
      final first = args.first;
      if (first is Map && first['bookingId'] != null) {
        id = first['bookingId'].toString();
      } else if (args.first is String) {
        id = args.first as String;
      }
    } else if (args is Map && args['bookingId'] != null) {
      id = args['bookingId'].toString();
    } else if (args is String) {
      id = args;
    }

    if (id != null && id.isNotEmpty) {
      controller.setBookingId(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "QR Code", backButton: true),

      body: Obx(() {
        // Initial/explicit loading state
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () async => controller.generateQrCode(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final bytes = controller.qrImageBytes;
              final hasError = controller.errorMessage.value.isNotEmpty;

              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: hasError
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 48,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  controller.errorMessage.value,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Pull down to refresh',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            )
                          : (bytes != null)
                          ? Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Image.memory(
                                bytes,
                                width: 240,
                                height: 240,
                                fit: BoxFit.contain,
                              ),
                            )
                          : const Text(
                              'QR code not available\nPull down to refresh',
                              textAlign: TextAlign.center,
                            ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
