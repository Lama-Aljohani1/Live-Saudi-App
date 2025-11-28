import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live_saudi/core/const_data/app_colors.dart';
import 'package:live_saudi/core/const_data/text_style.dart';

class FilterPill extends StatelessWidget {
  final String label;
  final bool active;
  final IconData icon;
  final VoidCallback onTap;

  const FilterPill({
    super.key,
    required this.label,
    required this.active,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: active ? AppColors.primaryColor : AppColors.white,
          borderRadius: BorderRadius.circular(25.r),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: active
              ? [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.25),
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ]
              : [],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16.w,
              color: active ? Colors.white : Colors.black87,
            ),
            SizedBox(width: 6.w),
            Text(
              label,
              style: FontStyles.pillTextStyle.copyWith(
                color: active ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
