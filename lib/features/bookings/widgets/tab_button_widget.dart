// import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
// import 'package:cleaning_service_app/features/bookings/controllers/owner_booking_controller.dart';
// import 'package:cleaning_service_app/features/bookings/widgets/owner_my_booking_card.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';

// class TabButtonWidget extends StatelessWidget {
//   const TabButtonWidget({super.key, required this.index, required this.title});

//   final int index;
//   final String title;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         ownerBookingController.filterServices(index);
//       },
//       child: Container(
//         width: 100.w,
//         padding: const EdgeInsets.symmetric(vertical: 6),
//         decoration: BoxDecoration(
//           border: Border(
//             bottom: BorderSide(
//               color: ownerBookingController.selectedTabIndex.value == index
//                   ? Color(0xFF4899D1)
//                   : Color(0xFFB9C2DB),
//               width: 3.0,
//             ),
//           ),
//         ),
//         child: Center(
//           child: CustomText(
//             text: title,
//             fontSize: 16,
//             fontWeight: FontWeight.w500,
//             color: ownerBookingController.selectedTabIndex.value == index
//                 ? Color(0xFF4899D1)
//                 : Color(0xFFB9C2DB),
//           ),
//         ),
//       ),
//     );
//   }
// }
