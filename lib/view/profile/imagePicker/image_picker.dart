import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendigo/view/controller/profile_controller.dart';

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
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xff2C8C7E), width: 2),
              ),
              child: CircleAvatar(
                radius: 60,
                backgroundImage: controller.image.value != null
                    ? FileImage(controller.image.value!)
                    : const AssetImage("assets/circle.png") as ImageProvider,
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
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xff2C8C7E),
                  ),
                  child: Icon(
                    hasImage ? Icons.delete : Icons.camera_alt,
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
