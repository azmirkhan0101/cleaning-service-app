import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/features/main-layout/screens/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewScreen extends StatefulWidget {
  final String paymentUrl;
  final String bookingId;

  const PaymentWebViewScreen({
    super.key,
    required this.paymentUrl,
    required this.bookingId,
  });

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            print("On page started =====>: $url");
            setState(() {
              _isLoading = true;
            });
            debugPrint('Payment page started loading: $url');
          },
          onPageFinished: (String url) {
            print("On page finished =====>: $url");
            setState(() {
              _isLoading = false;
            });
            debugPrint('Payment page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('Payment WebView error: ${error.description}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Error loading payment page: ${error.description}',
                ),
                backgroundColor: Colors.redAccent,
              ),
            );
          },
          onNavigationRequest: (NavigationRequest request) {
            debugPrint('Navigation request ====>: ${request.url}');

            // Check for payment success/failure URLs
            if (request.url.contains('success') ||
                request.url.contains('payment-success')) {
              _handlePaymentSuccess();
              return NavigationDecision.prevent;
            } else if (request.url.contains('cancel') ||
                request.url.contains('payment-cancel')) {
              _handlePaymentCancel();
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  void _handlePaymentSuccess() {
    Get.offAll(MainLayout(isOwner: true));
    // Get.back(); // Close WebView
    // Get.back(); // Close booking screen
    Get.snackbar(
      'Success',
      'Payment completed successfully!',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
    // Navigate to booking details or home
    // Get.offAllNamed('/MainLayout');
  }

  void _handlePaymentCancel() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Payment cancelled'),
        backgroundColor: Colors.orange,
      ),
    );
    Future.microtask(() {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Payment',
        backButton: true,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Cancel Payment?'),
              content: const Text(
                'Are you sure you want to cancel the payment process?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('No, Continue'),
                ),
                TextButton(
                  onPressed: () {
                    // Close dialog first
                    Navigator.pop(context);
                    // Then close the WebView screen without touching GetX snackbar
                    if (mounted) {
                      Navigator.of(this.context).pop();
                    }
                  },
                  child: const Text('Yes, Cancel'),
                ),
              ],
            ),
          );
        },
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
