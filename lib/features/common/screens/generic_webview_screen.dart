import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GenericWebViewScreen extends StatefulWidget {
  const GenericWebViewScreen({
    super.key,
    required this.title,
    required this.url,
    this.isDashboard = false,
  });
  final String title;
  final String url;
  final bool isDashboard;

  @override
  State<GenericWebViewScreen> createState() => _GenericWebViewScreenState();
}

class _GenericWebViewScreenState extends State<GenericWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) => setState(() => _isLoading = false),
          onNavigationRequest: (request) {
            final url = request.url;
            // Detect Stripe Connect completion URL and treat as success
            if (url.contains('stripe-connect/complete')) {
              if (mounted) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Setup Complete'),
                    content: const Text(
                      'Your Stripe account setup has been completed successfully.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              }
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.title,
        backButton: true,
        actions: [
          if (widget.isDashboard)
            TextButton(
              onPressed: () {},
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.red,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: const Text(
                  "Delete Account",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          // IconButton(
          //   icon: const Icon(Icons.delete, color: Colors.red),
          //   onPressed: () {
          //     // Handle dashboard action
          //   },
          // ),
        ],
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
