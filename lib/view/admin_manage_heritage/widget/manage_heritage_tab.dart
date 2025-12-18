import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:live_saudi/view/admin_manage_heritage/widget/reviews_dialog.dart';
import '../../../core/const_data/app_colors.dart';
import '../controller/admin_manage_heritage_controller.dart';
import 'edit_heritage_dialog.dart';

class ManageHeritageTab extends StatelessWidget {
  const ManageHeritageTab({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AdminManageHeritageController>();

    return Obx(() {
      final sites = c.heritageSites;
      if (sites.isEmpty) {
        return Center(
          child: Text(
            'No heritage sites yet',
            style: TextStyle(color: Colors.grey, fontSize: 16.sp),
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.all(12.w),
        itemCount: sites.length,
        itemBuilder: (context, idx) {
          final s = sites[idx];
          Uint8List? firstImage;
          if (s.imagesBase64.isNotEmpty) {
            try {
              firstImage = base64Decode(s.imagesBase64.first);
            } catch (_) {
              firstImage = null;
            }
          }

          return Card(
            margin: EdgeInsets.symmetric(vertical: 10.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            elevation: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (firstImage != null)
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16.r),
                    ),
                    child: Image.memory(
                      firstImage,
                      width: double.infinity,
                      height: 180.h,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  Container(
                    height: 180.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16.r),
                      ),
                    ),
                    child: Icon(
                      Icons.image_not_supported,
                      size: 48.sp,
                      color: Colors.grey,
                    ),
                  ),

                Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              s.name,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                          Text(
                            "${s.pricePerPerson.toStringAsFixed(0)} SAR",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.hintTextColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        children: [
                          Icon(Icons.place, size: 14.sp, color: Colors.grey),
                          SizedBox(width: 6.w),
                          Text(
                            s.region,
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          ...List.generate(5, (index) {
                            final filled = index < s.rating.round();
                            return Icon(
                              filled
                                  ? Icons.star_rounded
                                  : Icons.star_border_rounded,
                              color: Colors.amber,
                              size: 18.sp,
                            );
                          }),
                          SizedBox(width: 6.w),
                          Text(
                            s.rating.toStringAsFixed(1),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13.sp,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            "(${s.reviews.length})",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          Chip(
                            label: Text(
                              s.category.toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                              ),
                            ),
                            backgroundColor: AppColors.primaryColor,
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 18.sp),
                          SizedBox(width: 6.w),
                          Text(
                            s.rating.toStringAsFixed(1),
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            "(${s.reviews.length} reviews)",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12.sp,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () =>
                                Get.dialog(ReviewsDialog(siteId: s.id)),
                            icon: const Icon(Icons.reviews_outlined),
                            label: const Text('View Reviews'),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        s.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey.shade800),
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _actionButton(
                            'Edit',
                            Icons.edit_outlined,
                            AppColors.primaryColor,
                            () => Get.dialog(EditHeritageDialog(site: s)),
                          ),
                          SizedBox(width: 8.w),
                          _actionButton(
                            'Delete',
                            Icons.delete_outline,
                            Colors.redAccent,
                            () => _confirmDelete(c, s),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  Widget _actionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 16.sp),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(AdminManageHeritageController c, dynamic site) {
    Get.dialog(
      AlertDialog(
        title: Text('Delete', style: TextStyle(fontWeight: FontWeight.w700)),
        content: Text('Are you sure you want to delete this site?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              c.deleteSite(site);
              Get.back();
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
