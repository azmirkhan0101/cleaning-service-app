
import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_button/custom_button.dart';
import 'package:cleaning_service_app/core/components/custom_image/custom_image.dart' show CustomImage;
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/features/auth/auth_controller.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_strings/app_strings.dart';
import 'package:cleaning_service_app/core/utils/ToastMsg/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pin_code_fields/pin_code_fields.dart';


 class SingupOtpScreen extends StatefulWidget {
   const SingupOtpScreen({super.key});

   @override
   State<SingupOtpScreen> createState() => _SingupOtpScreenState();
 }

 class _SingupOtpScreenState extends State<SingupOtpScreen> {

   String? email;

   final authController = Get.put(AuthController());


   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: CustomAppbar(leftIcon: true,),
       body: Padding(
           padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
           child: SingleChildScrollView(
             child: SizedBox(
               height: MediaQuery.of(context).size.height/1.1,
               child: Obx(
                  () {
                   authController.newTextEditingController.value;
                   return Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     mainAxisAlignment: MainAxisAlignment.start,
                     children: [

                       CustomText(text: 'Verify Account',fontSize: 24,fontWeight: FontWeight.w600,),

                       SizedBox(height: 8,),

                       CustomText(
                         text: 'Welcome back',
                         fontSize: 12,fontWeight: FontWeight.w600,
                       ),

                       Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [

                           CustomText(
                             top: 40.h,
                             text: AppStrings.enterCode,
                             fontSize: 32,
                             fontWeight: FontWeight.w600,
                             bottom: 20.h,
                           ),
                           CustomText(
                             text: AppStrings.enterTheCodeTitle,
                             fontSize: 15,
                             fontWeight: FontWeight.w400,
                             maxLines: 2,
                             bottom: 30.h,
                             color: AppColors.black,
                             textAlign: TextAlign.start,
                           ),

                           ///CustomPinCode(controller: authController.otpController.value),

                           Padding(
                             padding: EdgeInsets.only(left: 4, right: 4),
                             child: PinCodeTextField(
                               textStyle: TextStyle(color: Colors.white),
                               keyboardType: TextInputType.number,
                               appContext: context,
                               length: 6,
                               enableActiveFill: true,
                               animationType: AnimationType.fade,
                               animationDuration: Duration(milliseconds: 300),
                               controller:TextEditingController(),
                               pinTheme: PinTheme(
                                 shape: PinCodeFieldShape.box,
                                 borderRadius: BorderRadius.circular(16),
                                 fieldHeight: 50,
                                 fieldWidth: 45.0,
                                 inactiveColor: AppColors.grey_1,
                                 activeColor: AppColors.grey_1,
                                 activeFillColor: AppColors.grey_1,
                                 inactiveFillColor: AppColors.white,
                                 selectedFillColor: AppColors.grey_1,
                                 disabledColor: AppColors.grey_1,
                                 selectedColor: AppColors.grey_1,
                               ),
                             ),
                           ),

                           SizedBox(height: 20.h),

                           Row(
                             crossAxisAlignment: CrossAxisAlignment.center,
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [

                               CustomText(
                                 text: AppStrings.ididntFind,
                                 fontSize: 14,
                                 fontWeight: FontWeight.w400,
                                 color: AppColors.black_04,
                                 right: 10,
                               ),

                              // authController.otpResetLoading.value? Center(child: CircularProgressIndicator(color: AppColors.brinkPink,)):
                               GestureDetector(
                                 onTap: (){
                                  /// authController.otpResetValidation(email.toString());
                                 },
                                 child: CustomText(
                                   text: AppStrings.sendAgain,
                                   fontSize: 16,
                                   fontWeight: FontWeight.w600,
                                   color: AppColors.lightBlue,
                                 ),
                               ),
                             ],
                           ),
                         ],
                       ),

                       SizedBox(height: 16.h),


                       ///============ verificationEmail Button ============

                       CustomButton(
                         onTap: () {

                           Get.offNamed(AppRoutes.selectionScreen);
                         },
                         title: AppStrings.sendCode,
                         height: 50.h,
                         fontSize: 14.sp,
                         fillColor: AppColors.appColors,
                         borderRadius: 24,
                       ),
                     ],
                   );
                 }
               ),
             ),
           )
       ),
     );
   }
 }
