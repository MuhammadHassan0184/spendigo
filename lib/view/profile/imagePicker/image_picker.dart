import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendigo/config/colors.dart';
import 'package:spendigo/controller/profile_controller.dart';

class ProfileImagePicker extends StatelessWidget {
  ProfileImagePicker({super.key});

  final controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          /// Profile Image
          Obx(() {
            return Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              child: CircleAvatar(
                radius: 60,
                backgroundImage: controller.image.value != null
                    ? FileImage(controller.image.value!)
                    : const AssetImage("assets/profilem.jpg") as ImageProvider,
              ),
            );
          }),

          /// Button
          Positioned(
            bottom: -10,
            child: Obx(() {
              final hasImage = controller.image.value != null;

              return GestureDetector(
                onTap: hasImage ? controller.deleteImage : controller.pickImage,
                child: Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                  child: Icon(
                    hasImage
                        ? Icons.delete_forever_rounded
                        : Icons.image_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
