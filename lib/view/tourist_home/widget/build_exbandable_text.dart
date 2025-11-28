import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/const_data/app_colors.dart';
import '../../../core/const_data/text_style.dart';
import '../controller/tourist_heritage_controller.dart';

Widget buildExpandableText(String text, BuildContext context) {
  final controller = Get.find<TouristHeritageController>();
  final textSpan = TextSpan(text: text, style: FontStyles.details);
  final tp = TextPainter(
    text: textSpan,
    maxLines: 6,
    textDirection: TextDirection.ltr,
  )..layout(maxWidth: MediaQuery.of(context).size.width - 32.w);

  final exceeds = tp.didExceedMaxLines;

  return GetBuilder<TouristHeritageController>(
    builder: (controller) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedCrossFade(
          firstChild: Text(
            text,
            style: FontStyles.details,
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
          ),
          secondChild: Text(text, style: FontStyles.details),
          crossFadeState: controller.isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
        if (exceeds)
          GestureDetector(
            onTap: () {
              controller.isExpanded = !controller.isExpanded;
              controller.update();
            },
            child: Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Text(
                controller.isExpanded ? "Read less" : "Read more",
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 13.sp,
                ),
              ),
            ),
          ),
      ],
    ),
  );
}
