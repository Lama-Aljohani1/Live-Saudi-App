import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live_saudi/core/const_data/app_colors.dart';
import 'package:live_saudi/core/const_data/app_images.dart';
import '../../auth/screen/auth_screen.dart';


class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.asset(AppImages.appLogo),
      logoWidth: 333.w,
      backgroundColor: AppColors.white,
      showLoader: true,
      loaderColor: AppColors.primaryColor,
      navigator: AuthScreen(),
      durationInSeconds: 5,
    );
  }
}
