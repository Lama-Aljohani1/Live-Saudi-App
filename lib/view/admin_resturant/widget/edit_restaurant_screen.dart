import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/const_data/app_colors.dart';
import '../../../widgets/custome_button.dart';
import '../../select_location/screen/select_location_screen.dart';

class EditRestaurantScreen extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> initialData;

  const EditRestaurantScreen({
    super.key,
    required this.docId,
    required this.initialData,
  });

  @override
  State<EditRestaurantScreen> createState() => _EditRestaurantScreenState();
}

class _EditRestaurantScreenState extends State<EditRestaurantScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _location = TextEditingController();
  final _desc = TextEditingController();
  final _phone = TextEditingController();
  final _whatsapp = TextEditingController();
  final _instagram = TextEditingController();

  File? _image;
  String? _imageBase64;
  bool _loading = false;
  bool _verified = false;
  double? _lat;
  double? _lng;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _name.text = widget.initialData['name'] ?? '';
    _location.text = widget.initialData['location'] ?? '';
    _desc.text = widget.initialData['shortDesc'] ?? '';
    _verified = widget.initialData['verified'] ?? false;
    _imageBase64 = widget.initialData['imageBase64'];
    _lat = widget.initialData['locationLat']?.toDouble();
    _lng = widget.initialData['locationLng']?.toDouble();
    _phone.text = widget.initialData['phone'] ?? '';
    _whatsapp.text = widget.initialData['whatsapp'] ?? '';
    _instagram.text = widget.initialData['instagram'] ?? '';
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final bytes = await File(picked.path).readAsBytes();
      setState(() {
        _image = File(picked.path);
        _imageBase64 = base64Encode(bytes);
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

  Future<void> _updateRestaurant() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    await FirebaseFirestore.instance
        .collection('foodAccounts')
        .doc(widget.docId)
        .update({
          'name': _name.text.trim(),
          'location': _location.text.trim(),
          'locationLat': _lat,
          'locationLng': _lng,
          'shortDesc': _desc.text.trim(),
          'imageBase64': _imageBase64,
          'verified': _verified,
          'updatedAt': FieldValue.serverTimestamp(),
        });

    setState(() => _loading = false);
    Get.back();
    Get.snackbar(
      'Success',
      'Restaurant updated successfully!',
      backgroundColor: Colors.green[50],
    );
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

  @override
  Widget build(BuildContext context) {
    final hasLocation = _lat != null && _lng != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Edit Restaurant'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.primaryColor,
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: AppColors.primaryColor),
      ),
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
                  height: 160.h,
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
                            height: 160.h,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 16.h),

              TextFormField(
                controller: _name,
                decoration: _inputDecoration('Restaurant Name'),
                validator: (v) =>
                    v!.isEmpty ? 'Please enter restaurant name' : null,
              ),
              SizedBox(height: 12.h),

              TextFormField(
                controller: _location,
                readOnly: true,
                onTap: _pickLocation,
                decoration: _inputDecoration(
                  'Location (Pick from map)',
                ).copyWith(suffixIcon: const Icon(Icons.map_outlined)),
                validator: (v) =>
                    v!.isEmpty ? 'Please pick restaurant location' : null,
              ),
              SizedBox(height: 12.h),

              if (hasLocation)
                Column(
                  children: [
                    Container(
                      height: 180.h,
                      margin: EdgeInsets.only(bottom: 8.h),
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
                          onTap: (_) => _pickLocation(),
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

              SizedBox(height: 12.h),

              TextFormField(
                controller: _desc,
                decoration: _inputDecoration('Short Description'),
                maxLines: 3,
                validator: (v) =>
                    v!.isEmpty ? 'Please enter short description' : null,
              ),
              SizedBox(height: 14.h),
              TextFormField(
                controller: _phone,
                decoration: _inputDecoration('Phone Number'),
                validator: (v) =>
                    v!.isEmpty ? 'Please enter phone number' : null,
              ),
              SizedBox(height: 14.h),
              TextFormField(
                controller: _whatsapp,
                decoration: _inputDecoration('WhatsApp Number'),
                validator: (v) =>
                    v!.isEmpty ? 'Please enter WhatsApp number' : null,
              ),
              SizedBox(height: 14.h),
              TextFormField(
                controller: _instagram,
                decoration: _inputDecoration('Instagram Username'),
                validator: (v) =>
                    v!.isEmpty ? 'Please enter Instagram username' : null,
              ),

              SizedBox(height: 32.h),

              CustomeButton(
                buttonHight: 44.h,
                borderColor: AppColors.primaryColor,
                onPressed: _loading ? null : _updateRestaurant,
                text: 'Update Restaurant',
                backgroundColor: AppColors.primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: Colors.grey[600],
        fontWeight: FontWeight.w400,
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: AppColors.primaryColor),
      ),
    );
  }
}
