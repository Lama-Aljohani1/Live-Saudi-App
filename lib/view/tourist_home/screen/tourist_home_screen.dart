import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:live_saudi/core/const_data/app_colors.dart';
import 'package:live_saudi/core/const_data/app_images.dart';
import '../../tourist_profile/controller/tourist_profile_controller.dart';
import '../../touurist_bottom_navbar/controller/bottom_navbar_controller.dart';
import '../controller/tourist_heritage_controller.dart';
import '../widget/filter_pill.dart';
import '../widget/small_place_card.dart';

class TouristHomeScreen extends StatelessWidget {
  const TouristHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(BottomNavbarController());
    Get.put(TouristHeritageController());
    final profile = Get.put(TouristProfileController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<TouristHeritageController>(
        builder: (controller) => SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12.h),
                GetBuilder<TouristProfileController>(
                  builder: (pController) {
                    final name = pController.currentUser?.name ?? "Traveler";
                    return Text(
                      "Hi $name,",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[700],
                      ),
                    );
                  },
                ),

                SizedBox(height: 4.h),
                Text(
                  "Where do you\nwanna go?",
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                    height: 1.1,
                  ),
                ),
                SizedBox(height: 22.h),

                SizedBox(
                  height: 260.h,
                  child: controller.featuredSites.isEmpty
                      ? Center(child: CircularProgressIndicator())
                      : PageView.builder(
                          controller: controller.pageController,
                          itemCount: controller.featuredSites.length,
                          onPageChanged: (i) {
                            controller.currentIndex = i;
                            controller.update();
                          },
                          itemBuilder: (context, i) {
                            final bool isActive = i == controller.currentIndex;
                            final site = controller.featuredSites[i];
                            Uint8List? bytes;
                            if (site.imagesBase64.isNotEmpty) {
                              try {
                                bytes = base64Decode(site.imagesBase64.first);
                              } catch (_) {
                                bytes = null;
                              }
                            }
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              margin: EdgeInsets.symmetric(
                                horizontal: 0.w,
                                vertical: isActive ? 0 : 16.h,
                              ),
                              child: GestureDetector(
                                onTap: () =>
                                    controller.openDetailsByFeaturedIndex(i),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      height: 291.h,
                                      width: 283.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          28.r,
                                        ),
                                        image: bytes != null
                                            ? DecorationImage(
                                                image: MemoryImage(bytes),
                                                fit: BoxFit.cover,
                                              )
                                            : DecorationImage(
                                                image: AssetImage(
                                                  AppImages.Riyadh,
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.1,
                                            ),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          24.r,
                                        ),
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            Colors.black.withOpacity(0.25),
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 20.h,
                                      child: Container(
                                        width: 220.w,
                                        height: 55.h,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 32.w,
                                          vertical: 18.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryColor
                                              .withOpacity(0.7),
                                          borderRadius: BorderRadius.circular(
                                            30.r,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            textAlign: TextAlign.center,
                                            "See More",
                                            style: TextStyle(
                                              color: AppColors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),

                SizedBox(height: 14.h),

                Center(
                  child: SmoothPageIndicator(
                    controller: controller.pageController,
                    count: controller.featuredSites.length,
                    effect: ExpandingDotsEffect(
                      dotHeight: 8.h,
                      dotWidth: 8.w,
                      activeDotColor: AppColors.primaryColor,
                      dotColor: Colors.grey.shade300,
                    ),
                  ),
                ),

                SizedBox(height: 22.h),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(controller.filters.length, (i) {
                      final item = controller.filters[i];
                      return Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: FilterPill(
                          icon: item["icon"] as IconData,
                          label: item["label"] as String,
                          active: controller.selectedIndex == i,
                          onTap: () {
                            controller.selectFilterByIndex(i);
                          },
                        ),
                      );
                    }),
                  ),
                ),
                SizedBox(height: 22.h),

                SizedBox(
                  height: 180.h,
                  child: controller.filteredSites.isEmpty
                      ? Center(
                          child: Text(
                            'No places',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.filteredSites.length,
                          itemBuilder: (ctx, idx) {
                            final s = controller.filteredSites[idx];
                            Uint8List? bytes;
                            if (s.imagesBase64.isNotEmpty) {
                              try {
                                bytes = base64Decode(s.imagesBase64.first);
                              } catch (_) {
                                bytes = null;
                              }
                            }
                            return GestureDetector(
                              onTap: () =>
                                  controller.openDetailsFromSmallCard(idx),
                              child: SmallPlaceCard(
                                imageBytes: bytes,
                                title: s.name,
                                location: s.region ?? 'Saudi Arabia',
                              ),
                            );
                          },
                        ),
                ),

                SizedBox(height: 80.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
