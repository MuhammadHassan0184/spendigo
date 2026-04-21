// controllers/signup_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendigo/config/colors.dart';
import 'package:spendigo/config/routes/routes_name.dart';
import 'package:spendigo/services/auth_service.dart';
import 'package:spendigo/widgets/custom_snackbar.dart';

class SignupController extends GetxController {
  final AuthService _authService = AuthService();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  RxBool isLoading = false.obs;

  Future<void> signup() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      showCustomSnackBar("Error", "Please fill all fields", isError: true);
      return;
    }

    if (password != confirmPassword) {
      showCustomSnackBar("Error", "Passwords do not match", isError: true);
      return;
    }

    try {
      isLoading.value = true;

      final user = await _authService.signUp(email, password, name);

      isLoading.value = false;

      if (user != null) {
        Get.offAllNamed(AppRoutesName.mainScreen);
      }
    } catch (e) {
      isLoading.value = false;

      showCustomSnackBar("Error", e.toString(), isError: true);
    }
  }
}