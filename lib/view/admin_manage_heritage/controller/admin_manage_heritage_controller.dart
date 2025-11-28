import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/heritage_model.dart';
import '../../select_location/screen/select_location_screen.dart'; // أو MapPickerScreen import path

class AdminManageHeritageController extends GetxController {
  final picker = ImagePicker();

  // form controllers
  final name = TextEditingController();
  final region = TextEditingController();
  final description = TextEditingController();
  final price = TextEditingController();
  final rating = TextEditingController();
  final RxString selectedCategory = 'popular'.obs;
  final RxList<Map<String, dynamic>> currentReviews = <Map<String, dynamic>>[].obs;

  final TextEditingController reviewName = TextEditingController();
  final TextEditingController reviewComment = TextEditingController();
  final RxDouble reviewStars = 0.0.obs;


  final RxList<XFile> pickedImages = <XFile>[].obs;
  LatLng? selectedLocation;
  final RxList<HeritageModel> heritageSites = <HeritageModel>[].obs;

  final CollectionReference _col =
  FirebaseFirestore.instance.collection('HeritageSites');

  @override
  void onInit() {
    super.onInit();
    loadSites();
  }

  @override
  void onClose() {
    name.dispose();
    region.dispose();
    description.dispose();
    price.dispose();
    rating.dispose();
    super.onClose();
  }

  Future<void> pickImages() async {
    try {
      final List<XFile>? imgs = await picker.pickMultiImage(imageQuality: 75);
      if (imgs != null && imgs.isNotEmpty) pickedImages.addAll(imgs);
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick images: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  void removePickedImage(int index) {
    if (index >= 0 && index < pickedImages.length) pickedImages.removeAt(index);
  }

  Future<void> selectLocationFromMap() async {
    final LatLng? picked = await Get.to(() => const MapPickerScreen()); // تأكد من import path
    if (picked != null) {
      selectedLocation = picked;
      Get.snackbar('Location selected',
          'Lat: ${picked.latitude.toStringAsFixed(4)}, Lng: ${picked.longitude.toStringAsFixed(4)}',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<List<String>> _imagesToBase64() async {
    final List<String> base64List = [];
    for (final x in pickedImages) {
      final bytes = await x.readAsBytes();
      base64List.add(base64Encode(bytes));
    }
    return base64List;
  }

  bool _validateForm() {
    if (name.text.trim().isEmpty ||
        region.text.trim().isEmpty ||
        description.text.trim().isEmpty ||
        price.text.trim().isEmpty ||
        selectedLocation == null ||
        pickedImages.isEmpty) {
      Get.snackbar('Missing data', 'Please fill all fields and pick images', snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    return true;
  }

  void _clearForm() {
    name.clear();
    region.clear();
    description.clear();
    price.clear();
    rating.clear();
    pickedImages.clear();
    selectedLocation = null;
  }

  Future<void> addSite() async {
    if (!_validateForm()) return;
    try {
      final imgs = await _imagesToBase64();
      final doc = {
        'name': name.text.trim(),
        'region': region.text.trim(),
        'description': description.text.trim(),
        'latitude': selectedLocation!.latitude,
        'longitude': selectedLocation!.longitude,
        'images': imgs,
        'pricePerPerson': double.tryParse(price.text) ?? 0,
        'rating': double.tryParse(rating.text) ?? 0,
        'category': selectedCategory.value, // ✅ هنا أضفنا الفئة
        'reviews': <Map<String, dynamic>>[],
        'createdAt': FieldValue.serverTimestamp(),
      };

      final docRef = await _col.add(doc);
      final snap = await docRef.get();
      heritageSites.insert(0, HeritageModel.fromDoc(snap));
      _clearForm();
      Get.back();
      Get.snackbar('Success', 'Heritage site added', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to add site: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> updateSite(String id, {required HeritageModel oldSite}) async {
    try {
      // نحول الصور الجديدة إن وُجدت
      final imgs = await _imagesToBase64();

      // تجهيز البيانات للتحديث — فقط اللي تغيّر
      final updatedData = {
        'name': name.text.trim().isEmpty ? oldSite.name : name.text.trim(),
        'region': region.text.trim().isEmpty ? oldSite.region : region.text.trim(),
        'description': description.text.trim().isEmpty ? oldSite.description : description.text.trim(),
        'latitude': selectedLocation?.latitude ?? oldSite.latitude,
        'longitude': selectedLocation?.longitude ?? oldSite.longitude,
        'images': imgs.isNotEmpty ? imgs : oldSite.imagesBase64,
        'pricePerPerson': price.text.trim().isEmpty
            ? oldSite.pricePerPerson
            : double.tryParse(price.text) ?? oldSite.pricePerPerson,
        'rating': rating.text.trim().isEmpty
            ? oldSite.rating
            : double.tryParse(rating.text) ?? oldSite.rating,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _col.doc(id).set(updatedData, SetOptions(merge: true));

      await loadSites();
      _clearForm();
      Get.back();
      Get.snackbar('Updated', 'Site updated successfully', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }


  Future<void> deleteSite(HeritageModel site) async {
    try {
      await _col.doc(site.id).delete();
      heritageSites.removeWhere((s) => s.id == site.id);
      Get.snackbar('Deleted', 'Site removed', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> loadSites() async {
    try {
      final snap = await _col.orderBy('createdAt', descending: true).get();
      final list = snap.docs.map((d) => HeritageModel.fromDoc(d)).toList();
      heritageSites.assignAll(list);
    } catch (e) {
      debugPrint('Error loadSites: $e');
    }
  }
  void loadReviews(String siteId) async {
    final doc = await FirebaseFirestore.instance.collection('heritage_sites').doc(siteId).get();
    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      currentReviews.value = List<Map<String, dynamic>>.from(data['reviews'] ?? []);
    }
  }

  Future<void> addReview(String siteId) async {
    if (reviewName.text.isEmpty || reviewStars.value == 0) {
      Get.snackbar('Error', 'Please fill name and stars');
      return;
    }

    final newReview = {
      'username': reviewName.text.trim(),
      'comment': reviewComment.text.trim(),
      'stars': reviewStars.value,
      'createdAt': DateTime.now().toIso8601String(),
    };

    // أضف التقييم للمصفوفة الحالية
    currentReviews.add(newReview);

    // ✅ حساب متوسط التقييمات الجديد
    double avgRating = 0;
    if (currentReviews.isNotEmpty) {
      double total = currentReviews.fold(0, (sum, r) => sum + (r['stars'] ?? 0));
      avgRating = total / currentReviews.length;
    }

    // ✅ تحديث Firestore
    await FirebaseFirestore.instance.collection('heritage_sites').doc(siteId).update({
      'reviews': currentReviews,
      'rating': avgRating, // تحديث المتوسط
    });

    // ✅ تنظيف الحقول بعد الإضافة
    reviewName.clear();
    reviewComment.clear();
    reviewStars.value = 0;

    Get.snackbar('Success', 'Review added successfully!',
        snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green.shade50);
  }


  Future<void> deleteReview(String siteId, int index) async {
    currentReviews.removeAt(index);

    double avgRating = 0;
    if (currentReviews.isNotEmpty) {
      double total = currentReviews.fold(0, (sum, r) => sum + (r['stars'] ?? 0));
      avgRating = total / currentReviews.length;
    }

    await FirebaseFirestore.instance.collection('heritage_sites').doc(siteId).update({
      'reviews': currentReviews,
      'rating': avgRating,
    });

    Get.snackbar('Deleted', 'Review removed successfully',
        snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red.shade50);
  }

}
