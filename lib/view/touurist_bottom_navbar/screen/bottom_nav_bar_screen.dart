import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/const_data/app_colors.dart';
import '../../nearby_heritage/screen/nearby_heritage_screen.dart';
import '../../tourist_home/screen/tourist_home_screen.dart';
import '../controller/bottom_navbar_controller.dart';

class TouristBottomNavBar extends StatelessWidget {
  const TouristBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final BottomNavbarController controller = Get.put(BottomNavbarController());

    final pages = [
      const TouristHomeScreen(),
      NearbyHeritageScreen(),
      Container(),
      Container(),
    ];

    return GetBuilder<BottomNavbarController>(
      builder: (_) => Scaffold(
        extendBody: true,
        body: pages[controller.selectedIndex],
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Container(
            height: 54.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  index: 0,
                  icon: Icons.home_rounded,
                  controller: controller,
                ),
                _buildNavItem(
                  index: 1,
                  icon: Icons.explore_outlined,
                  controller: controller,
                ),
                _buildNavItem(
                  index: 2,
                  icon: Icons.restaurant_rounded,
                  controller: controller,
                ),
                _buildNavItem(
                  index: 3,
                  icon: Icons.person_outline,
                  controller: controller,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required BottomNavbarController controller,
  }) {
    final bool isSelected = controller.selectedIndex == index;

    return GestureDetector(
      onTap: () => controller.changeTab(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 45.w,
        height: 45.w,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 24.w,
          color: isSelected ? Colors.white : Colors.grey[500],
        ),
      ),
    );
  }
}
