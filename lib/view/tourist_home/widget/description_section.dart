import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controller/tourist_heritage_controller.dart';

class DescriptionSection extends StatelessWidget {
  const DescriptionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TouristHeritageController>();
    return GetBuilder<TouristHeritageController>(builder: (controller) {
      final site = controller.selectedSite;
      final descriptionText = site?.description ??
          "Baeshen Museum is located in Jeddah, inside the historic Al-Balad area. It showcases traditional Saudi art, cultural artifacts, and offers guided tours for visitors interested in Saudi heritage.";
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  controller.tab = 0;
                  controller.update();
                },
                child: Text(
                  "Description",
                  style: TextStyle(
                    fontWeight: controller.tab == 0 ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(width: 18.w),
              GestureDetector(
                onTap: () {
                  controller.tab = 1;
                  controller.update();
                },
                child: Text(
                  "Review",
                  style: TextStyle(
                    fontWeight: controller.tab == 1 ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          if (controller.tab == 0)
            Text(
              descriptionText,
              style: TextStyle(color: Colors.grey[700], height: 1.4),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 14.r,
                      backgroundImage: AssetImage('assets/images/avatar2.jpg'),
                    ),
                    SizedBox(width: 8.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Sara",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "2 days ago",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  "Great experience, loved the guided tour and the artifacts!",
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
        ],
      );
    });
  }
}
