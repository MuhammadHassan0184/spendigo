import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendigo/config/colors.dart';

void showCustomSnackBar(
  String title,
  String message, {
  bool isError = false,
}) {
  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: isError ? Colors.redAccent : AppColors.primary,
    colorText: Colors.white,
    duration: const Duration(seconds: 3),
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    borderRadius: 12,
    icon: Icon(
      isError ? Icons.error_outline : Icons.check_circle_outline,
      color: Colors.white,
    ),
  );
}
