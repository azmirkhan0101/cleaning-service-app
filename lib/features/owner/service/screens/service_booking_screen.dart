import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/features/owner/service/controllers/owner_service_controller.dart';
import 'package:cleaning_service_app/features/owner/service/controllers/service_booking_controller.dart';
import 'package:cleaning_service_app/features/owner/service/widgets/booking_steps.dart';
import 'package:cleaning_service_app/features/owner/service/widgets/service_booking_step_one.dart';
import 'package:cleaning_service_app/features/owner/service/widgets/service_booking_step_two.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceBookingScreen extends StatefulWidget {
  const ServiceBookingScreen({super.key});

  @override
  State<ServiceBookingScreen> createState() => _ServiceBookingScreenState();
}

class _ServiceBookingScreenState extends State<ServiceBookingScreen> {
  final ownerController = Get.find<OwnerServiceController>();
  final serviceBookingController = Get.find<ServiceBookingController>();

  DateTime? selected;

  int? selectedHour;
  int? selectedMinute;

  final List<int> hours = List.generate(24, (i) => i); // 0–23
  final List<int> minutes = List.generate(12, (i) => i * 5); // 0, 5, 10…55

  @override
  Widget build(BuildContext context) {
    // Read args: serviceId
    final args = Get.arguments;
    if (args is Map && args['serviceId'] != null) {
      serviceBookingController.setServiceId(args['serviceId'].toString());
    }
    return Scaffold(
      appBar: CustomAppBar(title: "Book Details", backButton: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Obx(() {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BookingSteps(
                  currentStep: serviceBookingController.currentStep.value,
                ),

                SizedBox(height: 16),

                serviceBookingController.currentStep.value == 1
                    ? ServiceBookingStepOne(
                        serviceBookingController: serviceBookingController,
                      )
                    : ServiceBookingStepTwo(),

                /// Date And TimeField
                // _buildServiceBookingStepOne(context),
                // ElevatedButton(
                //   onPressed: () {
                //     // Get.toNamed(AppRoutes.serviceBookSecondScreen);
                //     serviceBookingController.currentStep.value += 1;
                //   },
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: AppColors.appColors,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(24),
                //     ),
                //     padding: const EdgeInsets.symmetric(vertical: 14),
                //     minimumSize: Size(
                //       MediaQuery.of(context).size.width * 0.9,
                //       50,
                //     ), // 90% of screen width
                //   ),
                //   child: CustomText2(
                //     text: 'Confirm',
                //     color: Colors.white,
                //     fontSize: 16,
                //     fontWeight: FontWeight.w600,
                //   ),
                // ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
