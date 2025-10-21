import 'package:cleaning_service_app/core/components/custom_text/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppBarTabBar extends StatefulWidget implements PreferredSizeWidget {
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
  State<AppBarTabBar> createState() => _AppBarTabBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 40);
}

class _AppBarTabBarState extends State<AppBarTabBar> {
  int selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: widget.leading,
      title: CustomText(
        text: widget.title,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              widget.tabTitles.length,
              (index) =>
                  _buildTab(index: index, title: widget.tabTitles[index]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTab({required int index, required String title}) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedTabIndex = index;
          widget.onTabSelected(index);
        });
      },
      child: Container(
        width: 100.w,
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selectedTabIndex == index
                  ? Color(0xFF4899D1)
                  : Color(0xFFB9C2DB),
              width: 3.0,
            ),
          ),
        ),
        child: Center(
          child: CustomText(
            text: title,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: selectedTabIndex == index
                ? Color(0xFF4899D1)
                : Color(0xFFB9C2DB),
          ),
        ),
      ),
    );
  }
}
