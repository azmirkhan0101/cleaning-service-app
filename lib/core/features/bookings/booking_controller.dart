import 'package:get/get.dart';

class BookingController extends GetxController {
  // Observing the selected tab index
  var selectedIndex = 0.obs;

  // Function to update the tab index
  void changeTab(int index) {
    selectedIndex.value = index;
  }

  RxList<String> tabNameList = [
    "All",
    "Pending",
    "Ongoing",
    "Completed",
    "Cancelled",
  ].obs;
}
