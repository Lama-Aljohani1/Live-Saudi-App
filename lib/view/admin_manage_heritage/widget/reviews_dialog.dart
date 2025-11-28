import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/const_data/app_colors.dart';
import '../controller/admin_manage_heritage_controller.dart';

class ReviewsDialog extends StatelessWidget {
  final String siteId;
  const ReviewsDialog({super.key, required this.siteId});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AdminManageHeritageController>();
    c.loadReviews(siteId);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Reviews', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700)),
            SizedBox(height: 10.h),

            // قائمة التعليقات
            Obx(() {
              if (c.currentReviews.isEmpty) {
                return const Text('No reviews yet');
              }
              return SizedBox(
                height: 250.h,
                child: ListView.builder(
                  itemCount: c.currentReviews.length,
                  itemBuilder: (ctx, i) {
                    final rev = c.currentReviews[i];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 4.h),
                      child: ListTile(
                        title: Text(rev['username'] ?? ''),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RatingBarIndicator(
                              rating: (rev['stars'] ?? 0).toDouble(),
                              itemSize: 18,
                              itemBuilder: (ctx, _) => const Icon(Icons.star, color: Colors.amber),
                            ),
                            Text(rev['comment'] ?? ''),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => c.deleteReview(siteId, i),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),

            const Divider(),
            SizedBox(height: 6.h),
            Text('Add New Review', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp)),
            SizedBox(height: 6.h),
            TextField(
              controller: c.reviewName,
              decoration: const InputDecoration(labelText: 'Your name'),
            ),
            SizedBox(height: 6.h),
            TextField(
              controller: c.reviewComment,
              decoration: const InputDecoration(labelText: 'Comment'),
            ),
            SizedBox(height: 6.h),
            Obx(() {
              return RatingBar.builder(
                initialRating: c.reviewStars.value,
                minRating: 1,
                direction: Axis.horizontal,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (rating) => c.reviewStars.value = rating,
              );
            }),
            SizedBox(height: 12.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor),
              onPressed: () => c.addReview(siteId),
              child: const Text('Add Review'),
            ),
          ],
        ),
      ),
    );
  }
}
