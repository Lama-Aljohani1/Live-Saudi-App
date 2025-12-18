import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:live_saudi/widgets/custome_button.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/const_data/app_colors.dart';
import '../../admin_meals/widget/add_meal_screen.dart';
import '../../select_location/screen/select_location_screen.dart';

class AddRestaurantScreen extends StatefulWidget {
  const AddRestaurantScreen({super.key});

  @override
  State<AddRestaurantScreen> createState() => _AddRestaurantScreenState();
}

class _AddRestaurantScreenState extends State<AddRestaurantScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _location = TextEditingController();
  final _desc = TextEditingController();
  final _phone = TextEditingController();
  final _whatsapp = TextEditingController();
  final _instagram = TextEditingController();

  File? _image;
  bool _loading = false;
  bool _verified = false;
  String? _base64Image;
  double? _lat;
  double? _lng;
  GoogleMapController? _mapController;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final bytes = await File(picked.path).readAsBytes();
      setState(() {
        _image = File(picked.path);
        _base64Image = base64Encode(bytes);
      });
    }
  }

  Future<void> _pickLocation() async {
    final Map<String, dynamic>? result = await Get.to(
      () => const MapPickerScreen(),
    );
    if (result != null) {
      setState(() {
        _lat = result['lat'];
        _lng = result['lng'];
        _location.text =
            result['address'] ??
            '(${_lat!.toStringAsFixed(4)}, ${_lng!.toStringAsFixed(4)})';
      });
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(LatLng(_lat!, _lng!)),
      );
    }
  }

  Future<void> _openInGoogleMaps() async {
    if (_lat == null || _lng == null) return;
    final url = 'https://www.google.com/maps/search/?api=1&query=$_lat,$_lng';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        'Error',
        'Could not open Google Maps',
        backgroundColor: Colors.red[50],
        colorText: Colors.red,
      );
    }
  }

  Future<void> _uploadRestaurant() async {
    if (!_formKey.currentState!.validate()) return;

    if (_base64Image == null) {
      Get.snackbar(
        'Image Required',
        'Please select a restaurant image.',
        backgroundColor: Colors.red[50],
        colorText: Colors.red,
      );
      return;
    }

    if (_lat == null || _lng == null) {
      Get.snackbar(
        'Location Required',
        'Please pick a restaurant location.',
        backgroundColor: Colors.red[50],
        colorText: Colors.red,
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final docRef = await FirebaseFirestore.instance
          .collection('foodAccounts')
          .add({
            'name': _name.text.trim(),
            'location': _location.text.trim(),
            'locationLat': _lat,
            'locationLng': _lng,
            'shortDesc': _desc.text.trim(),
            'imageBase64': _base64Image,
            'verified': _verified,
            'rating': 0.0,
            'phone': _phone.text.trim(),
            'whatsapp': _whatsapp.text.trim(),
            'instagram': _instagram.text.trim(),
            'createdAt': FieldValue.serverTimestamp(),
          });

      final restaurantId = docRef.id;
      setState(() => _loading = false);

      Get.off(() => AddMealScreen(restaurantId: restaurantId));

      Get.snackbar(
        'Success',
        'Restaurant added successfully!',
        backgroundColor: Colors.green[50],
        colorText: Colors.green[800],
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      setState(() => _loading = false);
      Get.snackbar(
        'Error',
        'Failed to add restaurant: $e',
        backgroundColor: Colors.red[50],
        colorText: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasLocation = _lat != null && _lng != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Add Restaurant'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 18.sp,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: double.infinity,
                  height: 180.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18.r),
                    color: Colors.grey[100],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: _image == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo_outlined,
                              color: AppColors.primaryColor,
                              size: 36.w,
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              "Tap to upload image",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13.sp,
                              ),
                            ),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(18.r),
                          child: Image.file(_image!, fit: BoxFit.cover),
                        ),
                ),
              ),
              SizedBox(height: 20.h),

              _buildTextField(_name, 'Restaurant Name', Icons.restaurant),
              SizedBox(height: 14.h),

              TextFormField(
                controller: _location,
                readOnly: true,
                onTap: _pickLocation,
                validator: (v) =>
                    v!.isEmpty ? "Please pick restaurant location" : null,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.location_on,
                    color: AppColors.primaryColor,
                  ),
                  labelText: 'Location (Pick from map)',
                  suffixIcon: const Icon(Icons.map_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: AppColors.primaryColor),
                  ),
                ),
              ),

              if (hasLocation)
                Column(
                  children: [
                    SizedBox(height: 14.h),
                    Container(
                      height: 180.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(_lat!, _lng!),
                            zoom: 14,
                          ),
                          markers: {
                            Marker(
                              markerId: const MarkerId('restaurant'),
                              position: LatLng(_lat!, _lng!),
                            ),
                          },
                          onMapCreated: (c) => _mapController = c,
                          myLocationButtonEnabled: false,
                          zoomControlsEnabled: false,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: _openInGoogleMaps,
                        icon: const Icon(
                          Icons.directions_outlined,
                          color: Colors.blue,
                        ),
                        label: const Text(
                          'عرض في خرائط Google',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                  ],
                ),

              SizedBox(height: 14.h),
              _buildTextField(
                _desc,
                'Short Description',
                Icons.text_snippet,
                maxLines: 3,
              ),
              SizedBox(height: 14.h),
              _buildTextField(_phone, 'Phone Number', Icons.phone, maxLines: 1),
              SizedBox(height: 14.h),
              _buildTextField(
                _whatsapp,
                'WhatsApp Number',
                FontAwesomeIcons.whatsapp,
                maxLines: 1,
              ),
              SizedBox(height: 14.h),
              _buildTextField(
                _instagram,
                'Instagram Username',
                FontAwesomeIcons.instagram,
                maxLines: 1,
              ),

              SizedBox(height: 32.h),

              CustomeButton(
                buttonHight: 44.h,
                borderColor: AppColors.primaryColor,
                onPressed: _loading ? null : _uploadRestaurant,
                text: "Add Restaurant",
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
    String label,
    IconData icon, {
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: (v) => v!.isEmpty ? "Please enter $label" : null,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.primaryColor),
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }
}
