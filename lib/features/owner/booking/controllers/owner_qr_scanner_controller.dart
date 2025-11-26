import 'dart:async';
import 'dart:convert';

import 'package:cleaning_service_app/core/service/api_url.dart';
import 'package:cleaning_service_app/core/service/network_helper.dart';
import 'package:cleaning_service_app/features/bookings/controllers/owner_booking_controller.dart';
import 'package:cleaning_service_app/features/common/types/http_method.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';

class OwnerQrScannerController extends GetxController {
  final isScanning = false.obs;
  final isCompleting = false.obs;
  final isSubmittingReview = false.obs;
  final errorMessage = ''.obs;
  final scannedCompletionCode = ''.obs;
  final bookingId = ''.obs;

  Timer? _debounce;

  void setBookingId(String id) => bookingId.value = id;

  /// Debounced handler to avoid multiple triggers from scanner
  void onCodeDetected(String code) {
    if (code.isEmpty || isCompleting.value) return;
    // Debounce rapid events
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () {
      final extracted = _extractCompletionCode(code);
      if (extracted == null || extracted.isEmpty) {
        errorMessage.value = 'Invalid QR content';
        return;
      }
      scannedCompletionCode.value = extracted;
      _completeByQr();
    });
  }

  /// Try to extract the actual completion code from common QR payload shapes
  /// Supports: raw code, URL query (?completionCode=...), JSON {completionCode: ..},
  /// or key-value text like "completionCode: ABC123".
  String? _extractCompletionCode(String raw) {
    final s = raw.trim();
    if (s.isEmpty) return null;

    // Direct code (no separators typical of URL/JSON)
    final looksSimple =
        !s.contains('{') &&
        !s.contains('}') &&
        !s.contains('=') &&
        !s.contains(':') &&
        !s.contains('/') &&
        !s.contains('\n');
    if (looksSimple) return s;

    // URL with query param
    try {
      final uri = Uri.tryParse(s);
      if (uri != null && (uri.hasQuery || s.startsWith('http'))) {
        final qp = uri.queryParameters;
        final code = qp['completionCode'] ?? qp['code'] ?? qp['c'];
        if (code != null && code.isNotEmpty) return code;
      }
    } catch (_) {}

    // JSON object
    try {
      final obj = jsonDecode(s);
      if (obj is Map) {
        final code = obj['completionCode'] ?? obj['code'];
        if (code is String && code.isNotEmpty) return code;
      }
    } catch (_) {}

    // Key-value text pattern
    final reg = RegExp(r'(completionCode|code)\s*[:=]\s*([A-Za-z0-9\-_.]+)');
    final m = reg.firstMatch(s);
    if (m != null) return m.group(2);

    return null;
  }

  Future<void> _completeByQr() async {
    if (bookingId.value.isEmpty || scannedCompletionCode.value.isEmpty) {
      errorMessage.value = 'Missing booking or completion code';
      return;
    }
    isCompleting.value = true;
    errorMessage.value = '';

    final res = await Get.find<NetworkHelper>().request<Map<String, dynamic>>(
      HttpRequestType.patch.method,
      ApiUrl.completeBookingByQr(bookingId.value),
      withAuth: true,
      body: {'completionCode': scannedCompletionCode.value},
      parser: (data) => data as Map<String, dynamic>,
    );

    isCompleting.value = false;

    res.fold(
      (l) {
        errorMessage.value = l.message ?? 'Failed to complete booking';
      },
      (r) async {
        // success; caller can show dialog
      },
    );
  }

  Future<Either<String, Unit>> submitRatingReview({
    required double rating,
    required String review,
  }) async {
    if (bookingId.value.isEmpty) {
      return left('Missing booking');
    }
    isSubmittingReview.value = true;
    final res = await Get.find<NetworkHelper>().request<Map<String, dynamic>>(
      HttpRequestType.post.method,
      ApiUrl.bookingRatingReview(bookingId.value),
      withAuth: true,
      body: {'rating': rating, 'review': review},
      parser: (data) => data as Map<String, dynamic>,
    );
    isSubmittingReview.value = false;

    return res.fold(
      (l) => left(l.message ?? 'Failed to submit review'),
      (r) => right(unit),
    );
  }

  Future<void> refreshAndGoCompletedTab() async {
    if (Get.isRegistered<BookingController>()) {
      final bookingController = Get.find<BookingController>();
      await bookingController.refreshAllBookings();
      bookingController.filterServices(3); // Completed tab
    }
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }
}
