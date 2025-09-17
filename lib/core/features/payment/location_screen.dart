import 'package:cleaning_service_app/core/components/custom_from_card/custom_from_card.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_strings/app_strings.dart';
import 'package:flutter/material.dart';


class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(titleName: "",leftIcon: true,),

      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            CustomText(text: "Set Your Location",fontWeight: FontWeight.w600,
              fontSize: 24,
            ),

            SizedBox(
              height: 8,
            ),

            CustomText(text: "Choose your location directly from the map to get the best service experience. This helps us connect you with nearby providers and ensures faster, more reliable service right at your doorstep.",
              fontWeight: FontWeight.w400,
              fontSize: 12,
              maxLines: 4,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(
              height: 32,
            ),

            /// address Field
            CustomFormCard(
                title: "Enter your address",
                hintText: "your address",
                hasBackgroundColor: true,
                controller: TextEditingController()
            ),

            SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () {
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.white_50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50), // pill shape
                  side: const BorderSide(color: Colors.lightBlue, width: 1), // border
                ),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                elevation: 0, // flat style, remove shadow

                minimumSize: Size(MediaQuery.of(context).size.width * 0.9, 50),  // 90% of screen width
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                //  Icon(Icons.sendr),

                  CustomText(
                    text: 'Use my current location',
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
