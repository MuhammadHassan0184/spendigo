import 'package:flutter/material.dart';
import 'package:spendigo/config/colors.dart';
import 'package:spendigo/view/profile/imagePicker/image_picker.dart';
import 'package:spendigo/widgets/custom_app_bar.dart';
import 'package:spendigo/widgets/custom_button.dart';
import 'package:spendigo/widgets/custom_textfield.dart';

class ProfileDetail extends StatelessWidget {
  const ProfileDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(title: "Profile Detail", showBackButton: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 10,),
              ProfileImagePicker(),
              SizedBox(height: 10,),
              CustomTextField(label: "First Name", hintText: "First Name"),
              SizedBox(height: 10,),
              CustomTextField(label: "Last Name", hintText: "Last Name"),
              SizedBox(height: 10,),
              CustomTextField(label: "Email", hintText: "Email"),
              SizedBox(height: 20,),
              CustomButton(text: "Update", onPressed: (){}),
              SizedBox(height: 15,),
          
              ]
              ),
        ),
      ),
    );
  }
}
