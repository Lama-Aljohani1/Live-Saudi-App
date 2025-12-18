import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../admin_home/screen/admin_home.dart';
import '../../touurist_bottom_navbar/screen/bottom_nav_bar_screen.dart';

class LoginController extends GetxController {
  late TextEditingController email;
  late TextEditingController password;
  bool obscure = true;

  void obscureFunc() {
    obscure = !obscure;
    update();
  }

  Future<UserCredential?> login() async {
    try {
      UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: email.text.trim(),
            password: password.text.trim(),
          );
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        Get.snackbar("Login Failed", "No user found for that email");
      } else if (e.code == "wrong-password") {
        Get.snackbar("Login Failed", "Wrong password, please try again");
      }
      return null;
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return null;
    }
  }

  Future<void> checkEmail() async {
    UserCredential? result = await login();
    if (result == null) return;

    final uid = FirebaseAuth.instance.currentUser!.uid;

    final touristDoc = await FirebaseFirestore.instance
        .collection("Tourist")
        .doc(uid)
        .get();
    if (touristDoc.exists) {
      try {
        final token = await FirebaseMessaging.instance.getToken();
        if (token != null) {
          await FirebaseFirestore.instance
              .collection('Tourist')
              .doc(uid)
              .update({'fcmToken': token});
        }
      } catch (e) {
        print("Token Error: $e");
      }
      Get.offAll(() => const TouristBottomNavBar());
      return;
    }

    final guideDoc = await FirebaseFirestore.instance
        .collection("TourGuide")
        .doc(uid)
        .get();
    if (guideDoc.exists) {
      try {
        final token = await FirebaseMessaging.instance.getToken();
        if (token != null) {
          await FirebaseFirestore.instance
              .collection('TourGuide')
              .doc(uid)
              .update({'fcmToken': token});
        }
      } catch (e) {
        print("Token Error: $e");
      }
    }

    final pendingDoc = await FirebaseFirestore.instance
        .collection("PendingGuides")
        .doc(uid)
        .get();
    if (pendingDoc.exists) {
      final isApproved = pendingDoc.data()?["isApproved"] ?? false;
      if (!isApproved) {
        Get.snackbar(
          "Pending Approval",
          "Your account is still under review. You’ll be notified once approved ✅",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
        );
        await FirebaseAuth.instance.signOut();
        return;
      } else {}
    }

    final adminDoc = await FirebaseFirestore.instance
        .collection("Admin")
        .doc(uid)
        .get();
    if (adminDoc.exists) {
      Get.offAll(() => const AdminHome());
      return;
    }

    Get.snackbar(
      "Login Failed",
      "User not found in system.",
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
    await FirebaseAuth.instance.signOut();
  }

  @override
  void onInit() {
    email = TextEditingController();
    password = TextEditingController();
    super.onInit();
  }
}
