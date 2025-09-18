import 'package:cleaning_service_app/core/components/custom_image/custom_image.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/utils/app_icons/app_icons.dart';
import 'package:cleaning_service_app/core/utils/app_images/app_images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceDetails extends StatefulWidget {
  const ServiceDetails({super.key});

  @override
  State<ServiceDetails> createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
  @override
  Widget build(BuildContext context) {

    final List<Map<String, String>> services = [
      {

        'image':"https://busybeecleaningcompany.com/wp-content/uploads/2023/01/shutterstock_1934018414-1-1-800x534-1.jpeg", // You can replace with actual image asset or network URL
      },
      {

        'image': "https://busybeecleaningcompany.com/wp-content/uploads/2023/01/shutterstock_1934018414-1-1-800x534-1.jpeg", // Replace with actual image asset or network URL
      },

      {

        'image': "https://greenhorizon.ae/assets/general-cleaning.jpg", // You can replace with actual image asset or network URL
      },
      {

        'image': "https://www.helpling.com.sg/wp-content/uploads/2023/06/general-cleaning-vs-specialised-cleaning-cover-image.jpg" // Replace with actual image asset or network URL
      },
    ];
    return Scaffold(
       appBar: CustomAppbar(titleName: "Cleaning",),
       body: Padding(
         padding: const EdgeInsets.all(8.0),
         child: SingleChildScrollView(
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [

                Center(child: CustomImage(imageSrc: AppImages.banner_im4,height: 140,fit: BoxFit.fill,)),

               // Service info (name, price, rating)
               Padding(
                 padding: const EdgeInsets.all(16.0),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text(
                           'Cleaning Service',
                           style: TextStyle(
                             fontSize: 24,
                             fontWeight: FontWeight.bold,
                           ),
                         ),
                         SizedBox(height: 8),
                         Text(
                           '€25/hr',
                           style: TextStyle(
                             fontSize: 18,
                             color: Colors.green,
                           ),
                         ),
                       ],
                     ),
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.end,
                       children: [
                         Text(
                           '4.8',
                           style: TextStyle(
                             fontSize: 16,
                             fontWeight: FontWeight.bold,
                           ),
                         ),
                         Icon(
                           Icons.star,
                           color: Colors.yellow,
                           size: 20,
                         ),
                       ],
                     ),
                   ],
                 ),
               ),

               Text(
                 'Description',
                 style: TextStyle(
                   fontSize: 18,
                   fontWeight: FontWeight.bold,
                 ),
               ),

               // Description
               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
                 child: Text(
                   'Our professional cleaning service is designed to keep your home and office spotless, hygienic, and fresh. From floor to ceiling, we handle dusting, mopping, bathroom cleaning, kitchen deep cleaning, and more. Flexible scheduling and trusted cleaners ensure you get the service you need at the time that suits you best.',
                   style: TextStyle(fontSize: 14),
                   textAlign: TextAlign.justify,
                 ),
               ),

               GridView.builder(
                 shrinkWrap: true,
                 physics: NeverScrollableScrollPhysics(),
                 padding: EdgeInsets.all(8),
                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                   crossAxisCount: 2, // Number of columns
                   crossAxisSpacing: 8.0, // Space between columns
                   mainAxisSpacing: 8.0, // Space between rows
                   childAspectRatio: 0.95, // Aspect ratio of each item
                 ),
                 itemCount: services.length,
                 itemBuilder: (context, index) {
                   final service = services[index];
                   return Card(
                     elevation: 5,
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(10),
                     ),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         // Service Image
                         ClipRRect(
                           borderRadius: BorderRadius.circular(10),
                           child: Image.network(
                             service['image']!,
                             height: 120,
                             width: double.infinity,
                             fit: BoxFit.cover,
                           ),
                         ),

                       ],
                     ),
                   );
                 },
               )
             ],
           ),
         ),
       ),
    );
  }
}
