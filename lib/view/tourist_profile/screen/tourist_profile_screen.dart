import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/const_data/app_colors.dart';
import '../../../widgets/custome_button.dart';
import '../controller/tourist_profile_controller.dart';

class TouristProfileScreen extends GetView<TouristProfileController> {
  TouristProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(TouristProfileController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "My Profile",
          style: TextStyle(
            color: AppColors.primaryColor,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: GetBuilder<TouristProfileController>(
        builder: (controller) {
          if (controller.currentUser == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => controller.pickImage(),
                  child: Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 55.r,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: controller.imageFile != null
                              ? FileImage(controller.imageFile!)
                              : (controller.currentUser!.imagePath != null &&
                                    controller
                                        .currentUser!
                                        .imagePath!
                                        .isNotEmpty)
                              ? NetworkImage(controller.currentUser!.imagePath!)
                              : null,

                          child:
                              controller.imageFile == null &&
                                  (controller.currentUser!.imagePath == null ||
                                      controller
                                          .currentUser!
                                          .imagePath!
                                          .isEmpty)
                              ? Icon(
                                  Icons.person,
                                  size: 55.r,
                                  color: Colors.grey,
                                )
                              : null,
                        ),

                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 34.h,
                            width: 34.h,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                _buildInfoTile("Name", controller.currentUser!.name),
                _buildInfoTile("Email", controller.currentUser!.email),
                _buildInfoTile("Role", controller.currentUser!.role),

                SizedBox(height: 30.h),

                CustomeButton(
                  buttonWidth: 250.w,
                  buttonHight: 55.h,
                  text: "Edit Profile",
                  backgroundColor: AppColors.primaryColor,
                  borderColor: AppColors.primaryColor,
                  onPressed: () => _openEditBottomSheet(context),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoTile(String title, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(color: Colors.black12, offset: Offset(0, 3), blurRadius: 6),
        ],
      ),
      child: Row(
        children: [
          Text(
            "$title:",
            style: TextStyle(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.black87, fontSize: 15.sp),
            ),
          ),
        ],
      ),
    );
  }

  void _openEditBottomSheet(BuildContext context) {
    final nameCtrl = TextEditingController(
      text: controller.currentUser?.name ?? "",
    );
    final emailCtrl = TextEditingController(
      text: controller.currentUser?.email ?? "",
    );

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Edit Profile",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),

            SizedBox(height: 20.h),

            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 15.h),

            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20.h),

            CustomeButton(
              buttonWidth: double.infinity,
              buttonHight: 50.h,
              backgroundColor: AppColors.primaryColor,
              borderColor: AppColors.primaryColor,
              text: "Save",
              onPressed: () {
                controller.updateUserProfile(
                  newName: nameCtrl.text.trim(),
                  newEmail: emailCtrl.text.trim(),
                );
                Get.back();
              },
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
