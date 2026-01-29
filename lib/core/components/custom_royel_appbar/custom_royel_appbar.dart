// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:flutter/material.dart';

import '../custom_text/custom_text_2.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool? backButton;
  final double fontSize;
  final List<Widget>? actions;
  final Function()? onPressed;

  const CustomAppBar({
    super.key,
    this.title,
    this.backButton = false,
    this.fontSize = 22,
    this.actions,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 50,
      elevation: 0,
      forceMaterialTransparency: true,
      //foregroundColor: Colors.transparent,
      centerTitle: true,
      scrolledUnderElevation: 0,
      actions: actions,
      //backgroundColor: Colors.transparent,
      leading: backButton == true
          ? BackButton(color: AppColors.black, onPressed: onPressed)
          : null,
      title: CustomText2(
        text: title ?? "",
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        color: AppColors.black,
      ),
    );
  }

  @override
  // TO DO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(50);
}
