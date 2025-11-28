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

  // sites loaded from Firestore
  final sites = <HeritageModel>[].obs;

  // featuredSites are the ones shown in PageView (we'll use all sites as featured)
  final featuredSites = <HeritageModel>[].obs;

  // categories (including 'All')
  final categories = <String>[].obs;

  // active filtered list (for small cards / listings)
  final filteredSites = <HeritageModel>[].obs;

  // UI state
  int selectedIndex = 0; // filter pill index
  int tab = 0;
  int selectedTab = 0;
  int selectedImage = 0;
  bool isExpanded = false;

  // filters icons/labels (kept as before)
  late final List<Map<String, dynamic>> filters;

  // currently selected site for details screen
  HeritageModel? selectedSite;

  @override
  void onInit() {
    super.onInit();
    filters = [
      {"icon": Icons.local_fire_department_outlined, "label": "Popular", "value": "popular"},
      {"icon": Icons.waves, "label": "Lake", "value": "lake"},
      {"icon": Icons.beach_access_outlined, "label": "Beach", "value": "beach"},
      {"icon": FontAwesomeIcons.mountain, "label": "Mountain", "value": "mountain"},
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

      // تحقق أن الكنترولر ما تم حذفه
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


  // Load sites from Firestore and prepare categories / featured list / filtered list
  Future<void> loadSites() async {
    try {
      final col = FirebaseFirestore.instance.collection('HeritageSites');
      final snap = await col.orderBy('createdAt', descending: true).get();

      sites.value = snap.docs.map((d) => HeritageModel.fromDoc(d)).toList();

      // featuredSites: use all sites for now (keeps UI same)
      featuredSites.assignAll(sites);

      // categories
      final cats = sites.map((e) => e.category ?? 'Uncategorized').toSet().toList();
      cats.sort();
      categories.value = ['All', ...cats];

      // filteredSites default = all
      filteredSites.assignAll(sites);

      update();
    } catch (e) {
      debugPrint('Error loading sites: $e');
    }
  }

  // filter by category value (value comes from filters list or categories)
  void filterByCategory(String category) {
    if (category == 'All') {
      filteredSites.assignAll(sites);
    } else {
      filteredSites.assignAll(sites.where((e) => e.category == category));
    }
    update();
  }

  // called by filter pill taps
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

  // open details for a given featured site index (from PageView)
  void openDetailsByFeaturedIndex(int index) {
    if (index < 0 || index >= featuredSites.length) return;
    selectedSite = featuredSites[index];
    selectedImage = 0;
    selectedTab = 0;
    isExpanded = false;
    update();
    Get.to(() => const PlaceDetailsScreen(), transition: Transition.rightToLeft);
  }

  // helper to decode base64 to Uint8List (returns null if fails)
  Uint8List? decodeImageBase64(String? b64) {
    if (b64 == null) return null;
    try {
      return base64Decode(b64);
    } catch (_) {
      return null;
    }
  }

  // When selecting a small card item (by filteredSites index)
  void openDetailsFromSmallCard(int index) {
    if (index < 0 || index >= filteredSites.length) return;
    selectedSite = filteredSites[index];
    selectedTab = 0;
    selectedImage = 0;
    isExpanded = false;
    update();
    Get.to(() => const PlaceDetailsScreen(), transition: Transition.rightToLeft);
  }
// Fetch user's favorites onInit
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

// Toggle favorite
  Future<void> toggleFavorite(HeritageModel site) async {
    if (favoriteIds.contains(site.id)) {
      // Remove from favorites
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
      // Add to favorites
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

}
