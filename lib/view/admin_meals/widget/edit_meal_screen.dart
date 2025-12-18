import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/const_data/app_colors.dart';
import '../../../widgets/custome_button.dart';

class EditMealScreen extends StatefulWidget {
  final String restaurantId;
  final String mealId;

  const EditMealScreen({
    super.key,
    required this.restaurantId,
    required this.mealId,
  });

  @override
  State<EditMealScreen> createState() => _EditMealScreenState();
}

class _EditMealScreenState extends State<EditMealScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _desc = TextEditingController();
  final _price = TextEditingController();
  final _ingredients = TextEditingController();

  String? _imageBase64;
  bool _loading = false;
  bool _initializing = true;

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

  @override
  void initState() {
    super.initState();
    _loadMeal();
  }

  Future<void> _loadMeal() async {
    final doc = await FirebaseFirestore.instance
        .collection('foodAccounts')
        .doc(widget.restaurantId)
        .collection('meals')
        .doc(widget.mealId)
        .get();

    final data = doc.data();
    if (data != null) {
      _name.text = data['name'] ?? '';
      _desc.text = data['description'] ?? '';
      _price.text = (data['price'] ?? '').toString();
      _ingredients.text = (data['ingredients'] as List?)?.join(', ') ?? '';
      _imageBase64 = data['imageBase64'];
      _selectedCategory = data['category'] ?? 'Appetizer';
      _selectedSubCategory = data['subCategory'] ?? 'Popular';
    }

    setState(() => _initializing = false);
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    final bytes = await File(picked.path).readAsBytes();
    setState(() => _imageBase64 = base64Encode(bytes));
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    await FirebaseFirestore.instance
        .collection('foodAccounts')
        .doc(widget.restaurantId)
        .collection('meals')
        .doc(widget.mealId)
        .update({
          'name': _name.text.trim(),
          'description': _desc.text.trim(),
          'price': double.tryParse(_price.text) ?? 0.0,
          'ingredients': _ingredients.text
              .split(',')
              .map((e) => e.trim())
              .toList(),
          'category': _selectedCategory,
          'subCategory': _selectedSubCategory,
          'imageBase64': _imageBase64,
          'updatedAt': FieldValue.serverTimestamp(),
        });

    setState(() => _loading = false);
    Get.back();
    Get.snackbar(
      'Updated',
      'Meal updated successfully',
      backgroundColor: Colors.green[50],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_initializing) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Meal'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
          color: AppColors.primaryColor,
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: AppColors.primaryColor),
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
                              'Tap to upload image',
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
              SizedBox(height: 20.h),
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
                decoration: _decoration('Category'),
                onChanged: (v) => setState(() => _selectedCategory = v!),
                items: _categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
              ),
              SizedBox(height: 12.h),
              DropdownButtonFormField<String>(
                value: _selectedSubCategory,
                decoration: _decoration('Sub-Category'),
                onChanged: (v) => setState(() => _selectedSubCategory = v!),
                items: _subCategories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
              ),
              SizedBox(height: 32.h),

              CustomeButton(
                buttonHight: 44.h,
                borderColor: AppColors.primaryColor,
                onPressed: _loading ? null : _saveChanges,
                text: 'Save Changes',
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
