import 'package:cleaning_service_app/core/assets-gen/assets.gen.dart';
import 'package:get/get.dart';

class OwnerBookingController extends GetxController {
  RxInt selectedTabIndex = 0.obs;
  List<Map<String, dynamic>> filteredServices = [];
  final List<String> tabTitles = [
    "All",
    "Pending",
    "Ongoing",
    "Completed",
    "Cancelled",
  ];

  void filterServices(int index) {
    selectedTabIndex.value = index;

    if (selectedTabIndex.value == 0) {
      filteredServices = services;
    } else {
      filteredServices = services
          .where(
            (service) => service["status"] == tabTitles[selectedTabIndex.value],
          )
          .toList();
    }
    update();
    // refresh();
  }

  final List<Map<String, dynamic>> services = [
    {
      "id": 1,
      "category": "Cleaning Service",
      "serviceDetails":
          "Need deep cleaning for 2 bedrooms and 1 bathroom. Also, please bring cleaning supplies.",
      "imageUrl": Assets.images.cleanImage.path,
      "location": "Dhaka, Bangladesh",
      "phone": "+8801909037016",
      "status": "Pending",
      "price": 25.00,
      "duration": 2,
    },
    {
      "id": 2,
      "category": "Cleaning Service",
      "serviceDetails":
          "Kitchen and living room deep clean required. Please focus on floor and window cleaning.",
      "imageUrl": Assets.images.cleanImage.path,
      "location": "Chittagong, Bangladesh",
      "phone": "+8801909037016",
      "status": "Completed",
      "price": 30.00,
      "duration": 3,
    },
    {
      "id": 3,
      "category": "Laundry Service",
      "serviceDetails":
          "Wash and iron 10 shirts and 5 pairs of trousers. Need delivery within 24 hours.",
      "imageUrl": Assets.images.cleanImage.path,
      "location": "Sylhet, Bangladesh",
      "phone": "+8801909037016",
      "status": "Ongoing",
      "price": 15.00,
      "duration": 1,
    },
    {
      "id": 4,
      "category": "Laundry Service",
      "serviceDetails":
          "Need dry cleaning for 3 suits and 2 sarees. Handle with care.",
      "imageUrl": Assets.images.cleanImage.path,
      "location": "Rajshahi, Bangladesh",
      "phone": "+8801909037016",
      "status": "Pending",
      "price": 20.00,
      "duration": 2,
    },
    {
      "id": 5,
      "category": "Handyman Service",
      "serviceDetails":
          "Need help fixing a broken door handle and assembling a new chair.",
      "imageUrl": Assets.images.cleanImage.path,
      "location": "Dhaka, Bangladesh",
      "phone": "+8801909037016",
      "status": "Pending",
      "price": 18.00,
      "duration": 1.5,
    },
    {
      "id": 6,
      "category": "Handyman Service",
      "serviceDetails":
          "Install new curtain rods in living room and bedroom. Bring tools.",
      "imageUrl": Assets.images.cleanImage.path,
      "location": "Khulna, Bangladesh",
      "phone": "+8801909037016",
      "status": "Cancelled",
      "price": 22.00,
      "duration": 2,
    },
    {
      "id": 7,
      "category": "Electrical Service",
      "serviceDetails":
          "Fix faulty ceiling fan and replace one broken light switch.",
      "imageUrl": Assets.images.cleanImage.path,
      "location": "Dhaka, Bangladesh",
      "phone": "+8801909037016",
      "status": "Ongoing",
      "price": 35.00,
      "duration": 2,
    },
    {
      "id": 8,
      "category": "Electrical Service",
      "serviceDetails":
          "Install 3 LED lights and check wiring in the living room.",
      "imageUrl": Assets.images.cleanImage.path,
      "location": "Barisal, Bangladesh",
      "phone": "+8801909037016",
      "status": "Pending",
      "price": 28.00,
      "duration": 1.5,
    },
  ];

  @override
  void onInit() {
    super.onInit();
    filterServices(0);
  }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
