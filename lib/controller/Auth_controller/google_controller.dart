// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:spendigo/config/colors.dart';
import 'package:spendigo/services/auth_service.dart';
import 'package:spendigo/view/DashBoard/main_screen.dart';

class GoogleLoginController {
  final AuthService _authService = AuthService();

  Future<void> signInWithGoogle(BuildContext context) async {
    final user = await _authService.signInWithGoogle();

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.primary,
          content: const Text("Google Sign-In canceled or failed"),
        ),
      );
    }
  }
}

// class GoogleLoginController {
//   /// Handles Google Sign-In
//   Future<void> signInWithGoogle(BuildContext context) async {
//     final user = await AuthService().signInWithGoogle();

//     if (user != null) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => MainScreen()),
//       );
//     } else {
//       // ScaffoldMessenger.of(context).showSnackBar(
//       //   const SnackBar(content: Text("Google Sign-In canceled or failed")),
//       // );
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           behavior: SnackBarBehavior.floating,
//           backgroundColor: AppColors.primary,
//           elevation: 8,
//           margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           content: Row(
//             children: [
//               const Icon(Icons.error_outline, color: Colors.white),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Text(
//                   "Google Sign-In canceled or failed",
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           duration: const Duration(seconds: 3),
//         ),
//       );
//     }
//   }
// }
