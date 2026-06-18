import 'package:cleaning_service_app/core/assets-gen/assets.gen.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/utils/ToastMsg/toast.dart';
import 'package:cleaning_service_app/features/payment/screens/payment_webview_screen.dart';
import 'package:cleaning_service_app/features/provider/subscription/controller/subscription_controller.dart';
import 'package:cleaning_service_app/features/provider/subscription/widgets/subscription_plan_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubscriptionPaymentScreen extends StatefulWidget {
  const SubscriptionPaymentScreen({
    super.key,
    required this.redeemPoint,
    this.isUpdatingSubscription = false,
  });

  final int redeemPoint;
  final bool isUpdatingSubscription;

  @override
  State<SubscriptionPaymentScreen> createState() =>
      _SubscriptionPaymentScreenState();
}

class _SubscriptionPaymentScreenState extends State<SubscriptionPaymentScreen> {
  final controller = Get.find<SubscriptionController>();
  final _creditsController = TextEditingController(text: '0');
  final String _paymentMethodId = 'visa_card';

  @override
  void initState() {
    super.initState();
    _createOrRefreshCheckout();
  }

  @override
  void dispose() {
    _creditsController.dispose();
    super.dispose();
  }

  Future<void> _createOrRefreshCheckout() async {
    final plan = controller.selectedPlan.value?.plan;
    if (plan == null) return;
    final timeline = controller.isYearlyPlan.value ? 'YEARLY' : 'MONTHLY';
    // final credits = int.tryParse(_creditsController.text.trim()) ?? 0;
    await controller.createCheckout(
      plan: plan,
      paymentMethodId: _paymentMethodId,
      timeline: timeline,
      redeemPoint: widget.redeemPoint,
    );
    if (!mounted) return;
    if (controller.checkoutError.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Toast.errorToast(controller.checkoutError.value);
      });
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Redeem Point in Payment Screen: ${widget.redeemPoint}');
    final plan = controller.selectedPlan.value!;
    return Scaffold(
      appBar: CustomAppBar(title: 'Payment', backButton: true),
      body: Obx(() {
        final data = controller.checkoutData.value;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SubscriptionPlanCard(
                plan: plan,
                isSelected: true,
                isYearly: controller.isYearlyPlan.value,
                isCheckIconVisible: false,
              ),

              const SizedBox(height: 24),

              CustomText(
                text: 'Payment Method',
                color: const Color(0xFF0F0B18),
                fontSize: 18,
                fontFamily: 'Lexend',
                fontWeight: FontWeight.w600,
                height: 1.50,
              ),
              const SizedBox(height: 8),
              Assets.icons.stripe.svg(width: 100, height: 40),

              const SizedBox(height: 16),

              // Credits input
              if (widget.isUpdatingSubscription)
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _creditsController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Invitation credits to use',
                          hintText: '0',
                          filled: true,
                          fillColor: Color(0xFFE9EBF3),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                        onSubmitted: (_) => _createOrRefreshCheckout(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    FilledButton(
                      onPressed: controller.isCreatingCheckout.value
                          ? null
                          : _createOrRefreshCheckout,
                      child: const Text('Apply'),
                    ),
                  ],
                ),

              const SizedBox(height: 16),

              // Voucher-style summary
              _VoucherSummary(
                data: data,
                isLoading: controller.isCreatingCheckout.value,
              ),

              const SizedBox(height: 24),
            ],
          ),
        );
      }),
      bottomNavigationBar: Obx(() {
        final data = controller.checkoutData.value;
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: FilledButton(
              onPressed: (data == null)
                  ? null
                  : () {
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (_) => PaymentWebViewScreen(
                      //       paymentUrl: data.url,
                      //       bookingId: data.sessionId,
                      //     ),
                      //   ),
                      // );
                      Get.to(
                        () => PaymentWebViewScreen(
                          paymentUrl: data.url,
                          bookingId: data.sessionId,
                          isUpdatingSubscription: widget.isUpdatingSubscription,
                        ),
                      );
                    },
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                backgroundColor: const Color(0xFFF7A51D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const CustomText(
                text: "Pay",
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Lexend',
                fontWeight: FontWeight.w600,
                height: 1.50,
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _VoucherSummary extends StatelessWidget {
  const _VoucherSummary({required this.data, required this.isLoading});
  final dynamic data; // SubscriptionCheckoutData?
  final bool isLoading;

  String _fmtNum(num? n) =>
      n == null ? '-' : '€${n.toStringAsFixed(n % 1 == 0 ? 0 : 2)}';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFB9C2DB), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Checkout Summary',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  _row('Timeline', data?.timeline ?? '-'),
                  _row('Monthly Price', _fmtNum(data?.monthlyPrice)),
                  const Divider(height: 24),
                  _row('Original Amount', _fmtNum(data?.originalAmount)),
                  _row('Yearly Discount', '-${_fmtNum(data?.yearlyDiscount)}'),
                  _row(
                    'Credits Discount',
                    '-${_fmtNum(data?.creditsDiscountApplied)}',
                  ),
                  _row('Total Discount', '-${_fmtNum(data?.totalDiscount)}'),
                  const Divider(height: 24),
                  _row(
                    'Final Amount',
                    _fmtNum(data?.finalAmount),
                    emphasize: true,
                  ),
                  const SizedBox(height: 8),
                  _row('Credits Used', '${data?.creditsUsed ?? 0}'),
                  _row('Duration', '${data?.durationDays ?? 0} days'),
                  if ((data?.savings ?? '').toString().isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      data!.savings,
                      style: const TextStyle(
                        color: Color(0xFF1B2D51),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
      ),
    );
  }

  Widget _row(String label, String value, {bool emphasize = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF4F4F59))),
          Text(
            value,
            style: TextStyle(
              fontWeight: emphasize ? FontWeight.w700 : FontWeight.w500,
              color: const Color(0xFF0F0B18),
            ),
          ),
        ],
      ),
    );
  }
}
