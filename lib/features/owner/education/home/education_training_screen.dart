import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text_2.dart'
    show CustomText2;
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:flutter/material.dart';

class EducationTrainingScreen extends StatelessWidget {
  const EducationTrainingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(leftIcon: true, titleName: "Education & Training"),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Container(
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
            color: AppColors.white_50,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                CustomText2(
                  text:
                      "gravida elit enim. lobortis, ex orci lobortis, Donec orci elit felis, luctus ultrices odio tincidunt cursus elit ex nisi vehicula, Morbi Nunc Morbi venenatis sollicitudin. tortor. dui non quam dui. nibh tortor. sit viverra maximus ipsum",
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                  maxLines: 8,
                  textAlign: TextAlign.start,
                  bottom: 20,
                ),
                CustomText2(
                  text:
                      "gravida elit enim. lobortis, ex orci lobortis, Donec orci elit felis, luctus ultrices odio tincidunt cursus elit ex nisi vehicula, Morbi Nunc Morbi venenatis sollicitudin. tortor. dui non quam dui. nibh tortor. sit viverra maximus ipsum",
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                  maxLines: 8,
                  textAlign: TextAlign.start,
                  bottom: 20,
                ),
                CustomText2(
                  text:
                      "gravida elit enim. lobortis, ex orci lobortis, Donec orci elit felis, luctus ultrices odio tincidunt cursus elit ex nisi vehicula, Morbi Nunc Morbi venenatis sollicitudin. tortor. dui non quam dui. nibh tortor. sit viverra maximus ipsum",
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black,
                  maxLines: 8,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
