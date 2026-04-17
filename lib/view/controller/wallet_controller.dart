import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateWalletController extends GetxController {
  var sliderValue = 80.0.obs;
  var receiveAlert = true.obs;

  final TextEditingController nameController = TextEditingController();

  double get budgetAmount => sliderValue.value * 10;

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }
}
