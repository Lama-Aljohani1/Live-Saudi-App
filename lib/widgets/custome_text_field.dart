import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/const_data/app_colors.dart';
import '../core/const_data/text_style.dart';

class CustomeTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final bool obscure;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixPressed;
  final String? Function(String?)? validator;

  const CustomeTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.obscure = false,
    this.suffixIcon,
    this.onSuffixPressed,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
            controller: controller,
            obscureText: obscure,
            validator: validator,
            cursorColor: AppColors.primaryColor,
            style: FontStyles.labelTextStyle,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: FontStyles.hintTextStyle,
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 16.h,
              ),
              suffixIcon: suffixIcon != null
                  ? IconButton(
                onPressed: onSuffixPressed,
                icon: Icon(
                  suffixIcon,
                  color: AppColors.labelColor,
                  size: 22.w,
                ),
              )
                  : null,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.textFieldBorderColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(28.r),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.primaryColor,
                  width: 1.2,
                ),
                borderRadius: BorderRadius.circular(28.r),
              ),
              labelText: labelText,
              floatingLabelAlignment: FloatingLabelAlignment.start,
              floatingLabelStyle: FontStyles.labelTextStyle
            ),

          );

  }
}
