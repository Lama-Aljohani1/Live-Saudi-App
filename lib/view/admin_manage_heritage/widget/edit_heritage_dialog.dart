import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/const_data/app_colors.dart';
import '../../../models/heritage_model.dart';
import '../controller/admin_manage_heritage_controller.dart';

class EditHeritageDialog extends StatelessWidget {
  final HeritageModel site;

  const EditHeritageDialog({super.key, required this.site});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AdminManageHeritageController>();

    // pre-fill fields (do not overwrite if user already opened dialog multiple times)
    c.name.text = site.name;
    c.region.text = site.region;
    c.description.text = site.description;
    c.price.text = site.pricePerPerson.toString();
    c.rating.text = site.rating.toString();
    c.selectedLocation = LatLng(site.latitude, site.longitude);

    final existing = site.imagesBase64;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.r)),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Edit Heritage Site',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                ...existing.map((b64) {
                  Uint8List? bytes;
                  try {
                    bytes = base64Decode(b64);
                  } catch (_) {
                    bytes = null;
                  }
                  return Container(
                    width: 92.w,
                    height: 92.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: Colors.grey.shade200,
                    ),
                    child: bytes != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: Image.memory(bytes, fit: BoxFit.cover),
                          )
                        : Icon(Icons.image_not_supported),
                  );
                }).toList(),

                Obx(
                  () => Wrap(
                    spacing: 8.w,
                    children: [
                      ...c.pickedImages
                          .map(
                            (x) => Stack(
                              children: [
                                Container(
                                  width: 92.w,
                                  height: 92.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12.r),
                                    child: Image.file(
                                      File(x.path),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 6,
                                  top: 6,
                                  child: GestureDetector(
                                    onTap: () => c.pickedImages.remove(x),
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
                            ),
                          )
                          .toList(),
                      GestureDetector(
                        onTap: c.pickImages,
                        child: Container(
                          width: 92.w,
                          height: 92.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            color: Colors.grey.shade200,
                          ),
                          child: Icon(Icons.add_a_photo),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            _field('Name', c.name),
            _field('Region', c.region),
            _field(
              'Price per person (SAR)',
              c.price,
              keyboard: TextInputType.number,
            ),
            _field('Rating (1-5)', c.rating, keyboard: TextInputType.number),
            _field('Description', c.description, maxLines: 3),
            SizedBox(height: 8.h),
            Center(
              child: ElevatedButton.icon(
                onPressed: c.selectLocationFromMap,
                icon: const Icon(Icons.map_outlined),
                label: Text('Change Location', style:TextStyle()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            ElevatedButton(
              onPressed: () => c.updateSite(site.id, oldSite: site),

              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.hintTextColor,
                padding: EdgeInsets.symmetric(vertical: 14.h),
              ),
              child: Text(
                'Save Changes',
                style:TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
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
