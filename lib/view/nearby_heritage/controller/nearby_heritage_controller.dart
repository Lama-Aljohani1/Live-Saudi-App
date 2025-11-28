// lib/view/nearby_heritage/nearby_heritage_controller.dart
import 'dart:async';
import 'dart:typed_data';
import 'dart:convert';
import 'dart:math' show sin, cos, sqrt, atan2, pi;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../models/heritage_model.dart';
import 'package:flutter/material.dart';

class NearbyHeritageController extends GetxController {
  // Firestore collection
  final CollectionReference _col =
  FirebaseFirestore.instance.collection('HeritageSites');

  // Rx state
  final RxList<HeritageModel> allSites = <HeritageModel>[].obs;
  final RxList<HeritageModel> nearbySites = <HeritageModel>[].obs;
  final RxList<HeritageModel> filteredSites = <HeritageModel>[].obs;

  final Rx<Position?> currentPosition = Rx<Position?>(null);

  // Map
  final RxSet<Marker> markers = <Marker>{}.obs;
  GoogleMapController? mapController;

  // subscriptions
  StreamSubscription<QuerySnapshot>? _sitesSub;
  StreamSubscription<Position>? _positionSub;


  // distance threshold to consider "nearby" in meters
  final int nearbyRadiusMeters = 5000; // 5 km, يمكنك تغييره

  @override
  void onInit() {
    super.onInit();
    _listenSites();
    _initLocation();

    // أي تغيير في nearbySites يحدث filteredSites تلقائياً
    ever(nearbySites, (_) {
      filteredSites.assignAll(nearbySites);
    });
  }





  void filterNearbySites(String query) {
    if (query.trim().isEmpty) {
      filteredSites.assignAll(nearbySites);
    } else {
      final q = query.toLowerCase();
      final results = nearbySites.where((s) =>
      s.name.toLowerCase().contains(q) ||
          s.region.toLowerCase().contains(q) ||
          s.category.toLowerCase().contains(q));
      filteredSites.assignAll(results.toList());
    }
  }

  @override
  void onClose() {
    _sitesSub?.cancel();
    _positionSub?.cancel();
    super.onClose();
  }

  // Listen to Firestore collection (live updates from admin panel)
  void _listenSites() {
    _sitesSub = _col.snapshots().listen((snap) {
      final list = snap.docs.map((d) => HeritageModel.fromDoc(d)).toList();
      allSites.assignAll(list);
      _rebuildMarkersAndNearby();
    }, onError: (e) {
      debugPrint('Error listening to HeritageSites: $e');
    });
  }

  // Initialize location: request permission, get current position, and subscribe to changes
  Future<void> _initLocation() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final req = await Geolocator.requestPermission();
        if (req == LocationPermission.denied || req == LocationPermission.deniedForever) {
          Get.snackbar('Location', 'Location permission denied',
              snackPosition: SnackPosition.BOTTOM);
          return;
        }
      }

      // Get last known / current location once
      final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      currentPosition.value = pos;

      _positionSub = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 100, // كان 50، نزيده لتقليل التحديثات
        ),
      ).listen((p) {
        if (currentPosition.value == null ||
            _calculateDistanceMeters(currentPosition.value!.latitude,
                currentPosition.value!.longitude, p.latitude, p.longitude) >
                100) {
          currentPosition.value = p;
          _rebuildMarkersAndNearby();
        }
      });


      // After initial position, build markers & nearby
      _rebuildMarkersAndNearby();
    } catch (e) {
      debugPrint('Location init error: $e');
    }
  }

  // Build markers for map and update nearbySites list
  void _rebuildMarkersAndNearby() {
    final pos = currentPosition.value;
    final sites = allSites.toList();

    // Build markers for all sites
    final Set<Marker> _m = {};

    for (var site in sites) {
      final marker = Marker(
        markerId: MarkerId(site.id),
        position: LatLng(site.latitude, site.longitude),
        infoWindow: InfoWindow(
          title: site.name,
          snippet: '${site.pricePerPerson.toStringAsFixed(0)} SAR • ${site.category}',
        ),
        onTap: () {
          // optionally open bottom sheet or details
        },
      );
      _m.add(marker);
    }

    // Add user marker if exist
    if (pos != null) {
      final userMarker = Marker(
        markerId: const MarkerId('user_marker'),
        position: LatLng(pos.latitude, pos.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: const InfoWindow(title: 'You are here'),
      );
      _m.add(userMarker);
    }

    markers.assignAll(_m);

    // Compute distances and filter nearby
    if (pos != null) {
      final List<_SiteWithDistance> tmp = sites.map((s) {
        final d = _calculateDistanceMeters(
          pos.latitude,
          pos.longitude,
          s.latitude,
          s.longitude,
        );
        return _SiteWithDistance(site: s, distance: d);
      }).toList();

      tmp.sort((a, b) => a.distance.compareTo(b.distance));

      // select those within radius
      final near = tmp.where((e) => e.distance <= nearbyRadiusMeters).map((e) => e.site).toList();

      // if none within radius, still show top 5 closest
      final result = near.isNotEmpty ? near : tmp.take(5).map((e) => e.site).toList();

      nearbySites.assignAll(result);
      filteredSites.assignAll(result);

    } else {
      nearbySites.clear();
    }
  }

  // Haversine formula to compute distance in meters
  double _calculateDistanceMeters(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371000; // Earth radius in meters
    final phi1 = _deg2rad(lat1);
    final phi2 = _deg2rad(lat2);
    final dphi = _deg2rad(lat2 - lat1);
    final dlambda = _deg2rad(lon2 - lon1);

    final a = (sin(dphi / 2) * sin(dphi / 2)) +
        cos(phi1) * cos(phi2) * (sin(dlambda / 2) * sin(dlambda / 2));
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _deg2rad(double deg) => deg * (pi / 180);

  // animate camera to a given site
  Future<void> moveCameraToSite(HeritageModel site) async {
    if (mapController == null) return;
    final cam = CameraPosition(target: LatLng(site.latitude, site.longitude), zoom: 15);
    await mapController!.animateCamera(CameraUpdate.newCameraPosition(cam));
  }

  // animate camera to user
  Future<void> moveCameraToUser() async {
    final pos = currentPosition.value;
    if (mapController == null || pos == null) return;
    final cam = CameraPosition(target: LatLng(pos.latitude, pos.longitude), zoom: 14);
    await mapController!.animateCamera(CameraUpdate.newCameraPosition(cam));
  }

  // set GoogleMapController
  void onMapCreated(GoogleMapController ctrl) {
    mapController = ctrl;
  }

  // get distance string
  String distanceStringFor(HeritageModel site) {
    final pos = currentPosition.value;
    if (pos == null) return '';
    final meters = _calculateDistanceMeters(pos.latitude, pos.longitude, site.latitude, site.longitude);
    if (meters < 1000) return '${meters.round()} m';
    return '${(meters / 1000).toStringAsFixed(1)} km';
  }
}

class _SiteWithDistance {
  final HeritageModel site;
  final double distance;
  _SiteWithDistance({required this.site, required this.distance});
}

// math imports used in distance calc

