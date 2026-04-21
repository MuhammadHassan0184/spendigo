import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:spendigo/config/colors.dart';
import 'package:spendigo/controller/Auth_controller/password_controller.dart';
import 'package:spendigo/widgets/custom_app_bar.dart';
import 'package:spendigo/widgets/custom_button.dart';
import 'package:spendigo/widgets/custom_textfield.dart';

class PasswordScreen extends StatelessWidget {
  PasswordScreen({super.key});

  final controller = Get.put(PasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(title: "Password", showBackButton: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 10),

              CustomTextField(
                label: "New Password",
                hintText: "New password",
                isPassword: true,
                controller: controller.passwordController,
              ),

              const SizedBox(height: 10),

              CustomTextField(
                label: "Confirm Password",
                hintText: "Confirm password",
                isPassword: true,
                controller: controller.confirmPasswordController,
              ),

              const SizedBox(height: 20),

              Obx(() {
                return CustomButton(
                  text: controller.isLoading.value ? "Updating..." : "Update",
                  onPressed: controller.updatePassword,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
