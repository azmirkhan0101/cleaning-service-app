import 'dart:convert';
import 'dart:typed_data';

import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:cleaning_service_app/features/common/types/http_method.dart';
import 'package:get/get.dart';

class BookingQrController extends GetxController {
  // NetworkHelper accessed via Get.find to follow project-wide pattern

  final RxString bookingId = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString qrCodeBase64 = ''.obs; // extracted base64 portion
  final RxString qrMessage = ''.obs;
  final RxString completionCode = ''.obs;

  void setBookingId(String id) {
    bookingId.value = id;
    generateQrCode();
  }

  Future<void> generateQrCode() async {
    if (bookingId.value.isEmpty) {
      errorMessage.value = 'Booking ID missing';
      return;
    }
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await Get.find<NetworkHelper>()
          .request<Map<String, dynamic>>(
            HttpMethod.post.method,
            ApiUrl.generateBookingQr(bookingId.value),
            withAuth: true,
            parser: (data) => data as Map<String, dynamic>,
          );

      result.fold(
        (err) {
          errorMessage.value = err.message ?? 'Failed to generate QR code';
        },
        (data) {
          try {
            final payload = data['data'] as Map<String, dynamic>?;
            if (payload == null) {
              errorMessage.value = 'Invalid QR response';
              return;
            }
            final rawUrl = payload['qrCodeUrl'] as String? ?? '';
            // Expecting data:image/png;base64,<base64>
            final parts = rawUrl.split(',');
            if (parts.length == 2) {
              qrCodeBase64.value = parts[1];
            } else {
              // Fallback attempt: remove prefix manually
              qrCodeBase64.value = rawUrl.replaceFirst(
                'data:image/png;base64,',
                '',
              );
            }
            qrMessage.value = payload['message'] as String? ?? '';
            completionCode.value = payload['completionCode'] as String? ?? '';
          } catch (e) {
            errorMessage.value = 'Parse error: $e';
          }
        },
      );
    } catch (e) {
      errorMessage.value = 'Unexpected error generating QR';
    } finally {
      isLoading.value = false;
    }
  }

  Uint8List? get qrImageBytes {
    if (qrCodeBase64.isEmpty) return null;
    try {
      return base64Decode(qrCodeBase64.value);
    } catch (_) {
      return null;
    }
  }
}
