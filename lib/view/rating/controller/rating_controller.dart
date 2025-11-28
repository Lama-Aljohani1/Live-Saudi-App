import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class RatingController extends GetxController {
  final CollectionReference _sites = FirebaseFirestore.instance.collection('HeritageSites');

  Future<void> submitReview({
    required String siteId,
    required String username,
    required String comment,
    required double stars,
  }) async {
    final docRef = _sites.doc(siteId);
    final doc = await docRef.get();
    if (!doc.exists) {
      Get.snackbar('Error', 'Site not found');
      return;
    }
    final data = doc.data() as Map<String, dynamic>? ?? {};
    final List reviews = List.from(data['reviews'] ?? []);
    reviews.add({
      'username': username,
      'comment': comment,
      'stars': stars,
      'createdAt': DateTime.now().toIso8601String(),
    });

    double avg = 0;
    if (reviews.isNotEmpty) {
      double total = 0;
      for (var r in reviews) {
        total += (r['stars'] ?? 0);
      }
      avg = total / reviews.length;
    }

    await docRef.update({'reviews': reviews, 'rating': avg});
    Get.snackbar('Thanks', 'Your review was submitted', snackPosition: SnackPosition.BOTTOM);
  }
}
