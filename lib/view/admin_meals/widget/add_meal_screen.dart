import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/const_data/app_colors.dart';
import '../../../widgets/custome_button.dart';

class AddMealScreen extends StatefulWidget {
  final String restaurantId;

  const AddMealScreen({super.key, required this.restaurantId});

  @override
  State<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _desc = TextEditingController();
  final _price = TextEditingController();
  final _ingredients = TextEditingController();

  String? _imageBase64;
  bool _loading = false;
  String _selectedCategory = 'Appetizer';
  String _selectedSubCategory = 'Popular';

  final List<String> _categories = [
    'Appetizer',
    'Main Dish',
    'Desserts',
    'Drinks',
  ];

  final List<String> _subCategories = [
    'Popular',
    'Spicy',
    'Vegetarian',
    'Vegan',
    'New',
  ];

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    final bytes = await File(picked.path).readAsBytes();
    setState(() => _imageBase64 = base64Encode(bytes));
  }

  Future<void> _saveMeal() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    await FirebaseFirestore.instance
        .collection('foodAccounts')
        .doc(widget.restaurantId)
        .collection('meals')
        .add({
          'name': _name.text.trim(),
          'description': _desc.text.trim(),
          'price': double.tryParse(_price.text) ?? 0.0,
          'ingredients': _ingredients.text
              .split(',')
              .map((e) => e.trim())
              .toList(),
          'category': _selectedCategory,
          'subCategory': _selectedSubCategory,
          'rating': 0.0,
          'imageBase64': _imageBase64,
          'createdAt': FieldValue.serverTimestamp(),
        });

    setState(() => _loading = false);
    Get.back();
    Get.snackbar(
      'Success',
      'Meal added successfully!',
      backgroundColor: Colors.green[50],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Meal'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: AppColors.primaryColor,
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 150.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    color: Colors.grey[100],
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: _imageBase64 == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo,
                              size: 36.w,
                              color: AppColors.primaryColor,
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Add Meal Image',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(16.r),
                          child: Image.memory(
                            base64Decode(_imageBase64!),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 150.h,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 16.h),
              _buildTextField(_name, 'Meal Name'),
              SizedBox(height: 12.h),
              _buildTextField(
                _price,
                'Price (SAR)',
                type: TextInputType.number,
              ),
              SizedBox(height: 12.h),
              _buildTextField(_desc, 'Description', maxLines: 3),
              SizedBox(height: 12.h),
              _buildTextField(
                _ingredients,
                'Ingredients (comma separated)',
                maxLines: 2,
              ),
              SizedBox(height: 12.h),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedCategory = v!),
                decoration: _decoration('Category'),
              ),
              SizedBox(height: 12.h),
              DropdownButtonFormField<String>(
                value: _selectedSubCategory,
                items: _subCategories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedSubCategory = v!),
                decoration: _decoration('Sub-Category'),
              ),
              SizedBox(height: 32.h),

              CustomeButton(
                buttonHight: 44.h,
                borderColor: AppColors.primaryColor,
                onPressed: _loading ? null : _saveMeal,
                text: 'Add Meal',
                backgroundColor: AppColors.primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType type = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      maxLines: maxLines,
      validator: (v) => v!.isEmpty ? 'Please enter $label' : null,
      decoration: _decoration(label),
    );
  }

  InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primaryColor),
      ),
    );
  }
}
