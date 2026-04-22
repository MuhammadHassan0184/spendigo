// // ignore_for_file: use_build_context_synchronously

// import 'package:flutter/material.dart';
// import 'package:spendigo/config/colors.dart';
// import 'package:spendigo/services/auth_service.dart';
// import 'package:spendigo/view/DashBoard/main_screen.dart';
// import 'package:spendigo/widgets/custom_snackbar.dart';

// class GoogleLoginController {
//   final AuthService _authService = AuthService();

//   Future<void> signInWithGoogle(BuildContext context) async {
//     final user = await _authService.signInWithGoogle();

//     if (user != null) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => MainScreen()),
//       );
//     } else {
//       showCustomSnackBar("Error", "Google Sign-In canceled or failed", isError: true);
//     }
//   }
// }

import 'package:get/get.dart';
import 'package:spendigo/config/routes/routes_name.dart';
import 'package:spendigo/services/auth_service.dart';
import 'package:spendigo/widgets/custom_snackbar.dart';

class GoogleLoginController {
  final AuthService _authService = AuthService();

  Future<void> signInWithGoogle() async {
  final user = await _authService.signInWithGoogle();

  if (user != null) {
    Get.offAllNamed(AppRoutesName.mainScreen);
  } else {
    showCustomSnackBar(
      "Error",
      "Google Sign-In canceled or failed",
      isError: true,
    );
  }
}
}