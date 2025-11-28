import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

class FontStyles{
  static TextStyle buttonTextStyle = TextStyle(
      color: AppColors.white,
      fontSize: 18.sp,
      height: 1.3.h,
      fontWeight: FontWeight.w500,
      fontFamily: "Roboto");

  static TextStyle hintTextStyle = TextStyle(
      color: AppColors.hintTextColor,
      fontSize: 15.sp,
      height: 1.3.h,
      fontWeight: FontWeight.w500,
      fontFamily: "Roboto");

  static TextStyle labelTextStyle = TextStyle(
      color: AppColors.labelColor,
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
      fontFamily: "Roboto");

  static TextStyle pillTextStyle = TextStyle(
      color: AppColors.white,
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto");

  static TextStyle details = TextStyle(
      color: Colors.grey[700],
      fontSize: 13.sp,
      height: 1.4,
      fontFamily: "Roboto");
}