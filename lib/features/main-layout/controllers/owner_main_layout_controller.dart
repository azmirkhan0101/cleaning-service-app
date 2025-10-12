import 'package:get/get.dart';

class OwnerMainLayoutController extends GetxController {
  // Observable for current selected index
  final RxInt selectedIndex = 0.obs;

  // Method to change the tab
  void changeTab(int index) {
    selectedIndex.value = index;
  }
}
