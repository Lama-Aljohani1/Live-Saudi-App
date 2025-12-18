import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/const_data/app_colors.dart';
import '../../../core/const_data/app_images.dart';
import '../../book_now/screen/book_now_screen.dart';
import '../controller/book_tour_guide_controller.dart';

class BookTourGuideScreen extends StatelessWidget {
  final String siteId;

  BookTourGuideScreen({super.key, required this.siteId});

  final BookTourGuideController c = Get.put(BookTourGuideController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Book Tour Guide',
          style: TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: TextField(
                controller: c.searchCtrl,
                decoration: InputDecoration(
                  hintText: 'Search guides, country, language...',
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      c.searchCtrl.clear();
                      c.search('');
                    },
                  ),
                ),
                onChanged: (v) => c.search(v),
              ),
            ),
            SizedBox(height: 32.h),

            Text(
              "Book Tour Guide",
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryColor,
              ),
            ),
            SizedBox(height: 14.h),

            Expanded(
              child: Obx(() {
                if (c.loading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (c.filtered.isEmpty) {
                  return Center(
                    child: Text(
                      'No guides available',
                      style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: c.filtered.length,
                  separatorBuilder: (_, __) => SizedBox(height: 10.h),
                  itemBuilder: (context, i) {
                    final g = c.filtered[i];
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => BookNowScreen(siteId: siteId, guide: g));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 16.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 26.r,
                              backgroundImage: AssetImage(AppImages.tourguide),
                            ),
                            SizedBox(width: 14.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    g.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                  Text(
                                    '${g.experienceYears} yrs • ${g.country}',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 4.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Text(
                                    'Active',
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  '${g.languages} ',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
