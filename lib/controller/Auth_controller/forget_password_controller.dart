// ignore_for_file: deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendigo/config/colors.dart';
import 'package:spendigo/widgets/custom_snackbar.dart';

class ForgotPasswordController extends GetxController {
  TextEditingController emailController = TextEditingController();
  RxBool loading = false.obs;

  Future<void> sendResetLink() async {
    if (emailController.text.trim().isEmpty) {
      showCustomSnackBar("Missing Email", "Please enter your email", isError: true);
      return;
    }

    try {
      loading.value = true;

      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );

      loading.value = false;

      // ✅ SUCCESS POPUP
      Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.mark_email_read, color: AppColors.primary, size: 60),

                SizedBox(height: 15),

                Text(
                  "Check your email",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 8),

                Text(
                  "We have sent a password reset link to your email. "
                  "Please check your inbox or spam folder.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.grey),
                ),

                SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () {
                    Get.back(); // close dialog
                    Get.back(); // back to login
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    child: Text(
                      "OK",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );
    } on FirebaseAuthException catch (e) {
      loading.value = false;

      showCustomSnackBar("Error", e.message ?? "Something went wrong", isError: true);
    }
  }
}
