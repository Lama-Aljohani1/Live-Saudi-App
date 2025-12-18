import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:live_saudi/models/heritage_model.dart';

import '../widget/place_details.dart';

class TouristHeritageController extends GetxController {
  final PageController pageController = PageController(viewportFraction: 0.75);
  int currentIndex = 0;
  final favoriteIds = <String>[].obs;
  bool canRate = false;
  var siteReviews = [].obs;
  var siteRating = 0.0.obs;

  Future<void> loadSiteReviews(String siteId) async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection('HeritageSites')
          .doc(siteId)
          .collection('Reviews')
          .orderBy('createdAt', descending: true)
          .get();

      siteReviews.value = snap.docs.map((d) => d.data()).toList();

      if (siteReviews.isNotEmpty) {
        double avg =
            siteReviews
                .map((e) => (e['rating'] as num).toDouble())
                .reduce((a, b) => a + b) /
            siteReviews.length;

        siteRating.value = avg;
      } else {
        siteRating.value = 0;
      }

      update();
    } catch (e) {
      print("Error loading reviews: $e");
    }
  }

  Future<void> checkIfUserCanRate(String siteId) async {
    canRate = await canRateSite(siteId);
    update();
  }

  final sites = <HeritageModel>[].obs;

  final featuredSites = <HeritageModel>[].obs;

  final categories = <String>[].obs;

  final filteredSites = <HeritageModel>[].obs;

  int selectedIndex = 0;
  int tab = 0;
  int selectedTab = 0;
  int selectedImage = 0;
  bool isExpanded = false;

  late final List<Map<String, dynamic>> filters;

  HeritageModel? selectedSite;

  @override
  void onInit() {
    super.onInit();
    filters = [
      {
        "icon": Icons.local_fire_department_outlined,
        "label": "Popular",
        "value": "popular",
      },
      {"icon": Icons.waves, "label": "Lake", "value": "lake"},
      {"icon": Icons.beach_access_outlined, "label": "Beach", "value": "beach"},
      {
        "icon": FontAwesomeIcons.mountain,
        "label": "Mountain",
        "value": "mountain",
      },
    ];
    loadSites();
    Future.delayed(Duration.zero, () {
      startAutoScroll();
    });
    loadUserFavorites();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void startAutoScroll() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 4));

      if (!Get.isRegistered<TouristHeritageController>()) return false;

      if (featuredSites.isEmpty) return true;

      int nextPage = (currentIndex + 1) % featuredSites.length;
      pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );

      currentIndex = nextPage;

      return true;
    });
  }

  Future<void> loadSites() async {
    try {
      final col = FirebaseFirestore.instance.collection('HeritageSites');
      final snap = await col.orderBy('createdAt', descending: true).get();

      sites.value = snap.docs.map((d) => HeritageModel.fromDoc(d)).toList();

      featuredSites.assignAll(sites);

      final cats = sites
          .map((e) => e.category ?? 'Uncategorized')
          .toSet()
          .toList();
      cats.sort();
      categories.value = ['All', ...cats];

      filteredSites.assignAll(sites);

      update();
    } catch (e) {
      debugPrint('Error loading sites: $e');
    }
  }

  void filterByCategory(String category) {
    if (category == 'All') {
      filteredSites.assignAll(sites);
    } else {
      filteredSites.assignAll(sites.where((e) => e.category == category));
    }
    update();
  }

  void selectFilterByIndex(int i) {
    selectedIndex = i;
    final value = filters[i]['value'] as String?;
    if (value != null) {
      filterByCategory(value);
    } else {
      filterByCategory('All');
    }
    update();
  }

  void openDetailsByFeaturedIndex(int index) {
    if (index < 0 || index >= featuredSites.length) return;
    selectedSite = featuredSites[index];
    selectedImage = 0;
    selectedTab = 0;
    isExpanded = false;
    update();
    Get.to(
      () => const PlaceDetailsScreen(),
      transition: Transition.rightToLeft,
    );
  }

  Uint8List? decodeImageBase64(String? b64) {
    if (b64 == null) return null;
    try {
      return base64Decode(b64);
    } catch (_) {
      return null;
    }
  }

  void openDetailsFromSmallCard(int index) {
    if (index < 0 || index >= filteredSites.length) return;
    selectedSite = filteredSites[index];
    selectedTab = 0;
    selectedImage = 0;
    isExpanded = false;
    update();
    Get.to(
      () => const PlaceDetailsScreen(),
      transition: Transition.rightToLeft,
    );
  }

  Future<void> loadUserFavorites() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final snap = await FirebaseFirestore.instance
          .collection('Favorites')
          .where('userId', isEqualTo: uid)
          .get();

      favoriteIds.assignAll(snap.docs.map((d) => d.id));
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    }
  }

  Future<void> toggleFavorite(HeritageModel site) async {
    if (favoriteIds.contains(site.id)) {
      try {
        await FirebaseFirestore.instance
            .collection('Favorites')
            .doc(site.id)
            .delete();
        favoriteIds.remove(site.id);
        update();
        Get.snackbar('Removed', '${site.name} removed from favorites');
      } catch (e) {
        Get.snackbar('Error', 'Failed to remove favorite: $e');
      }
    } else {
      try {
        await FirebaseFirestore.instance
            .collection('Favorites')
            .doc(site.id)
            .set({
              'id': site.id,
              'name': site.name,
              'description': site.description,
              'region': site.region,
              'category': site.category,
              'pricePerPerson': site.pricePerPerson,
              'rating': site.rating,
              'imagesBase64': site.imagesBase64,
              'reviews': site.reviews,
              'createdAt': FieldValue.serverTimestamp(),
              'userId': FirebaseAuth.instance.currentUser!.uid,
            });
        favoriteIds.add(site.id);
        update();
        Get.snackbar('Added', '${site.name} added to favorites');
      } catch (e) {
        Get.snackbar('Error', 'Failed to add favorite: $e');
      }
    }
    update();
  }

  Future<bool> canRateSite(String siteId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final bookings = await FirebaseFirestore.instance
        .collection('Bookings')
        .where('touristId', isEqualTo: user.uid)
        .where('siteId', isEqualTo: siteId)
        .where('status', isEqualTo: 'confirmed')
        .get();

    if (bookings.docs.isEmpty) return false;

    final review = await FirebaseFirestore.instance
        .collection('HeritageSites')
        .doc(siteId)
        .collection('Reviews')
        .where('touristId', isEqualTo: user.uid)
        .get();

    return review.docs.isEmpty;
  }

  void openRatingDialog(String siteId) {
    double rating = 0;
    final commentCtrl = TextEditingController();

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Rate this Heritage Site",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                return IconButton(
                  icon: Icon(
                    i < rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 32,
                  ),
                  onPressed: () {
                    rating = i + 1.0;
                    update();
                    openRatingDialog(siteId);
                  },
                );
              }),
            ),

            SizedBox(height: 12),

            TextField(
              controller: commentCtrl,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Write a comment (optional)…",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 18),

            ElevatedButton(
              onPressed: () {
                submitRating(siteId, rating, commentCtrl.text.trim());
              },
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> submitRating(
    String siteId,
    double rating,
    String comment,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('HeritageSites')
        .doc(siteId)
        .collection('Reviews')
        .add({
          "touristId": user.uid,
          "rating": rating,
          "comment": comment,
          "createdAt": FieldValue.serverTimestamp(),
        });

    await updateAverageRating(siteId);

    Get.back();
    Get.snackbar("Thank you!", "Your rating has been submitted.");
  }

  Future<void> updateAverageRating(String siteId) async {
    final reviews = await FirebaseFirestore.instance
        .collection('HeritageSites')
        .doc(siteId)
        .collection('Reviews')
        .get();

    if (reviews.docs.isEmpty) return;

    double avg =
        reviews.docs
            .map((e) => (e['rating'] as num).toDouble())
            .reduce((a, b) => a + b) /
        reviews.docs.length;

    await FirebaseFirestore.instance
        .collection('HeritageSites')
        .doc(siteId)
        .update({'rating': avg, 'reviews': reviews.docs.length});
  }
}
