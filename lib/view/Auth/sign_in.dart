import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';

import 'package:spendigo/config/colors.dart';
import 'package:spendigo/config/routes/routes_name.dart';
import 'package:spendigo/view/DashBoard/main_screen.dart';
import 'package:spendigo/widgets/custom_textfield.dart';
import 'package:spendigo/widgets/custom_button.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/splash_bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 22.h),

                /// HEADER
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Hey! \nWelcome Back",
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                      SvgPicture.asset(
                        "assets/auth_logo.svg",
                        height: 60.h,
                        width: 60.w,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),

                /// WHITE CONTAINER
                Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.r),
                      topRight: Radius.circular(30.r),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Sign In",
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 15.h),

                        /// EMAIL
                        CustomTextField(
                          label: "Email",
                          hintText: "Enter your email",
                          keyboardType: TextInputType.emailAddress,
                        ),

                        SizedBox(height: 15.h),

                        /// PASSWORD
                        CustomTextField(
                          label: "Password",
                          hintText: "Enter your password",
                          isPassword: true,
                        ),

                        SizedBox(height: 10.h),

                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Forgot your Password?",
                            style: TextStyle(
                              color: AppColors.grey,
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),

                        SizedBox(height: 20.h),

                        /// SIGN IN BUTTON
                        CustomButton(
                          text: "Sign In",
                          onPressed: () {
                            Get.offAll(() => MainScreen());
                          },
                        ),

                        SizedBox(height: 20.h),

                        /// SIGN UP ROW
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.toNamed(AppRoutesName.signUp);
                              },
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.sp,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 20.h),

                        /// DIVIDER
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: AppColors.stroke,
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: Text(
                                "or Sign In with",
                                style: TextStyle(
                                  color: AppColors.grey,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: AppColors.stroke,
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 20.h),

                        /// GOOGLE BUTTON
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.stroke),
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/google_icon.svg",
                                height: 22.h,
                                width: 22.w,
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                "Google",
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 15.h),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
