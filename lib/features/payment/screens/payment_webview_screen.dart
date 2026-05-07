import 'package:cleaning_service_app/core/assets-gen/assets.gen.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/utils/ToastMsg/toast.dart';
import 'package:cleaning_service_app/features/main-layout/screens/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewScreen extends StatefulWidget {
  final String paymentUrl;
  final String bookingId;
  final bool isUpdatingSubscription;

  const PaymentWebViewScreen({
    super.key,
    required this.paymentUrl,
    required this.bookingId,
    required this.isUpdatingSubscription,
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
            Toast.errorToast('Error loading payment page: ${error.description}');
            
          },
          onNavigationRequest: (NavigationRequest request) {
            debugPrint('Navigation request ====>: ${request.url}');
            // Detect Stripe/checkout success URLs
            if (request.url.contains('activate-from-checkout')) {
              _handlePaymentSuccess();
              return NavigationDecision.prevent;
            } else if (request.url.contains('success') ||
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
          onUrlChange: (UrlChange urlChange){
            print("PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP: ${urlChange.url}");
          }
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  void _handlePaymentSuccess() async {
    if (!mounted) return;
    await showDialog(
      context: context,
      barrierDismissible: false,
      // builder: (context) => AlertDialog(
      //   title: const Text('Payment Successful'),
      //   content: const Text('Your payment was completed successfully!'),
      //   actions: [
      //     TextButton(
      //       onPressed: () => Navigator.of(context).pop(),
      //       child: const Text('OK'),
      //     ),
      //   ],
      // ),
      builder: (context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.white,
              border: Border.all(color: Colors.orange, width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Assets.icons.checkCircle.svg(
                  width: 60,
                  height: 60,
                  colorFilter: const ColorFilter.mode(
                    Colors.orange,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Payment Successful',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12.0),
                const Text(
                  'Your payment was completed successfully!',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 12.0,
                    ),
                    child: Text(
                      'OK',
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => MainLayout(isOwner: true)),
        (route) => false,
      );
    }
  }

  void _handlePaymentCancel() async {
    if (!mounted) return;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Payment Failed'),
        content: const Text('Payment was cancelled or failed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    if (mounted) {
      Navigator.of(context).pop();
    }
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
