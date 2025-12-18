import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class MealDetailsController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String accountId;
  final String mealId;

  bool loading = true;
  Map<String, dynamic>? mealData;

  MealDetailsController({required this.accountId, required this.mealId});

  Future<void> loadMeal() async {
    final doc = await _db
        .collection('foodAccounts')
        .doc(accountId)
        .collection('meals')
        .doc(mealId)
        .get();

    mealData = doc.data();
    loading = false;
    update();
  }

  Future<void> submitRating({
    required String userId,
    required int stars,
  }) async {
    final mealRef = _db
        .collection('foodAccounts')
        .doc(accountId)
        .collection('meals')
        .doc(mealId);

    await _db.runTransaction((tx) async {
      final snap = await tx.get(mealRef);
      if (!snap.exists) throw Exception("Meal not found");

      final ratingSum = (snap.data()?['ratingSum'] ?? 0) as num;
      final ratingCount = (snap.data()?['ratingCount'] ?? 0) as num;

      final newSum = ratingSum + stars;
      final newCount = ratingCount + 1;
      final avg = newSum / newCount;

      tx.update(mealRef, {
        'ratingSum': newSum,
        'ratingCount': newCount,
        'rating': avg,
      });
    });

    Get.snackbar(
      "Thanks!",
      "Your rating has been submitted.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.8),
      colorText: Colors.white,
    );

    await loadMeal();
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
    loadMeal();
    super.onInit();
  }
}
