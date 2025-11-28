import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:live_saudi/view/auth/screen/auth_screen.dart';
import '../../../core/const_data/app_colors.dart';
import '../../../core/const_data/app_images.dart';
import '../../../widgets/custome_button.dart';
import '../../admin_approve_guides/screen/admin_approve_guides_screen.dart';
import '../../admin_manage_heritage/screen/admin_manage_heritage_screen.dart';
import '../../admin_mange_accounts/screen/manage_accounts.dart';


class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Column(
              children: [
                Image.asset(AppImages. appLogo),
                const SizedBox(
                  height: 50,
                ),
                CustomeButton(
                  backgroundColor:AppColors.primaryColor ,
                  borderColor: AppColors.primaryColor ,
                  buttonWidth: 350.w,
                  buttonHight:70.h ,
                  width: 0.w,
                    onPressed: () {
                    Get.to(const AdminManageUsersScreen());
                    },
                    text: "MANAGE USERS",),
                const SizedBox(
                  height: 30,
                ),
                CustomeButton(
                  backgroundColor:AppColors.primaryColor ,
                  borderColor: AppColors.primaryColor ,
                  buttonWidth: 350.w,
                  buttonHight:70.h ,
                  width: 0.w,
                    onPressed: () {
                      Get.to(const AdminApproveGuidesScreen());
                    },
                    text: "GUIDES REQUESTS",),
                const SizedBox(
                  height: 30,
                ),
                CustomeButton(
                    backgroundColor:AppColors.primaryColor ,
                    borderColor: AppColors.primaryColor ,
                    buttonWidth: 350.w,
                    buttonHight:70.h ,
                    width: 0.w,
                    onPressed: () {
                      Get.to(const AdminManageHeritageScreen());
                      },
                    text: "HERITAGE",),
                const SizedBox(
                  height: 30,
                ),
                CustomeButton(
                  backgroundColor:AppColors.primaryColor ,
                    borderColor: AppColors.primaryColor ,
                    buttonWidth: 350.w,
                    buttonHight:70.h ,
                    width: 0.w,
                    onPressed: () async{
                      await FirebaseAuth.instance.signOut();
                      Get.offAll(() => const AuthScreen());
                    },
                    text: "LOGOUT",),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
