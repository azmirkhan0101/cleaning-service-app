import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:cleaning_service_app/core/utils/context_extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AppBarTabBarController extends GetxController {
  var selectedTabIndex = 0.obs;

  void selectTab(int index) {
    selectedTabIndex.value = index;
  }
}

class AppBarTabBar extends StatelessWidget implements PreferredSizeWidget {
  const AppBarTabBar({
    super.key,
    required this.title,
    required this.tabTitles,
    required this.onTabSelected,
    this.leading,
  });
  final String title;
  final List<String> tabTitles;
  final Function(int) onTabSelected;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {

    bool isTab = context.isTab;

    return AppBar(
      leading: leading,
      title: CustomText(text: title, fontSize: isTab ? 16 : 18, fontWeight: FontWeight.w600),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: tabTitles.length > 4
            ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    tabTitles.length,
                    (index) => _buildTab(index: index, title: tabTitles[index], isTab: isTab),
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  tabTitles.length,
                  (index) => Expanded(
                    child: _buildTab(index: index, title: tabTitles[index], isTab: isTab),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildTab({required int index, required String title, required bool isTab}) {
    return Obx(() {
      final controller = Get.put(AppBarTabBarController());
      return InkWell(
        onTap: () {
          controller.selectTab(index);
          onTabSelected(index);
        },
        child: Container(
          width: 90.w,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: controller.selectedTabIndex.value == index
                    ? Color(0xFF4899D1)
                    : Color(0xFFB9C2DB),
                width: 3.0,
              ),
            ),
          ),
          child: Center(
            child: CustomText(
              text: title,
              fontSize: isTab ? 10 : 13,
              fontWeight: FontWeight.w500,
              color: controller.selectedTabIndex.value == index
                  ? Color(0xFF4899D1)
                  : Color(0xFFB9C2DB),
            ),
          ),
        ),
      );
    });
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 40);
}
