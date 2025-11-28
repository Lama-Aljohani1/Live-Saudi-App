import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:live_saudi/core/const_data/text_style.dart';
import '../../../core/const_data/app_colors.dart';
import '../controller/admin_manage_heritage_controller.dart';

class AddHeritageDialog extends StatelessWidget {
  const AddHeritageDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AdminManageHeritageController>();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.r)),
      elevation: 10,
      backgroundColor: AppColors.white,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Add Heritage Site',
                style:TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            SizedBox(height: 12.h),

            // images
            Obx(() {
              return Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: [
                  ...c.pickedImages.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final x = entry.value;
                    return Stack(
                      children: [
                        Container(
                          width: 92.w,
                          height: 92.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: Image.file(File(x.path), fit: BoxFit.cover),
                          ),
                        ),
                        Positioned(
                          right: 6,
                          top: 6,
                          child: GestureDetector(
                            onTap: () => c.removePickedImage(idx),
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.black54,
                              child: Icon(
                                Icons.close,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                  GestureDetector(
                    onTap: c.pickImages,
                    child: Container(
                      width: 92.w,
                      height: 92.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: Colors.grey.shade200,
                      ),
                      child: Icon(
                        Icons.add_a_photo,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              );
            }),

            SizedBox(height: 12.h),
            _field('Name', Get.find<AdminManageHeritageController>().name),
            _field('Region', Get.find<AdminManageHeritageController>().region),
            _field(
              'Price per person (SAR)',
              Get.find<AdminManageHeritageController>().price,
              keyboard: TextInputType.number,
            ),
            _field(
              'Rating (1-5)',
              Get.find<AdminManageHeritageController>().rating,
              keyboard: TextInputType.number,
            ),
            _field(
              'Description',
              Get.find<AdminManageHeritageController>().description,
              maxLines: 3,
            ),
            SizedBox(height: 10.h),
            Text("Category", style: TextStyle(fontWeight: FontWeight.w600)),
            SizedBox(height: 6.h),
            Obx(() {
              final c = Get.find<AdminManageHeritageController>();
              return DropdownButtonFormField<String>(
                value: c.selectedCategory.value,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                ),
                items: const [
                  DropdownMenuItem(value: 'lake', child: Text('Lake 🏞️')),
                  DropdownMenuItem(value: 'beach', child: Text('Beach 🏖️')),
                  DropdownMenuItem(value: 'mountain', child: Text('Mountain ⛰️')),
                  DropdownMenuItem(value: 'popular', child: Text('Popular ⭐')),
                ],
                onChanged: (v) => c.selectedCategory.value = v ?? 'popular',
              );
            }),

            SizedBox(height: 8.h),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => c.selectLocationFromMap(),
                icon:  Icon(Icons.map_outlined,color: AppColors.white,),
                label: Text(
                  'Select Location on Map',style: FontStyles.buttonTextStyle.copyWith(fontSize: 14.sp),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: EdgeInsets.symmetric(
                    horizontal: 18.w,
                    vertical: 12.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ),
            SizedBox(height: 14.h),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => c.addSite(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.hintTextColor,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'Save Site',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController ctrl, {
    TextInputType keyboard = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: TextField(
        controller: ctrl,
        keyboardType: keyboard,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
        ),
      ),
    );
  }
}
