// lib/view/food/screen/food_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live_saudi/core/const_data/text_style.dart';
import 'package:live_saudi/widgets/custome_button.dart';
import '../../../core/const_data/app_colors.dart';
import '../../../core/services/base64_image.dart';
import '../../food/controller/food_list_controller.dart';
import '../../food_details/screen/food_details.dart';
import '../../tourist_profile/controller/tourist_profile_controller.dart';

class FoodScreen extends StatelessWidget {
  const FoodScreen({super.key});

  static const Color darkOlive = Color(0xFF2F4B26);
  static const Color softGrey = Color(0xFFF8F8F8);
  static const Color muted = Color(0xFF8E9A8C);
  static const Color starColor = Color(0xFFF2C94C);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FoodListController());
    final profile = Get.put(TouristProfileController());
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
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
                  style: TextStyle(fontSize: 16.sp, color: Colors.grey[700]),
                );
              },
            ),

            SizedBox(height: 6.h),
            Text(
              'What food near you want today?',
              style: TextStyle(
                fontSize: 30.sp,
                fontWeight: FontWeight.bold,
                color: darkOlive,
              ),
            ),
            SizedBox(height: 18.h),
            Expanded(
              child: GetBuilder<FoodListController>(
                builder: (_) {
                  return StreamBuilder<QuerySnapshot>(
                    stream: controller.streamFoodAccounts(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final docs = snapshot.data?.docs ?? [];
                      if (docs.isEmpty) {
                        return Center(
                          child: Text(
                            'No restaurants found',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        );
                      }
                      return ListView.separated(
                        padding: EdgeInsets.only(bottom: 24.h, top: 6.h),
                        itemCount: docs.length,
                        separatorBuilder: (_, __) => SizedBox(height: 14.h),
                        itemBuilder: (context, index) {
                          final doc = docs[index];
                          final data = doc.data() as Map<String, dynamic>;
                          return RestaurantListCard(
                            data: data,
                            id: doc.id,
                            onTap: () => Get.to(
                              () => RestaurantDetailsScreen(accountId: doc.id),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RestaurantListCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final String id;
  final VoidCallback? onTap;

  const RestaurantListCard({
    super.key,
    required this.data,
    required this.id,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final name = data['name'] ?? 'Unknown';
    final address = data['address'] ?? data['location'] ?? '';
    final rating = (data['rating'] ?? 0.0).toDouble();
    final base64 = data['imageBase64'] ?? data['imageUrl'];

    Color darkOlive = AppColors.primaryColor;
    const Color muted = Color(0xFF8E9A8C);
    const Color cardBg = Color(0xFFF8F8F8);

    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 12,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 130.w,
              height: 120.w,
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14.r),
                  bottomLeft: Radius.circular(14.r),
                ),
              ),
              child: Base64ImageHelper.fromBase64(
                base64,
                width: 130.w,
                height: 120.w,
                fit: BoxFit.cover,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14.r),
                  bottomLeft: Radius.circular(14.r),
                ),
                placeholder: Container(
                  width: 130.w,
                  height: 120.w,
                  color: Colors.grey[200],
                  child: Icon(Icons.image_not_supported, color: Colors.grey),
                ),
              ),
            ),

            SizedBox(width: 12.w),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 6.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Color(0xFFF2C94C),
                                size: 16.w,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                rating.toStringAsFixed(1),
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14.w, color: muted),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(
                            address,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    CustomeButton(
                      buttonHight: 25.h,
                      buttonWidth: 100.w,
                      editedTextStyle: FontStyles.buttonTextStyle.copyWith(
                        fontSize: 14.sp,
                      ),
                      width: 5.w,
                      borderColor: darkOlive,
                      onPressed: onTap,
                      text: "Details",
                      backgroundColor: darkOlive,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
