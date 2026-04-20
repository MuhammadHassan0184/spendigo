import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendigo/config/colors.dart';
import 'package:spendigo/config/routes/routes_name.dart';
import 'package:spendigo/services/auth_service.dart';

class SigninController extends GetxController {
  final AuthService _authService = AuthService();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  RxBool isLoading = false.obs;

  Future<void> login(BuildContext context) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter email and password",
        backgroundColor: AppColors.primary,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      final userCredential = await _authService.login(email, password);

      isLoading.value = false;

      if (userCredential.user != null) {
        Get.snackbar(
          "Success",
          "Welcome back ${userCredential.user!.email}",
          backgroundColor: AppColors.primary,
          colorText: Colors.white,
        );

        Get.offAllNamed(AppRoutesName.mainScreen);
      }
    } catch (e) {
      isLoading.value = false;

      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: AppColors.primary,
        colorText: Colors.white,
      );
    }
  }
}