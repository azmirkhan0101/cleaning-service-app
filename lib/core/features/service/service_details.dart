import 'package:cached_network_image/cached_network_image.dart';
import 'package:cleaning_service_app/core/components/app_routes/app_routes.dart';
import 'package:cleaning_service_app/core/components/custom_button/custom_button.dart';
import 'package:cleaning_service_app/core/components/custom_image/custom_image.dart';
import 'package:cleaning_service_app/core/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/utils/app_colors/app_colors.dart';
import 'package:cleaning_service_app/core/utils/app_images/app_images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceDetails extends StatefulWidget {
  const ServiceDetails({super.key});

  @override
  State<ServiceDetails> createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
  static const _tileAspect = 140 / 90; // 2.125
  static const _radius = 10.0;

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> services = [
      {
        'image':
        'https://busybeecleaningcompany.com/wp-content/uploads/2023/01/shutterstock_1934018414-1-1-800x534-1.jpeg',
      },
      {
        'image':
        'https://busybeecleaningcompany.com/wp-content/uploads/2023/01/shutterstock_1934018414-1-1-800x534-1.jpeg',
      },
      {
        'image': 'https://greenhorizon.ae/assets/general-cleaning.jpg',
      },
      {
        'image':
        'https://www.helpling.com.sg/wp-content/uploads/2023/06/general-cleaning-vs-specialised-cleaning-cover-image.jpg',
      },
    ];

    return Scaffold(
    //  appBar: const CustomAppbar(titleName: 'Cleaning',leftIcon: true,rightIcon: Icon(Ic),),

      appBar: AppBar(
        title: const CustomText(text: "Cleaning",fontSize: 24,
          fontWeight: FontWeight.w500,
          color:AppColors.black,
        ),
        // Left icon (usually a menu or back button)
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded,color: AppColors.black,),
          onPressed: () {
            // Handle left icon press
            Get.back();
          },
        ),
        // Right icons
        actions: [

          IconButton(
            icon: const Icon(Icons.menu,color: AppColors.black,),
            onPressed: () {
              // Handle notifications
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(300.0, 130.0, 0.0, 0.0),
                color: Colors.white,
                items: [

                  PopupMenuItem<String>(
                    value: 'Edit',
                    child: CustomText(
                        text: "Edit",
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                    onTap: () {
                      Get.toNamed(AppRoutes.editServiceScreen);
                    },
                  ),

                  PopupMenuItem<String>(
                    value: 'Delete',
                    child: CustomText(
                      text: "Delete",
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          backgroundColor: Colors.white,
                          insetPadding: EdgeInsets.all(8),
                          contentPadding: EdgeInsets.all(8),
                          title: SizedBox(),
                          content: SizedBox(
                            width: MediaQuery.sizeOf(context).width,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [

                                  Icon(Icons.delete_forever_outlined,size: 90,color: AppColors.red,),

                                //  CustomImage(imageSrc: AppImages.alertImage),

                                  CustomText(text: "Delete this Service",
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                    color:AppColors.black,
                                  ),

                                  SizedBox(
                                    height: 8,
                                  ),

                                  CustomText(text: "Are you sure you want to delete this service ?",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color:AppColors.grey_2,
                                  ),

                                  SizedBox(
                                    height: 8,
                                  ),

                                  CustomButton(
                                      onTap: () {
                                        Navigator.of(context).pop();

                                      },
                                      title: "Yes",
                                      height: 45,
                                      fontSize: 12,
                                      fillColor: AppColors.brinkPink),

                                  SizedBox(
                                    height: 12,
                                  ),

                                  CustomButton(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    title: "NO",
                                    height: 45,
                                    fontSize: 12,
                                    fillColor: AppColors.white,
                                    textColor: AppColors.brinkPink,
                                    isBorder: true,
                                    borderWidth: 1,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                ],
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner
              Center(
                child: CustomImage(
                  imageSrc: AppImages.banner_im4,
                  height: 140,
                  fit: BoxFit.cover, // avoid distortion
                ),
              ),

              // Service info (name, price, rating)
              const Padding(
                padding: EdgeInsets.all(16.0),
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

              const Text(
                'Description',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Our professional cleaning service is designed to keep your home and office spotless, hygienic, and fresh. From floor to ceiling, we handle dusting, mopping, bathroom cleaning, kitchen deep cleaning, and more. Flexible scheduling and trusted cleaners ensure you get the service you need at the time that suits you best.',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.justify,
                maxLines: 5,
              ),


              const SizedBox(height: 16),


              const Text(
                'Photos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              // Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: _tileAspect, // <- 170/80
                ),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final imageUrl = services[index]['image'] ?? '';
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(_radius),
                    ),
                    clipBehavior: Clip.antiAlias, // clip rounded corners
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover, // fill without stretching
                      width: double.infinity,
                      height: double.infinity, // let grid size it
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImageSkeleton extends StatelessWidget {
  const _ImageSkeleton();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(color: Color(0xFFEFEFEF)),
      child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }
}

class _ImageError extends StatelessWidget {
  const _ImageError();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(color: Color(0xFFF5F5F5)),
      child: Center(child: Icon(Icons.broken_image_outlined)),
    );
  }
}
