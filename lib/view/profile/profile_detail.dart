import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:spendigo/config/colors.dart';
import 'package:spendigo/controller/profile_controller.dart';
import 'package:spendigo/view/profile/imagePicker/image_picker.dart';
import 'package:spendigo/widgets/custom_app_bar.dart';
import 'package:spendigo/widgets/custom_button.dart';
import 'package:spendigo/widgets/custom_textfield.dart';

class ProfileDetail extends StatefulWidget {
  const ProfileDetail({super.key});

  @override
  State<ProfileDetail> createState() => _ProfileDetailState();
}

class _ProfileDetailState extends State<ProfileDetail> {
  final controller = Get.find<ProfileController>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // preload existing data
    firstNameController.text = controller.firstName.value;
    lastNameController.text = controller.lastName.value;
    emailController.text = controller.email.value;
  }

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
              const SizedBox(height: 10),

              /// IMAGE PICKER
              GestureDetector(
                onTap: () => controller.pickImage(),
                child: ProfileImagePicker(),
              ),

              const SizedBox(height: 10),

              CustomTextField(
                label: "First Name",
                hintText: "First Name",
                controller: firstNameController,
              ),

              const SizedBox(height: 10),

              CustomTextField(
                label: "Last Name",
                hintText: "Last Name",
                controller: lastNameController,
              ),

              const SizedBox(height: 10),

              CustomTextField(
                label: "Email",
                hintText: "Email",
                controller: emailController,
              ),

              const SizedBox(height: 20),

              CustomButton(
                text: "Update",
                onPressed: () {
                  controller.updateProfile(
                    fName: firstNameController.text,
                    lName: lastNameController.text,
                    mail: emailController.text,
                  );

                  Get.back(); // go back to profile
                },
              ),

              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
