import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/guide_request_model.dart';

class AdminApproveGuidesController extends GetxController {
  var pendingGuides = <GuideRequestModel>[].obs;
  final _db = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    listenToPendingGuides();
  }

  /// 🔹 جلب الأدلاء بانتظار الموافقة
  void listenToPendingGuides() {
    _db
        .collection("PendingGuides")
        .snapshots()
        .listen((snapshot) {
      final guides = snapshot.docs
          .map((doc) => GuideRequestModel.fromFirestore(doc.data(), doc.id))
          .toList();
      pendingGuides.assignAll(guides);
    });
  }

  /// ✅ الموافقة على الدليل
  Future<void> approveGuide(String id) async {
    try {
      final doc = await _db.collection("PendingGuides").doc(id).get();

      if (!doc.exists) return;

      final data = doc.data()!;
      // أضف الدليل إلى مجموعة TourGuide الرسمية
      await _db.collection("TourGuide").doc(id).set({
        ...data,
        "isApproved": true,
        "approvedAt": FieldValue.serverTimestamp(),
      });

      // ثم احذف الطلب من مجموعة PendingGuides
      await _db.collection("PendingGuides").doc(id).delete();

      Get.snackbar(
        "Approved",
        "Guide has been approved successfully ✅",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to approve guide: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFFEAEA),
      );
    }
  }

  /// ❌ رفض الدليل
  Future<void> rejectGuide(String id) async {
    try {
      await _db.collection("PendingGuides").doc(id).delete();
      Get.snackbar(
        "Rejected",
        "Guide registration has been rejected ❌",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFFEAEA),
        colorText: const Color(0xFFB00020),
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to reject guide: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFFEAEA),
      );
    }
  }
}
