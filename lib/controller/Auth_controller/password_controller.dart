import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendigo/config/colors.dart';
import 'package:spendigo/config/routes/routes_name.dart';

class PasswordController extends GetxController {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  RxBool isLoading = false.obs;

  Future<void> updatePassword() async {
    final password = passwordController.text.trim();
    final confirm = confirmPasswordController.text.trim();

    if (password.isEmpty || confirm.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill all fields",
        backgroundColor: AppColors.primary,
        colorText: Colors.white,
      );
      return;
    }

    if (password != confirm) {
      Get.snackbar(
        "Error",
        "Passwords do not match",
        backgroundColor: AppColors.primary,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.updatePassword(password);
      }

      isLoading.value = false;

      Get.snackbar(
        "Success",
        "Password updated successfully",
        backgroundColor: AppColors.primary,
        colorText: Colors.white,
      );

      // ✅ NAVIGATE TO PROFILE SCREEN
      Get.offAllNamed(AppRoutesName.profile);
    } catch (e) {
      isLoading.value = false;

      Get.snackbar(
        "Error",
        "Please login again to update password",
        backgroundColor: AppColors.primary,
        colorText: Colors.white,
      );
    }
  }
}
