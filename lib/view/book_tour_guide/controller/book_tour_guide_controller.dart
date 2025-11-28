import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/tour_guide_model.dart';

class BookTourGuideController extends GetxController {
  final CollectionReference _guidesCol = FirebaseFirestore.instance.collection(
    'TourGuide',
  );
  final CollectionReference _bookingsCol = FirebaseFirestore.instance
      .collection('bookings');

  final RxList<TourGuideModel> guides = <TourGuideModel>[].obs;
  final RxList<TourGuideModel> filtered = <TourGuideModel>[].obs;
  final RxBool loading = false.obs;
  final TextEditingController searchCtrl = TextEditingController();
  @override
  void onInit() {
    super.onInit();
    _listenGuides();
  }

  void _listenGuides() {
    loading.value = true;
    _guidesCol
        .where('isApproved', isEqualTo: true)
        .snapshots()
        .listen(
          (snap) {
            final list = snap.docs
                .map((d) => TourGuideModel.fromDoc(d))
                .toList();
            guides.assignAll(list);
            filtered.assignAll(list);
            loading.value = false;
          },
          onError: (e) {
            loading.value = false;
            debugPrint('Guides listen error: $e');
          },
        );
  }

  void search(String q) {
    if (q.trim().isEmpty) {
      filtered.assignAll(guides);
      return;
    }
    final s = q.toLowerCase();
    filtered.assignAll(
      guides.where(
        (g) =>
            g.name.toLowerCase().contains(s) ||
            g.country.toLowerCase().contains(s) ||
            g.languages.join(' ').toLowerCase().contains(s),
      ),
    );
  }

  /// Create booking doc in Firestore
  /// bookingData fields:
  /// - touristId (String)
  /// - siteId (String)
  /// - guideId (String?) -> null or 'AI' for AI guide
  /// - guideType: 'ai' or 'human'
  /// - startAt (Timestamp) optional
  /// - status: 'pending' | 'confirmed' | 'cancelled'
  Future<void> createBooking({
    required String touristId,
    required String siteId,
    String? guideId,
    required String guideType, // 'ai' or 'human'
    DateTime? startAt,
    Map<String, dynamic>? extras,
  }) async {
    try {
      final doc = {
        'touristId': touristId,
        'siteId': siteId,
        'guideId': guideId ?? null,
        'guideType': guideType,
        'startAt': startAt != null ? Timestamp.fromDate(startAt) : null,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'extras': extras ?? {},
      };

      await _bookingsCol.add(doc);
      Get.snackbar(
        'Booked',
        'Booking created successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create booking: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
