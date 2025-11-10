import 'package:cleaning_service_app/core/assets-gen/assets.gen.dart';
import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/features/owner/service/controllers/owner_service_controller.dart';
import 'package:cleaning_service_app/features/owner/service/controllers/service_booking_controller.dart';
import 'package:cleaning_service_app/features/owner/service/widgets/service_booking_step_one.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 16.w,
                children: [
                  _buildCircularStep(label: "Step 1", isCompleted: true),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 4.w,
                        children: List.generate(
                          12,
                          (index) => Container(
                            width: 8,
                            height: 2,
                            decoration: BoxDecoration(
                              color: Color(0xFF4899D1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      Text(" "),
                    ],
                  ),

                  _buildCircularStep(label: "Step 2", isCompleted: false),
                ],
              ),

              SizedBox(height: 16),

              CustomText2(
                text: "Enter Your Information",
                color: AppColors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),

              SizedBox(height: 24),

              ServiceBookingStepOne(
                serviceBookingController: serviceBookingController,
              ),

              /// Date And TimeField
              // _buildServiceBookingStepOne(context),
              ElevatedButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.serviceBookSecondScreen);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.appColors,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  minimumSize: Size(
                    MediaQuery.of(context).size.width * 0.9,
                    50,
                  ), // 90% of screen width
                ),
                child: CustomText2(
                  text: 'Confirm',
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircularStep({
    required String label,
    required bool isCompleted,
  }) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          padding: const EdgeInsets.all(11),
          decoration: ShapeDecoration(
            color: isCompleted ? const Color(0xFF4899D1) : Color(0xFFDDE1ED),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: isCompleted
              ? Assets.icons.checkCircle.svg()
              : Assets.icons.circle.svg(),
        ),
        // StepCircle(isActive: true, isCompleted: true),
        CustomText(
          text: label,
          textAlign: TextAlign.center,
          fontWeight: FontWeight.w400,
          fontSize: 12,
          fontFamily: FontFamily.lexend,
          color: isCompleted ? AppColors.black : const Color(0xFFB9C2DB),
        ),
      ],
    );
  }
}
