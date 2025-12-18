import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/const_data/app_colors.dart';

class SmallPlaceCard extends StatelessWidget {
  final Uint8List? imageBytes;
  final String title;
  final String location;

  const SmallPlaceCard({
    super.key,
    required this.imageBytes,
    required this.title,
    this.location = "Saudi Arabia",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160.w,
      margin: EdgeInsets.only(right: 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.r),
        child: Stack(
          children: [
            imageBytes != null
                ? Image.memory(
                    imageBytes!,
                    width: 160.w,
                    height: 180.h,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    'assets/images/placeholder.jpg',
                    width: 160.w,
                    height: 180.h,
                    fit: BoxFit.cover,
                  ),

            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: 14.h,
              left: 10.w,
              right: 10.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: AppColors.primaryColor,
                        size: 14.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        location,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
