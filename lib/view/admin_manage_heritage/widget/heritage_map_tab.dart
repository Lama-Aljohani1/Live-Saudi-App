import 'dart:async';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/const_data/app_colors.dart';

class HeritageMapTab extends StatefulWidget {
  const HeritageMapTab({super.key});

  @override
  State<HeritageMapTab> createState() => _HeritageMapTabState();
}

class _HeritageMapTabState extends State<HeritageMapTab> {
  final Completer<GoogleMapController> _gController = Completer();
  final Set<Marker> _markers = {};
  final col = FirebaseFirestore.instance.collection('HeritageSites');
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  Future<void> _loadMarkers() async {
    try {
      final snap = await col.get();
      _markers.clear();
      for (var d in snap.docs) {
        final data = d.data() as Map<String, dynamic>;
        if (data['latitude'] != null && data['longitude'] != null) {
          final pos = LatLng(
            (data['latitude'] ?? 0).toDouble(),
            (data['longitude'] ?? 0).toDouble(),
          );
          _markers.add(
            Marker(
              markerId: MarkerId(d.id),
              position: pos,
              infoWindow: InfoWindow(title: data['name'] ?? ''),
              onTap: () => _showDialog(data),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Map load error: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  void _showDialog(Map<String, dynamic> data) {
    Uint8List? bytes;
    if (data['images'] != null &&
        data['images'] is List &&
        (data['images'] as List).isNotEmpty) {
      try {
        bytes = base64Decode(data['images'][0]);
      } catch (_) {
        bytes = null;
      }
    }
    Get.dialog(
      Dialog(
        insetPadding: EdgeInsets.all(16.w),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (bytes != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.memory(
                    bytes,
                    height: 140.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              SizedBox(height: 8.h),
              Text(
                data['name'] ?? '',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColor,
                ),
              ),
              SizedBox(height: 6.h),
              Text(data['region'] ?? '', style: TextStyle(color: Colors.grey)),
              SizedBox(height: 6.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(5, (i) {
                    final rating = (data['rating'] ?? 0).toDouble();
                    return Icon(
                      i < rating.round()
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      color: Colors.amber,
                      size: 20.sp,
                    );
                  }),
                  SizedBox(width: 6.w),
                  Text(
                    "${(data['rating'] ?? 0).toStringAsFixed(1)}",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 6.h),
              Text(
                "${data['pricePerPerson'] ?? 0} SAR / person",
                style: TextStyle(color: Colors.green),
              ),
              SizedBox(height: 8.h),
              Text(
                data['description'] ?? '',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 10.h),
              ElevatedButton(onPressed: () => Get.back(), child: Text('Close')),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: LatLng(23.8859, 45.0792),
            zoom: 5.6,
          ),
          markers: _markers,
          onMapCreated: (c) => _gController.complete(c),
        ),
        Positioned(
          top: 16.h,
          right: 12.w,
          child: FloatingActionButton.small(
            onPressed: _loadMarkers,
            child: const Icon(Icons.refresh),
          ),
        ),
      ],
    );
  }
}
