import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IconWhiteCircleBackground extends StatelessWidget {
  const IconWhiteCircleBackground({super.key, required this.icon, this.onTap});
  final Widget icon;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.sp),
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: icon,
      ),
    );
  }
}
