import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:live_saudi/core/const_data/app_images.dart';
import 'package:live_saudi/view/auth/controller/auth_controller.dart';
import '../../../core/const_data/app_colors.dart';
import '../../login/screen/login_screen.dart';
import '../../signup/screen/signup_screen.dart';
import '../widget/custome_switch_button.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());
    return Scaffold(
      backgroundColor: AppColors.white,
      body: GetBuilder<AuthController>(
        builder: (controller) => Column(
          children: [
            SizedBox(height: 20.h),
            Image.asset(AppImages.appLogo, height: 171.h, width: 278.w),
            SizedBox(height: 50.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildSwitchButton('Login', 0, controller),
                Spacer(),
                buildSwitchButton('Sign Up', 1, controller),
              ],
            ),
            SizedBox(height: 24.h),
            Expanded(
              child: PageView(
                onPageChanged: (index) {
                  controller.currentIndex = index;
                  controller.update();
                },
                controller: controller.pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: const [LoginScreen(), SignUpScreen()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
