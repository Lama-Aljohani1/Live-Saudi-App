import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:live_saudi/core/const_data/app_colors.dart';
import '../../../core/const_data/app_images.dart';
import '../../../widgets/custome_button.dart';
import '../../ai_chatbot/screen/ai_chatbot_screen.dart';
import '../../book_tour_guide/screen/book_tour_guide_screen.dart';
import '../controller/tourist_heritage_controller.dart';
import '../widget/tab_button.dart';
import '../widget/build_exbandable_text.dart';

class PlaceDetailsScreen extends StatelessWidget {
  const PlaceDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TouristHeritageController>();
    final site = controller.selectedSite;

    // If somehow navigated without selectedSite, just pop back
    if (site == null) {
      Future.microtask(() => Navigator.pop(context));
      return const SizedBox.shrink();
    }

    // helper to get bytes or null
    Uint8List? _imageBytes(int idx) {
      if (site.imagesBase64.isEmpty) return null;
      if (idx < 0 || idx >= site.imagesBase64.length) return null;
      try {
        return base64Decode(site.imagesBase64[idx]);
      } catch (_) {
        return null;
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<TouristHeritageController>(
        builder: (controller) => SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _imageBytes(controller.selectedImage) != null
                        ? Image.memory(
                            _imageBytes(controller.selectedImage)!,
                            key: ValueKey(controller.selectedImage),
                            width: double.infinity,
                            height: 320.h,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            AppImages.Riyadh,
                            key: ValueKey(controller.selectedImage),
                            width: double.infinity,
                            height: 320.h,
                            fit: BoxFit.cover,
                          ),
                  ),
                  Positioned(
                    top: 25.h,
                    left: 16.w,
                    child: CircleAvatar(
                      backgroundColor: AppColors.white.withOpacity(0.3),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.black,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ],
              ),

              // ==== WHITE CARD ====
              Container(
                width: double.infinity,
                transform: Matrix4.translationValues(0, -35.h, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: const Offset(0, -450),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.only(right: 16.w, left: 16.w, top: 15.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 70.h,
                            width: 350.w,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(10.r),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.hintTextColor.withOpacity(
                                    0.5,
                                  ),
                                  offset: Offset(-3, 3),
                                  blurRadius: 3,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // === Thumbnails Row ===
                                  Expanded(
                                    child: SizedBox(
                                      height: 60.h,
                                      child: ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        separatorBuilder: (_, __) =>
                                            SizedBox(width: 8.w),
                                        itemCount: site.imagesBase64.length,
                                        itemBuilder: (_, i) {
                                          final isSelected =
                                              controller.selectedImage == i;
                                          Uint8List? b;
                                          try {
                                            b = base64Decode(
                                              site.imagesBase64[i],
                                            );
                                          } catch (_) {
                                            b = null;
                                          }
                                          return GestureDetector(
                                            onTap: () {
                                              controller.selectedImage = i;
                                              controller.update();
                                            },
                                            child: AnimatedContainer(
                                              duration: const Duration(
                                                milliseconds: 200,
                                              ),
                                              width: isSelected ? 90.w : 65.w,
                                              height: isSelected ? 60.h : 48.h,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12.r),
                                                border: Border.all(
                                                  color: isSelected
                                                      ? Colors.green
                                                      : Colors.transparent,
                                                  width: 2,
                                                ),
                                                image: b != null
                                                    ? DecorationImage(
                                                        image: MemoryImage(b),
                                                        fit: BoxFit.cover,
                                                      )
                                                    : DecorationImage(
                                                        image: AssetImage(
                                                          AppImages.Riyadh,
                                                        ),
                                                        fit: BoxFit.cover,
                                                      ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (controller.selectedSite != null) {
                                controller.toggleFavorite(
                                  controller.selectedSite!,
                                );
                              }
                            },
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Transform.translate(
                                offset: Offset(6.w, -36.h),
                                child: Obx(() {
                                  final isFav =
                                      controller.selectedSite != null &&
                                      controller.favoriteIds.contains(
                                        controller.selectedSite!.id,
                                      );
                                  return Container(
                                    height: 48.h,
                                    width: 48.w,
                                    decoration: BoxDecoration(
                                      color: isFav
                                          ? Colors.green
                                          : Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.hintTextColor,
                                          offset: Offset(0, 4),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.favorite,
                                      color: isFav
                                          ? Colors.white
                                          : AppColors.primaryColor,
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 24.h),

                      // ===== Title + Price + Rating =====
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  site.name,
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: AppColors.primaryColor,
                                      size: 18.w,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      site.region,
                                      style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "\$${(site.pricePerPerson).toStringAsFixed(0)}/",
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                  Text(
                                    "person",
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 6.h),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 20.w,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    (site.rating).toStringAsFixed(1),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: 24.h),

                      // ===== Avatars (Overlapping) =====
                      SizedBox(
                        height: 40.h,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0,
                              child: CircleAvatar(
                                radius: 16.r,
                                backgroundImage: AssetImage(AppImages.Riyadh),
                              ),
                            ),
                            Positioned(
                              left: 22.w,
                              child: CircleAvatar(
                                radius: 16.r,
                                backgroundImage: AssetImage(AppImages.AlUla),
                              ),
                            ),
                            Positioned(
                              left: 44.w,
                              child: CircleAvatar(
                                radius: 16.r,
                                backgroundImage: AssetImage(AppImages.Abha),
                              ),
                            ),
                            Positioned(
                              left: 66.w,
                              child: Container(
                                height: 32.h,
                                width: 32.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primaryColor.withOpacity(
                                    0.1,
                                  ),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "+12",
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 33.h),

                      // ===== Tabs =====
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          tabButton("Description", 0),
                          tabButton("Review", 1),
                        ],
                      ),

                      SizedBox(height: 10.h),

                      // ===== Description or Review =====
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: controller.selectedTab == 0
                            ? buildExpandableText(site.description, context)
                            : Column(
                                key: const ValueKey('rev'),
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "⭐ ${(site.rating).toStringAsFixed(1)}/5 from ${site.reviews.length} reviews",
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  SizedBox(height: 12.h),

                                  if (site.reviews.isNotEmpty)
                                    ListView.separated(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: site.reviews.length,
                                      separatorBuilder: (_, __) =>
                                          Divider(color: Colors.grey[300]),
                                      itemBuilder: (context, index) {
                                        final review = site.reviews[index];
                                        return Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Icon(
                                              Icons.comment,
                                              color: Colors.amber,
                                              size: 18,
                                            ),
                                            SizedBox(width: 8.w),
                                            Expanded(
                                              child: Text(
                                                "“${review.toString()}”",
                                                style: TextStyle(
                                                  color: Colors.grey[700],
                                                  fontSize: 13.sp,
                                                  height: 1.4,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    )
                                  else
                                    Text(
                                      "No reviews yet. Be the first to share your experience!",
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 13.sp,
                                      ),
                                    ),
                                ],
                              ),
                      ),

                      SizedBox(height: 32.h),
                      // ===== Book Now =====
                      CustomeButton(
                        buttonWidth: 295.w,
                        buttonHight: 59.h,
                        borderColor: AppColors.primaryColor,
                        onPressed: () {
                          Get.dialog(
                            Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              backgroundColor: AppColors.white,
                              child: Container(
                                padding: EdgeInsets.all(20.w),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(20.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.hintTextColor
                                          .withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.map_rounded,
                                      size: 55.w,
                                      color: AppColors.primaryColor,
                                    ),
                                    SizedBox(height: 16.h),
                                    Text(
                                      'Choose your guide type',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      'Would you like to continue with an AI guide or book a human guide?',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: AppColors.hintTextColor,
                                        fontSize: 15.sp,
                                        height: 1.4,
                                      ),
                                    ),
                                    SizedBox(height: 24.h),

                                    // === زر الذكاء الاصطناعي ===
                                    SizedBox(
                                      width: double.infinity,
                                      height: 50.h,
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.primaryColor,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12.r,
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            vertical: 14.h,
                                          ),
                                          elevation: 2,
                                        ),
                                        onPressed: () {
                                          Get.back();
                                          Get.to(() => AIChatbotScreen());
                                        },
                                        icon: Icon(
                                          Icons.smart_toy_outlined,
                                          size: 22.w,
                                        ),
                                        label: Text(
                                          'AI Guide',
                                          style: TextStyle(fontSize: 16.sp),
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: 12.h),

                                    // === زر المرشد البشري ===
                                    SizedBox(
                                      width: double.infinity,
                                      height: 50.h,
                                      child: OutlinedButton.icon(
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor:
                                              AppColors.primaryColor,
                                          side: BorderSide(
                                            color: AppColors.primaryColor,
                                            width: 1.5.w,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12.r,
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            vertical: 14.h,
                                          ),
                                        ),
                                        onPressed: () {
                                          Get.back();
                                          Get.to(
                                            () => BookTourGuideScreen(
                                              siteId:
                                                  controller.selectedSite!.id,
                                            ),
                                          );
                                        },
                                        icon: Icon(
                                          Icons.person_pin_circle_outlined,
                                          size: 22.w,
                                        ),
                                        label: Text(
                                          'Human Guide',
                                          style: TextStyle(fontSize: 16.sp),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            barrierDismissible: true,
                          );
                        },

                        text: "Book Now!",
                        backgroundColor: AppColors.primaryColor,
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
