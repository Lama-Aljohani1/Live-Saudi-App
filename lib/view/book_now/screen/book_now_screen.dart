import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:live_saudi/core/const_data/app_images.dart';
import '../../../core/const_data/app_colors.dart';
import '../../../models/tour_guide_model.dart';
import '../../book_tour_guide/controller/book_tour_guide_controller.dart';

class BookNowScreen extends StatefulWidget {
  final String siteId;
  final TourGuideModel guide;

  const BookNowScreen({super.key, required this.siteId, required this.guide});

  @override
  State<BookNowScreen> createState() => _BookNowScreenState();
}

class _BookNowScreenState extends State<BookNowScreen> {
  final BookTourGuideController tc = Get.find<BookTourGuideController>();
  bool loading = false;

  Future<void> _handleContact(String channel) async {
    String url = '';
    switch (channel) {
      case 'whatsapp':
        url = 'https://wa.me/${widget.guide.phone}';
        break;
      case 'instagram':
        url = 'https://instagram.com/${widget.guide.instagram}';
        break;
      case 'phone':
        url = 'tel:${widget.guide.phone}';
        break;
    }

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('Error', 'Cannot open $channel');
    }
  }

  @override
  Widget build(BuildContext context) {
    final priceStr = '\$${widget.guide.hourlyRate}/hour';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primaryColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8.h),
                Text(
                  "Book Now",
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryColor,
                  ),
                ),
                SizedBox(height: 30.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.credit_card,
                      size: 18.w,
                      color: AppColors.primaryColor,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      priceStr,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.h),
                Divider(),
                SizedBox(height: 20.h),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 26.w),
                  padding: EdgeInsets.symmetric(vertical: 24.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40.r,
                        backgroundImage: AssetImage(AppImages.tourguide),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        widget.guide.name,
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        "${widget.guide.experienceYears} years • ${widget.guide.country}",
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(
                              FontAwesomeIcons.whatsapp,
                              color: Colors.green,
                            ),
                            onPressed: () => _handleContact('whatsapp'),
                          ),
                          SizedBox(width: 24.w),
                          IconButton(
                            icon: Icon(Icons.phone, color: Colors.blue),
                            onPressed: () => _handleContact('phone'),
                          ),
                          SizedBox(width: 24.w),
                          IconButton(
                            icon: Icon(
                              FontAwesomeIcons.instagram,
                              color: Colors.pinkAccent,
                            ),
                            onPressed: () => _handleContact('instagram'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (loading)
            Positioned.fill(
              child: Container(
                color: Colors.black26,
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }
}
