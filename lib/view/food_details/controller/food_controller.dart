import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class RestaurantDetailsController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String accountId;

  Map<String, dynamic>? data;
  bool loading = true;

  RestaurantDetailsController(this.accountId);

  Future<void> loadRestaurant() async {
    final doc = await _db.collection('foodAccounts').doc(accountId).get();
    data = doc.data();
    loading = false;
    update();
  }

  Stream<QuerySnapshot> streamMeals() {
    return _db
        .collection('foodAccounts')
        .doc(accountId)
        .collection('meals')
        .orderBy('rating', descending: true)
        .snapshots();
  }

  Future<void> submitRestaurantRating({
    required String userId,
    required int stars,
  }) async {
    final restRef = _db.collection('foodAccounts').doc(accountId);

    await _db.runTransaction((tx) async {
      final snap = await tx.get(restRef);
      if (!snap.exists) throw Exception("Restaurant not found");

      final ratingSum = (snap.data()?['ratingSum'] ?? 0) as num;
      final ratingCount = (snap.data()?['ratingCount'] ?? 0) as num;

      final newSum = ratingSum + stars;
      final newCount = ratingCount + 1;
      final avg = newSum / newCount;

      tx.update(restRef, {
        'ratingSum': newSum,
        'ratingCount': newCount,
        'rating': avg,
      });
    });

    Get.snackbar(
      "Thanks!",
      "Your rating has been submitted.",
      backgroundColor: Colors.green.withOpacity(0.8),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );

    await loadRestaurant();
  }

  Future<void> launchUrll(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        "Error",
        "Could not launch $url",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
      );
    }
  }

  @override
  void onInit() {
    loadRestaurant();
    super.onInit();
  }
}
