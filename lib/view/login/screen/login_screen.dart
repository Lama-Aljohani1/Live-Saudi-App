import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:live_saudi/core/const_data/app_images.dart';
import 'package:live_saudi/view/login/controller/login_controller.dart';
import 'package:live_saudi/widgets/custome_button.dart';
import 'package:live_saudi/widgets/custome_text_field.dart';
import '../../../core/const_data/app_colors.dart';
import '../../../core/const_data/text_style.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen();

  @override
  Widget build(BuildContext context) {
    Get.put(LoginController());
    return GetBuilder<LoginController>(
      builder: (controller) => SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 14.h),
            CustomeTextField(
              controller: controller.email,
              hintText: 'ahmad@gmail.com',
              obscure: false,
              labelText: "Email Address",
            ),
            SizedBox(height: 15.h),
            CustomeTextField(
              labelText: "Password",
              onSuffixPressed: () {
                controller.obscureFunc();
              },
              suffixIcon: controller.obscure
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,

              controller: controller.password,
              hintText: '********',
              obscure: controller.obscure,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'Forgot Password',
                  style: FontStyles.hintTextStyle.copyWith(
                    color: AppColors.labelColor,
                  ),
                ),
              ),
            ),
            SizedBox(height: 14.h),
            CustomeButton(
              width: 0.w,
              buttonHight: 50.h,
              buttonWidth: 396.w,
              borderColor: AppColors.primaryColor,
              onPressed: () {
                controller.checkEmail();
              },
              text: "Login",
              backgroundColor: AppColors.primaryColor,
            ),
            SizedBox(height: 52.h),
            Row(
              children: [
                Expanded(child: Divider(thickness: 1)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text(
                    'Or',
                    style: FontStyles.buttonTextStyle.copyWith(
                      color: AppColors.labelColor,
                    ),
                  ),
                ),
                Expanded(child: Divider(thickness: 1)),
              ],
            ),
            SizedBox(height: 28.h),
            _buildSocialButton('Google', AppImages.google),
            SizedBox(height: 16.h),
            _buildSocialButton('Apple', AppImages.apple),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton(String label, String iconPath) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28.r),
        ),
        minimumSize: const Size(double.infinity, 50),
      ),
      onPressed: () {},
      icon: Image.asset(iconPath),
      label: Text(label),
    );
  }
}
