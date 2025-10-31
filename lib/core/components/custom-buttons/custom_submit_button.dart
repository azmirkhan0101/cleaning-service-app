import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSubmitButton extends StatelessWidget {
  const CustomSubmitButton({
    super.key,
    required this.title,
    this.loadingTitle,
    this.isLoading,
    this.fillColor = AppColors.appColors,
    this.textColor,
    this.borderRadius,
    this.onPressed,
  });
  final String title;
  final String? loadingTitle;
  final bool? isLoading;
  final Color? fillColor;
  final Color? textColor;
  final double? borderRadius;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: isLoading != true ? onPressed : null,
      style: FilledButton.styleFrom(
        backgroundColor: isLoading == true
            ? fillColor?.withValues(alpha: 0.5)
            : fillColor,
        minimumSize: Size(double.infinity, 50.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 24.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 16.w,
        children: [
          if (isLoading ?? false)
            CircularProgressIndicator(color: AppColors.white, strokeWidth: 2),
          CustomText(
            text: isLoading != null ? loadingTitle ?? title : title,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: textColor ?? AppColors.white,
          ),
        ],
      ),
    );
  }
}
