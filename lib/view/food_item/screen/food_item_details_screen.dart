import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../core/const_data/app_colors.dart';
import '../../../core/services/base64_image.dart';
import '../controller/food_item_controller.dart';

class MealDetailsScreen extends StatelessWidget {
  final String accountId;
  final String mealId;
  final String phone;
  final String insta;
  final String whatsapp;

  const MealDetailsScreen({
    super.key,
    required this.accountId,
    required this.mealId,
    required this.phone,
    required this.insta,
    required this.whatsapp,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      MealDetailsController(accountId: accountId, mealId: mealId),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryColor),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.star_rate_rounded,
              color: AppColors.primaryColor,
            ),
            onPressed: () => _showRatingDialog(context, controller),
          ),
        ],
      ),

      body: GetBuilder<MealDetailsController>(
        builder: (_) {
          if (controller.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.mealData == null) {
            return const Center(child: Text("Meal not found"));
          }

          final data = controller.mealData!;
          final imageData = data['imageBase64'] ?? '';
          final name = data['name'] ?? 'Meal';
          final desc = data['description'] ?? '';
          final price = data['price']?.toString() ?? '';

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Browse the menu, then',
                        style: TextStyle(
                          color: AppColors.textFieldBorderColor,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        'Order Now',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 41.h),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.credit_card,
                            size: 18.w,
                            color: AppColors.primaryColor,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            "$price \$",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Divider(color: AppColors.textFieldBorderColor),

                      SizedBox(height: 16.h),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 24.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 55.r,
                              child: Base64ImageHelper.fromBase64(
                                imageData,
                                width: double.infinity,
                                height: 260.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              name,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16.sp,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              desc,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            SizedBox(height: 18.h),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    FontAwesomeIcons.whatsapp,
                                    color: Colors.green,
                                  ),
                                  onPressed: () {
                                    if (whatsapp.isNotEmpty) {
                                      controller.launchUrll(
                                        "https://wa.me/$whatsapp",
                                      );
                                    }
                                  },
                                ),
                                SizedBox(width: 20.w),

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
                                SizedBox(width: 20.w),

                                IconButton(
                                  icon: const Icon(
                                    FontAwesomeIcons.instagram,
                                    color: Colors.pinkAccent,
                                  ),
                                  onPressed: () {
                                    if (insta.isNotEmpty) {
                                      controller.launchUrll(
                                        "https://instagram.com/$insta",
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showRatingDialog(
    BuildContext context,
    MealDetailsController controller,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: const Text("Rate this meal 🍽️"),
        content: _RatingStarsWidget(
          onSubmit: (value) async {
            await controller.submitRating(userId: "demoUser123", stars: value);
            Get.back();
            Get.snackbar(
              "Thank you!",
              "Your rating has been submitted",
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
          },
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 40.w),
              SizedBox(height: 8.h),
              Text(
                "Thank you for rating!",
                style: TextStyle(fontSize: 15.sp, color: Colors.grey[700]),
              ),
            ],
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < selected ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 34.w,
                    ),
                    onPressed: () => setState(() => selected = index + 1),
                  );
                }),
              ),
              ElevatedButton(
                onPressed: selected == 0
                    ? null
                    : () async {
                        await widget.onSubmit(selected);
                        setState(() => submitted = true);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.h,
                  ),
                ),
                child: const Text("Submit Rating"),
              ),
            ],
          );
  }
}
