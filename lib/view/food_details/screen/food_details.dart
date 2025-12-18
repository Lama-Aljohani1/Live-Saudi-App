import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/const_data/app_colors.dart';
import '../../../core/const_data/text_style.dart';
import '../../../core/services/base64_image.dart';
import '../../../widgets/custome_button.dart';
import '../../food_item/screen/food_item_details_screen.dart';
import '../controller/food_controller.dart';

class RestaurantDetailsScreen extends StatelessWidget {
  final String accountId;

  const RestaurantDetailsScreen({super.key, required this.accountId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RestaurantDetailsController(accountId));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Restaurant Details",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
            color: Colors.black87,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: GetBuilder<RestaurantDetailsController>(
        builder: (_) {
          if (controller.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.data == null) {
            return const Center(child: Text("Restaurant not found"));
          }

          final data = controller.data!;
          final imageData = data['imageBase64'] ?? '';
          final name = data['name'] ?? 'Restaurant';
          final desc = data['description'] ?? '';
          final rating = (data['rating'] ?? 0).toDouble();
          final ratingCount = (data['ratingCount'] ?? 0).toInt();
          final whatsapp = data['whatsapp'] ?? '';
          final instagram = data['instagram'] ?? '';
          final phone = data["phone"] ?? '';
          final location = data['location'] ?? 'Saudi Arabia';

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(18.r),
                  child: Base64ImageHelper.fromBase64(
                    imageData,
                    width: double.infinity,
                    height: 220.h,
                    fit: BoxFit.cover,
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                ),
                SizedBox(height: 14.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.grey,
                                size: 16,
                              ),
                              SizedBox(width: 4.w),
                              Flexible(
                                child: Text(
                                  location,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 20.w),
                        SizedBox(width: 4.w),
                        Text(
                          rating.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          " ($ratingCount)",
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.textFieldBorderColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(
                            FontAwesomeIcons.whatsapp,
                            color: Colors.green,
                          ),
                          onPressed: () {
                            if (whatsapp.isNotEmpty) {
                              controller.launchUrll("https://wa.me/$whatsapp");
                            }
                          },
                        ),
                        SizedBox(width: 32.w),

                        IconButton(
                          icon: const Icon(
                            Icons.phone_outlined,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            if (phone.isNotEmpty) {
                              // أو استخدم variable phone إذا لديك
                              controller.launchUrll("tel:$phone");
                            }
                          },
                        ),
                        SizedBox(width: 32.w),

                        IconButton(
                          icon: const Icon(
                            FontAwesomeIcons.instagram,
                            color: Colors.pinkAccent,
                          ),
                          onPressed: () {
                            if (instagram.isNotEmpty) {
                              controller.launchUrll(
                                "https://instagram.com/$instagram",
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 14.h),
                Text(
                  "Meals",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 12.h),

                StreamBuilder<QuerySnapshot>(
                  stream: controller.streamMeals(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final docs = snapshot.data?.docs ?? [];
                    if (docs.isEmpty) {
                      return Center(
                        child: Text(
                          "No meals available",
                          style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                        ),
                      );
                    }

                    return Column(
                      children: docs.map((doc) {
                        final meal = doc.data() as Map<String, dynamic>;
                        final mealId = doc.id;

                        return InkWell(
                          onTap: () => Get.to(
                            () => MealDetailsScreen(
                              accountId: accountId,
                              mealId: mealId,
                              phone: phone,
                              insta: instagram,
                              whatsapp: whatsapp,
                            ),
                          ),
                          child: Container(
                            margin: EdgeInsets.only(bottom: 16.h),
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
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16.r),
                                    bottomLeft: Radius.circular(16.r),
                                  ),
                                  child: Base64ImageHelper.fromBase64(
                                    meal['imageBase64'],
                                    width: 120.w,
                                    height: 120.h,
                                    fit: BoxFit.cover,
                                    borderRadius: BorderRadius.circular(18.r),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(10.w),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          meal['name'] ?? 'Meal',
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 6.h),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                              size: 14.w,
                                            ),
                                            SizedBox(width: 4.w),
                                            Text(
                                              (meal['rating'] ?? 0)
                                                  .toStringAsFixed(1),
                                              style: TextStyle(
                                                fontSize: 13.sp,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                            const Spacer(),
                                            Text(
                                              "\$${meal['price'] ?? '—'}",
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
                SizedBox(height: 30.h),
              ],
            ),
          );
        },
      ),

      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.w),
        child: ElevatedButton.icon(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              builder: (_) => Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Rate this restaurant",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    _RatingStarsWidget(
                      onSubmit: (value) async {
                        await controller.submitRestaurantRating(
                          userId: "demoUser123",
                          stars: value,
                        );
                        Get.back();
                        Get.snackbar(
                          "Thank you!",
                          "Your rating has been submitted successfully.",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green.withOpacity(0.8),
                          colorText: Colors.white,
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            padding: EdgeInsets.symmetric(vertical: 12.h),
          ),
          icon: const Icon(Icons.star, color: Colors.white),
          label: Text(
            "Rate this restaurant",
            style: FontStyles.buttonTextStyle,
          ),
        ),
      ),
    );
  }
}

class _RatingStarsWidget extends StatefulWidget {
  final Function(int) onSubmit;

  const _RatingStarsWidget({required this.onSubmit});

  @override
  State<_RatingStarsWidget> createState() => _RatingStarsWidgetState();
}

class _RatingStarsWidgetState extends State<_RatingStarsWidget> {
  int selected = 0;
  bool submitted = false;

  @override
  Widget build(BuildContext context) {
    return submitted
        ? Column(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 34.w),
              SizedBox(height: 6.h),
              Text("Thank you for rating!", style: TextStyle(fontSize: 14.sp)),
            ],
          )
        : Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < selected ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 32.w,
                    ),
                    onPressed: () => setState(() => selected = index + 1),
                  );
                }),
              ),
              SizedBox(height: 8.h),
              CustomeButton(
                buttonHight: 35.h,
                buttonWidth: 125.w,
                editedTextStyle: FontStyles.buttonTextStyle.copyWith(
                  fontSize: 14.sp,
                  color: selected == 0
                      ? AppColors.textFieldBorderColor
                      : AppColors.white,
                ),
                width: 5.w,
                borderColor: AppColors.primaryColor,
                onPressed: selected == 0
                    ? null
                    : () async {
                        await widget.onSubmit(selected);
                        setState(() => submitted = true);
                      },
                text: "Submit Rating",
                backgroundColor: AppColors.primaryColor,
              ),
            ],
          );
  }
}
