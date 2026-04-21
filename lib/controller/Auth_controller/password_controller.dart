import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendigo/config/routes/routes_name.dart';
import 'package:spendigo/widgets/custom_snackbar.dart';

class PasswordController extends GetxController {
  final currentPasswordController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  RxBool isLoading = false.obs;

  Future<void> updatePassword() async {
    final currentPassword = currentPasswordController.text.trim();
    final newPassword = passwordController.text.trim();
    final confirm = confirmPasswordController.text.trim();

    if (currentPassword.isEmpty || newPassword.isEmpty || confirm.isEmpty) {
      showCustomSnackBar("Error", "Please fill all fields", isError: true);
      return;
    }

    if (newPassword != confirm) {
      showCustomSnackBar("Error", "Passwords do not match", isError: true);
      return;
    }

    try {
      isLoading.value = true;

      final user = FirebaseAuth.instance.currentUser;

      if (user == null || user.email == null) return;

      // 🔐 STEP 1: Re-authenticate user (BANKING SECURITY)
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // 🔐 STEP 2: Update password
      await user.updatePassword(newPassword);

      isLoading.value = false;

      showCustomSnackBar("Success", "Password updated successfully");

      // 🔐 STEP 3: Force logout (important security step)
      await FirebaseAuth.instance.signOut();

      // 🔐 STEP 4: Go to login screen
      Get.offAllNamed(AppRoutesName.signIn);
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;

      showCustomSnackBar("Error", e.message ?? "Authentication failed", isError: true);
    }
  }
}
