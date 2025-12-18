import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:live_saudi/view/auth/screen/auth_screen.dart';
import '../../../core/const_data/app_colors.dart';
import '../../../core/const_data/app_images.dart';
import '../../food/screen/food_screen.dart';
import '../../nearby_heritage/screen/nearby_heritage_screen.dart';
import '../../tourist_home/screen/tourist_home_screen.dart';
import '../../tourist_profile/screen/tourist_profile_screen.dart';
import '../controller/bottom_navbar_controller.dart';

class TouristBottomNavBar extends StatelessWidget {
  const TouristBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final BottomNavbarController controller = Get.put(BottomNavbarController());

    final pages = [
      const TouristHomeScreen(),
      NearbyHeritageScreen(),
      FoodScreen(),
      TouristProfileScreen(),
    ];

    return GetBuilder<BottomNavbarController>(
      builder: (_) => Scaffold(
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Padding(
            padding: EdgeInsets.only(left: 14.w),
            child: GestureDetector(
              onTap: () => _showLogoutDialog(context),
              child: Icon(Icons.menu, color: Colors.grey[800]),
            ),
          ),

          actions: [
            Padding(
              padding: EdgeInsets.only(right: 14.w),
              child: Image.asset(AppImages.appLogo),
            ),
          ],
        ),
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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text(
          "Logout",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
        content: Text(
          "Are you sure you want to logout?",
          style: TextStyle(fontSize: 15.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Colors.grey[700])),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Get.offAll(AuthScreen());
            },
            child: Text(
              "Logout",
              style: TextStyle(color: AppColors.primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
