import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live_saudi/core/const_data/text_style.dart';
import '../../../core/const_data/app_colors.dart';
import '../../admin_meals/screen/admin_meals_screen.dart';
import '../../food/controller/food_list_controller.dart';
import '../widget/add_restaurant_screen.dart';
import '../widget/edit_restaurant_screen.dart';

class AdminRestaurantScreen extends StatelessWidget {
  const AdminRestaurantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FoodListController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Manage Restaurants",
          style: TextStyle(
            color: AppColors.primaryColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primaryColor,
        onPressed: () => Get.to(() => const AddRestaurantScreen()),
        icon: const Icon(Icons.add, color: AppColors.white),
        label: Text("Add Restaurant", style: FontStyles.buttonTextStyle),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: StreamBuilder<QuerySnapshot>(
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
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                ),
              );
            }

            return ListView.separated(
              itemCount: docs.length,
              separatorBuilder: (_, __) => SizedBox(height: 16.h),
              itemBuilder: (context, index) {
                final data = docs[index].data() as Map<String, dynamic>;
                final imageBase64 = data['imageBase64'] ?? '';
                final imageWidget = imageBase64.isNotEmpty
                    ? Image.memory(
                        base64Decode(imageBase64),
                        width: 100.w,
                        height: 100.w,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 100.w,
                        height: 100.w,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image_not_supported),
                      );

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.r),
                          bottomLeft: Radius.circular(16.r),
                        ),
                        child: imageWidget,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 10.h,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['name'] ?? 'Unnamed',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    color: Colors.grey[600],
                                    size: 16.w,
                                  ),
                                  SizedBox(width: 4.w),
                                  Expanded(
                                    child: Text(
                                      data['location'] ?? 'Unknown',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: Colors.grey[600],
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: Column(
                          children: [
                            IconButton(
                              tooltip: 'Edit',
                              onPressed: () {
                                Get.to(
                                  () => EditRestaurantScreen(
                                    docId: docs[index].id,
                                    initialData: data,
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.edit_rounded,
                                color: Colors.green,
                                size: 24,
                              ),
                            ),
                            IconButton(
                              tooltip: 'Meals',
                              onPressed: () {
                                Get.to(
                                  () => AdminMealsScreen(
                                    restaurantId: docs[index].id,
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.fastfood_outlined,
                                color: Colors.blue,
                                size: 24,
                              ),
                            ),
                            IconButton(
                              tooltip: 'Delete',
                              onPressed: () async {
                                final confirm = await showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('Delete Restaurant'),
                                    content: const Text(
                                      'Are you sure you want to delete this restaurant?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: const Text(
                                          'Delete',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirm == true) {
                                  await FirebaseFirestore.instance
                                      .collection('foodAccounts')
                                      .doc(docs[index].id)
                                      .delete();
                                  Get.snackbar(
                                    'Deleted',
                                    'Restaurant removed',
                                    backgroundColor: Colors.red[50],
                                    colorText: Colors.red,
                                  );
                                }
                              },
                              icon: const Icon(
                                Icons.delete_outline_rounded,
                                color: Colors.red,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
