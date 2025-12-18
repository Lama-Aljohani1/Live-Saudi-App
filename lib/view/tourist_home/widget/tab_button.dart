import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/const_data/app_colors.dart';
import '../controller/tourist_heritage_controller.dart';

Widget tabButton(String title, int index) {
  final controller = Get.find<TouristHeritageController>();
  final isActive = controller.selectedTab == index;
  return Expanded(
    child: GetBuilder<TouristHeritageController>(
      builder: (controller) => GestureDetector(
        onTap: () {
          controller.selectedTab = index;
          controller.update();
        },
        child: Container(
          padding: EdgeInsets.only(bottom: 8.h),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: controller.selectedTab == index
                    ? AppColors.primaryColor
                    : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: controller.selectedTab == index
                  ? FontWeight.w600
                  : FontWeight.normal,
              color: controller.selectedTab == index
                  ? Colors.black
                  : Colors.grey,
            ),
          ),
        ),
      ),
    ),
  );
}
