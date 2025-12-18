import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/admin_user_model.dart';

class TouristProfileController extends GetxController {
  AdminUserModel? currentUser;
  File? imageFile;

  @override
  void onInit() {
    super.onInit();
    loadCurrentUser();
  }

  Future<void> loadCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("⚠ No user logged in!");
      return;
    }

    final uid = user.uid;

    final doc = await FirebaseFirestore.instance
        .collection("Tourist")
        .doc(uid)
        .get();

    if (!doc.exists || doc.data() == null) {
      print("⚠ User document does not exist!");
      return;
    }

    String role = "";
    if (doc.data()!.containsKey("role")) {
      role = doc["role"];
    } else {
      role = "Tourist";
    }

    currentUser = AdminUserModel.fromFirestore(doc.data()!, doc.id, role);

    update();
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picked != null) {
      imageFile = File(picked.path);
      update();
    }
  }

  Future<void> updateUserProfile({
    required String newName,
    required String newEmail,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;
    final uid = user.uid;

    await FirebaseFirestore.instance.collection("Tourist").doc(uid).update({
      "name": newName,
      "email": newEmail,
      "image": currentUser?.imagePath ?? "",
      "role": currentUser?.role ?? "Tourist",
    });

    currentUser = AdminUserModel(
      id: uid,
      name: newName,
      email: newEmail,
      role: currentUser!.role,
      imagePath: currentUser!.imagePath,
      isActive: currentUser!.isActive,
    );

    update();
    Get.snackbar("Success", "Profile updated successfully");
  }
}
