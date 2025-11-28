import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/const_data/text_style.dart';


class CustomeButton extends StatelessWidget {
  final void Function()? onPressed;
  final Color backgroundColor;
  final Color borderColor;
  final String? text;
  final double? width;
  final double? buttonWidth;
  final double? buttonHight;
  final double? hightPadding;
  final double? raduis;
  final TextStyle? editedTextStyle;

  const CustomeButton(
      {super.key,
        required this.borderColor,
        required this.onPressed,
        required this.text,
        required this.backgroundColor,
        this.width,
        this.buttonWidth,
        this.buttonHight,
        this.editedTextStyle,
        this.hightPadding, this.raduis});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width ??16.w),
      child: MaterialButton(
        elevation: 0,
        padding: EdgeInsets.only(top: hightPadding ?? 0),
        onPressed: onPressed,
        height: buttonHight ?? 37.h,
        minWidth: buttonWidth ??343.w,
        color: backgroundColor,
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(raduis??28.r),
            borderSide: BorderSide(color: borderColor)),
        child: Text(
            text!,
            style: editedTextStyle ?? FontStyles.buttonTextStyle,
          ),

      ),
    );
  }
}
