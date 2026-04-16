import 'package:flutter/material.dart';
import 'package:spendigo/config/colors.dart';
import 'package:spendigo/view/profile/imagePicker/image_picker.dart';
import 'package:spendigo/widgets/custom_app_bar.dart';

class ProfileDetail extends StatelessWidget {
  const ProfileDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(title: "Profile Detail", showBackButton: true),
      body: Column(children: [ProfileImagePicker()]),
    );
  }
}
