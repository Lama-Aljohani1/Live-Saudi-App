import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_saudi/view/auth/screen/auth_screen.dart';
import 'package:live_saudi/view/touurist_bottom_navbar/screen/bottom_nav_bar_screen.dart';


class SignUpController extends GetxController {
  late TextEditingController email;
  late TextEditingController password;
  late TextEditingController phone;
  late TextEditingController name;
  bool obscure = true;
  bool obscure1 = true;
  String selectedRole = 'Tourist';
  final formKey = GlobalKey<FormState>();

  void selectRole(String role) {
    selectedRole = role;
    update();
  }

  void obscureFunc() {
    obscure = !obscure;
    update();
  }

  void obscureFunc1() {
    obscure1 = !obscure1;
    update();
  }

  Future<void> signUp() async {
    try {
      bool validate = formKey.currentState!.validate();
      if (!validate) return;

      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email.text,
            password: password.text,
          );

      final uid = userCredential.user!.uid;

      if (selectedRole == "Tourist") {
        await addUserToFirestore(uid);
        Get.offAll(() => const TouristBottomNavBar());
      } else if (selectedRole == "Tour Guide") {
        // 👇 هنا نفتح شاشة إدخال البيانات الإضافية
        showGuideExtraInfoDialog(uid);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Get.snackbar("Error", "The password provided is too weak");
      } else if (e.code == "email-already-in-use") {
        Get.snackbar("Error", "The account already exists for that email");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> addUserToFirestore(
      String uid, {
        int experienceYears = 0,
        String country = "Saudi Arabia",
        List<String> languages = const [],
        double hourlyRate = 0.0,
        String whatsappNumber = "",
        String instagram = "",
      }) async {
    final db = FirebaseFirestore.instance;

    final userInfo = {
      "uid": uid,
      "name": name.text.trim(),
      "email": email.text.trim(),
      "phone": phone.text.trim(),
      "password": password.text.trim(),
      "createdAt": FieldValue.serverTimestamp(),
    };

    if (selectedRole == 'Tourist') {
      await db.collection("Tourist").doc(uid).set(userInfo);
    } else if (selectedRole == 'Tour Guide') {
      await db.collection("PendingGuides").doc(uid).set({
        ...userInfo,
        "role": "Tour Guide",
        "isApproved": false,
        "experienceYears": experienceYears,
        "country": country,
        "languages": languages,
        "hourlyRate": hourlyRate,
        "whatsappNumber": whatsappNumber,
        "instagram": instagram,
      });
    }
  }


  @override
  void onInit() {
    email = TextEditingController();
    password = TextEditingController();
    name = TextEditingController();
    phone = TextEditingController();
    super.onInit();
  }

  void showGuideExtraInfoDialog(String uid) {
    final experienceController = TextEditingController();
    final countryController = TextEditingController();
    final languagesController = TextEditingController();
    final hourlyRateController = TextEditingController();
    final whatsappController = TextEditingController();
    final instagramController = TextEditingController();

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "Complete Your Profile 🧭",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: experienceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Years of Experience",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: countryController,
                decoration: const InputDecoration(
                  labelText: "Country / City",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: languagesController,
                decoration: const InputDecoration(
                  labelText: "Languages (comma separated)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: hourlyRateController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Hourly Rate (USD)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: whatsappController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "WhatsApp Number",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: instagramController,
                decoration: const InputDecoration(
                  labelText: "Instagram Username",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () async {
                  if (experienceController.text.isEmpty ||
                      countryController.text.isEmpty ||
                      languagesController.text.isEmpty ||
                      hourlyRateController.text.isEmpty ||
                      whatsappController.text.isEmpty ||
                      instagramController.text.isEmpty) {
                    Get.snackbar("Missing Info", "Please fill all fields");
                    return;
                  }

                  await addUserToFirestore(
                    uid,
                    experienceYears: int.tryParse(experienceController.text) ?? 0,
                    country: countryController.text.trim(),
                    languages: languagesController.text
                        .split(',')
                        .map((e) => e.trim())
                        .toList(),
                    hourlyRate: double.tryParse(hourlyRateController.text) ?? 0.0,
                    whatsappNumber: whatsappController.text.trim(),
                    instagram: instagramController.text.trim(),
                  );

                  Get.back();
                  Get.offAll(() => const AuthScreen());

                  Get.snackbar(
                    "Pending Approval",
                    "Your account is under review. You’ll be notified once approved ✅",
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                child: const Text(
                  "Submit",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

}
