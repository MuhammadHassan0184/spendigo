import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendigo/config/colors.dart';
import 'package:spendigo/config/routes/routes_name.dart';
import 'package:spendigo/services/auth_service.dart';
import 'package:spendigo/widgets/custom_snackbar.dart';

class SigninController extends GetxController {
  final AuthService _authService = AuthService();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  RxBool isLoading = false.obs;

  Future<void> login(BuildContext context) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showCustomSnackBar("Error", "Please enter email and password", isError: true);
      return;
    }

    try {
      isLoading.value = true;

      final userCredential = await _authService.login(email, password);

      isLoading.value = false;

      if (userCredential.user != null) {
        showCustomSnackBar("Success", "Welcome back ${userCredential.user!.email}");

        Get.offAllNamed(AppRoutesName.mainScreen);
      }
    } catch (e) {
      isLoading.value = false;

      showCustomSnackBar("Error", e.toString(), isError: true);
    }
  }
}