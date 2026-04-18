import 'package:flutter/material.dart';
import 'package:spendigo/config/colors.dart';
import 'package:spendigo/widgets/custom_app_bar.dart';
import 'package:spendigo/widgets/custom_button.dart';
import 'package:spendigo/widgets/custom_textfield.dart';

class PasswordScreen extends StatelessWidget {
  const PasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(title: "password", showBackButton: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 10),
              CustomTextField(
                label: "Password",
                hintText: "password",
                isPassword: true,
              ),
              SizedBox(height: 10),
              CustomTextField(
                label: "Confirm Password",
                hintText: "Confirm password",
                isPassword: true,
              ),
              SizedBox(height: 20),
              CustomButton(text: "Update", onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
