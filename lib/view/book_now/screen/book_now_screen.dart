import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live_saudi/core/const_data/app_images.dart';
import 'package:url_launcher/url_launcher.dart';
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

  Future<void> _openWhatsApp() async {
    final phone = widget.guide.whatsappNumber.isNotEmpty
        ? widget.guide.whatsappNumber.replaceAll('+', '').trim()
        : widget.guide.phone.replaceAll('+', '').trim();

    final url = Uri.parse('https://wa.me/$phone');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('Error', 'Could not open WhatsApp for ${widget.guide.name}');
    }
  }

  Future<void> _callGuide() async {
    final phone = widget.guide.phone.trim();
    final url = Uri.parse('tel:$phone');

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      Get.snackbar('Error', 'Could not call ${widget.guide.name}');
    }
  }

  Future<void> _openInstagram() async {
    final username = widget.guide.instagram.trim();
    final url = Uri.parse('https://www.instagram.com/$username');

    if (username.isEmpty) {
      Get.snackbar('Error', 'No Instagram username provided');
      return;
    }

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        'Error',
        'Could not open Instagram for ${widget.guide.name}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final priceStr = '\$${widget.guide.hourlyRate}/hour' ;

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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Book Now',
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 22.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 41.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.credit_card,
                  size: 18.w,
                  color: AppColors.primaryColor,
                ),
                SizedBox(width: 4.w),
                Text(
                  priceStr,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Divider(color: AppColors.textFieldBorderColor),
            ),
            SizedBox(height: 16.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 26.w),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 24.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40.r,
                      backgroundImage: AssetImage(AppImages.avatar),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      widget.guide.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      '${widget.guide.experienceYears} years • ${widget.guide.country}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 18.h),

                    // أيقونات التواصل
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // واتساب
                        IconButton(
                          icon: const Icon(
                            FontAwesomeIcons.whatsapp,
                            color: Colors.green,
                          ),
                          onPressed: _openWhatsApp,
                        ),
                        SizedBox(width: 20.w),

                        // الهاتف
                        IconButton(
                          icon: const Icon(
                            Icons.phone_outlined,
                            color: Colors.blue,
                          ),
                          onPressed: _callGuide,
                        ),
                        SizedBox(width: 20.w),

                        // إنستغرام
                        IconButton(
                          icon: const Icon(
                            FontAwesomeIcons.instagram,
                            color: Colors.pinkAccent,
                          ),
                          onPressed: _openInstagram,
                        ),
                      ],
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
