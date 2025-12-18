import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live_saudi/view/auth/controller/auth_controller.dart';
import '../../../core/const_data/app_colors.dart';
import '../../../core/const_data/text_style.dart';
import '../../../widgets/custome_button.dart';

Widget buildSwitchButton(
  String title,
  int index,
  final AuthController controller,
) {
  final bool isActive = controller.currentIndex == index;
  return CustomeButton(
    buttonWidth: 155.w,
    buttonHight: 50.h,
    borderColor: AppColors.primaryColor,
    onPressed: () => controller.switchPage(index),
    text: title,
    backgroundColor: isActive ? AppColors.primaryColor : AppColors.white,
    editedTextStyle: FontStyles.buttonTextStyle.copyWith(
      color: isActive ? AppColors.white : AppColors.black,
    ),
  );
}
