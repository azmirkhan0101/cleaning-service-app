import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/features/profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
              // Call the completion callback endpoint to sync database
              _completeStripeOnboarding();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  /// Handle Stripe account disconnect
  Future<void> _handleDisconnectStripe() async {
    if (!mounted) return;

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Disconnect Stripe Account'),
        content: const Text(
          'Are you sure you want to disconnect your Stripe account? You will need to reconnect it to receive payments.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Disconnect'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Disconnecting Stripe account...'),
            ],
          ),
        ),
      );

      // Call the disconnect API
      final profileCtrl = Get.find<ProfileController>();
      final success = await profileCtrl.disconnectStripeAccount();

      if (mounted) {
        Navigator.pop(context); // Close loading dialog

        if (success) {
          // Go back to previous screen
          Navigator.pop(context);
        }
      }
    } catch (e) {
      debugPrint('Error disconnecting Stripe account: $e');
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
      }
    }
  }

  /// Handle Stripe onboarding completion
  Future<void> _completeStripeOnboarding() async {
    if (!mounted) return;

    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Completing Stripe setup...'),
            ],
          ),
        ),
      );

      // Call the completion callback API
      final profileCtrl = Get.find<ProfileController>();
      final success = await profileCtrl.completeStripeConnectOnboarding();

      if (mounted) {
        Navigator.pop(context); // Close loading dialog

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            title: const Text('Setup Complete'),
            content: Text(
              success
                  ? 'Your Stripe account setup has been completed successfully.'
                  : 'Setup completed, but encountered an issue syncing your account. Please try again.',
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
    } catch (e) {
      debugPrint('Error completing Stripe onboarding: $e');
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            title: const Text('Error'),
            content: const Text(
              'An error occurred while completing setup. Please try again.',
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
    }
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
              onPressed: _handleDisconnectStripe,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.red,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: const Text(
                  "Disconnect",
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
