import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/const_data/app_colors.dart';
import '../../../core/const_data/text_style.dart' show FontStyles;
import '../widget/add_meal_screen.dart';
import '../widget/edit_meal_screen.dart';

class AdminMealsScreen extends StatefulWidget {
  final String restaurantId;

  const AdminMealsScreen({super.key, required this.restaurantId});

  @override
  State<AdminMealsScreen> createState() => _AdminMealsScreenState();
}

class _AdminMealsScreenState extends State<AdminMealsScreen> {
  String selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'Appetizer',
    'Main Dish',
    'Desserts',
    'Drinks',
  ];

  @override
  Widget build(BuildContext context) {
    final query = selectedCategory == 'All'
        ? FirebaseFirestore.instance
              .collection('foodAccounts')
              .doc(widget.restaurantId)
              .collection('meals')
        : FirebaseFirestore.instance
              .collection('foodAccounts')
              .doc(widget.restaurantId)
              .collection('meals')
              .where('category', isEqualTo: selectedCategory);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Meals"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: AppColors.primaryColor,
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primaryColor,
        onPressed: () =>
            Get.to(() => AddMealScreen(restaurantId: widget.restaurantId)),
        icon: const Icon(Icons.add, color: AppColors.white),
        label: Text("Add Meal", style: FontStyles.buttonTextStyle),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12.w),
            child: DropdownButtonFormField<String>(
              value: selectedCategory,
              onChanged: (v) => setState(() => selectedCategory = v!),
              decoration: InputDecoration(
                labelText: 'Filter by Category',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: _categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: query.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final meals = snapshot.data!.docs;
                if (meals.isEmpty) {
                  return Center(
                    child: Text(
                      'No meals found',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14.sp,
                      ),
                    ),
                  );
                }

                return GridView.builder(
                  padding: EdgeInsets.all(16.w),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: meals.length,
                  itemBuilder: (context, index) {
                    final meal = meals[index].data() as Map<String, dynamic>;
                    final id = meals[index].id;

                    return GestureDetector(
                      onTap: () {
                        Get.to(
                          () => EditMealScreen(
                            restaurantId: widget.restaurantId,
                            mealId: id,
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16.r),
                                ),
                                child: meal['imageBase64'] != null
                                    ? Image.memory(
                                        base64Decode(meal['imageBase64']),
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        color: Colors.grey[200],
                                        child: const Icon(Icons.fastfood),
                                      ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    meal['name'] ?? 'Unnamed Meal',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    '${meal['price'] ?? 0} SAR',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 13.sp,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 16,
                                      ),
                                      Text(
                                        '${meal['rating'] ?? 0.0}',
                                        style: TextStyle(fontSize: 12.sp),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
