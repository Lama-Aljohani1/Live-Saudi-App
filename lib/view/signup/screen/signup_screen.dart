import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:live_saudi/view/signup/controller/signup_controller.dart';
import '../../../core/const_data/app_colors.dart';
import '../../../core/services/validators.dart';
import '../../../widgets/custome_button.dart';
import '../../../widgets/custome_text_field.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen();

  @override
  Widget build(BuildContext context) {
    Get.put(SignUpController());
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: GetBuilder<SignUpController>(
        builder: (controller) => Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 14.h),
              CustomeTextField(
                validator: (value) {
                  return Validators().validateName(value!);
                },
                controller: controller.name,
                hintText: 'Ahmad',
                obscure: false,
                labelText: 'Full Name',
              ),
              SizedBox(height: 15.h),
              CustomeTextField(
                validator: (value) {
                  return Validators()
                      .validateEmail(value!, controller.registeredEmails);
                },
                controller: controller.email,
                hintText: 'ahmad@gmail.com',
                obscure: false,
                labelText: "Email Address",
              ),
              SizedBox(height: 15.h),
              CustomeTextField(
                validator: (value) {
                  return Validators()
                      .validatePhone(value!, controller.registeredPhones);
                },
                controller: controller.phone,
                hintText: '966 5X XXX XXXX',
                obscure: false,
                labelText: 'Phone Number',
              ),
              SizedBox(height: 15.h),
              CustomeTextField(
                validator: (value) {
                  return Validators().validatePassword(value!);
                },
                onSuffixPressed: () {
                  controller.obscureFunc();
                },
                suffixIcon: controller.obscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                controller: controller.password,
                hintText: '********',
                obscure: controller.obscure,
                labelText: 'Password',
              ),

              SizedBox(height: 15.h),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5.h),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.textFieldBorderColor),
                  borderRadius: BorderRadius.circular(28.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10.w),
                      child: Row(
                        children: [
                          Radio<String>(
                            value: 'Tourist',
                            groupValue: controller.selectedRole,
                            activeColor: AppColors.primaryColor,
                            onChanged: (value) {
                              controller.selectRole(value!);
                              print(controller.selectedRole);
                            },
                          ),
                          Text(
                            'Tourist',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.only(right: 20.w),
                      child: Row(
                        children: [
                          Radio<String>(
                            value: 'Tour Guide',
                            groupValue: controller.selectedRole,
                            activeColor: AppColors.primaryColor,
                            onChanged: (value) {
                              controller.selectRole(value!);
                              print(controller.selectedRole);
                            },
                          ),
                          Text(
                            'Tour Guide',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 28.h),
              CustomeButton(
                width: 0.w,
                buttonHight: 50.h,
                buttonWidth: 396.w,
                borderColor: AppColors.primaryColor,
                onPressed: () {
                  controller.signUp();
                },
                text: "Sign Up",
                backgroundColor: AppColors.primaryColor,
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
