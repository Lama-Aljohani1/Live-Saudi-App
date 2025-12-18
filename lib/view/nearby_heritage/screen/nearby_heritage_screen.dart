// lib/view/nearby_heritage/nearby_heritage_screen.dart
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controller/nearby_heritage_controller.dart';

class NearbyHeritageScreen extends StatelessWidget {
  NearbyHeritageScreen({super.key});

  final NearbyHeritageController c = Get.put(NearbyHeritageController());
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Obx(() {
              final pos = c.currentPosition.value;
              if (pos == null) {
                return const Center(child: CircularProgressIndicator());
              }
              return GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(pos.latitude, pos.longitude),
                  zoom: 14,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                markers: c.markers.toSet(),
                onMapCreated: c.onMapCreated,
              );
            }),

            Positioned(
              top: 20.h,
              left: 20.w,
              right: 20.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        onChanged: (val) => c.filterNearbySites(val),
                        decoration: InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          hintText: "Search nearby heritage sites",
                          hintStyle: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: c.moveCameraToUser,
                      child: const Icon(Icons.my_location, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.30,
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(22.r),
                    topRight: Radius.circular(22.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Nearby heritage sites",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Expanded(
                      child: Obx(() {
                        final list = c.filteredSites;
                        final pos = c.currentPosition.value;
                        if (list.isEmpty) {
                          return Center(
                            child: Text(
                              pos == null
                                  ? 'Fetching location...'
                                  : 'No nearby sites found',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14.sp,
                              ),
                            ),
                          );
                        }
                        return ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (_, i) {
                            final s = list[i];
                            Uint8List? img;
                            if (s.imagesBase64.isNotEmpty) {
                              try {
                                img = base64Decode(s.imagesBase64.first);
                              } catch (_) {}
                            }
                            return Container(
                              margin: EdgeInsets.only(bottom: 10.h),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(12.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 3,
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                ),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.r),
                                  child: img != null
                                      ? Image.memory(
                                          img,
                                          width: 60.w,
                                          height: 60.h,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          width: 60.w,
                                          height: 60.h,
                                          color: Colors.grey.shade300,
                                          child: const Icon(
                                            Icons.image,
                                            color: Colors.white54,
                                          ),
                                        ),
                                ),
                                title: Text(
                                  s.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15.sp,
                                  ),
                                ),
                                subtitle: Row(
                                  children: [
                                    const Icon(
                                      Icons.place,
                                      size: 14,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(width: 5.w),
                                    Text(
                                      s.region,
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 13.sp,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      c.distanceStringFor(s),
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 11.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 14.sp,
                                  color: Colors.grey,
                                ),

                                onTap: () => c.moveCameraToSite(s),
                              ),
                            );
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
