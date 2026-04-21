// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/route_manager.dart';
import 'package:spendigo/config/colors.dart';
import 'package:spendigo/config/routes/routes_name.dart';
import 'package:spendigo/controller/profile_controller.dart';
import 'package:spendigo/widgets/setting_tile.dart';
import 'package:share_plus/share_plus.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController controller = Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _Header(),
              _ProfileCard(),
              // _SettingsSection(),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.stroke, width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    CustomListTile(
                      title: "Password",
                      svgPath: "assets/password.svg",
                      onTap: () {
                        Get.toNamed(AppRoutesName.password);
                      },
                    ),
                    // Divider(height: 1, color: AppColors.stroke),
                    // CustomListTile(
                    //   title: "FAQ",
                    //   svgPath: "assets/faqs.svg",
                    //   onTap: () {},
                    // ),
                    Divider(height: 1, color: AppColors.stroke),
                    CustomListTile(
                      title: "Bug report & Feedback",
                      svgPath: "assets/report.svg",
                      onTap: () {
                        Get.toNamed(AppRoutesName.reportFeedback);
                      },
                    ),
                    Divider(height: 1, color: AppColors.stroke),
                    CustomListTile(
                      title: "Rate us on Google Play",
                      svgPath: "assets/star.svg",
                      onTap: () {},
                    ),
                    Divider(height: 1, color: AppColors.stroke),
                    CustomListTile(
                      title: "Share with friends",
                      svgPath: "assets/share.svg",
                      onTap: () {
                        Share.share(
                          'Manage your expenses easily with Spendigo 🚀\nDownload now: https://play.google.com/store/apps/details?id=com.yourapp.package',
                        );
                      },
                    ),
                    Divider(height: 1, color: AppColors.stroke),
                    CustomListTile(
                      title: "Privacy Policy",
                      svgPath: "assets/privacy.svg",
                      onTap: () {
                        Get.toNamed(AppRoutesName.privacyPolicyScreen);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // logout Button
              GestureDetector(
                onTap: () {
                  Get.offAllNamed(AppRoutesName.signIn);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Log Out',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Icon(
                          Icons.logout,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 130,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          alignment: Alignment.center,
          child: const Text(
            'Profile',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Positioned(
          top: -20,
          left: -20,
          child: Image.asset("assets/circle.png", width: 180),
        ),
      ],
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard();

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -35), // overlap effect
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: const [
              _Avatar(),
              SizedBox(width: 16),
              Expanded(child: _UserInfo()),
              _EditButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return Obx(() {
      return Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade200, width: 2),
          image: DecorationImage(
            image: controller.image.value != null
                ? FileImage(controller.image.value!)
                : const AssetImage("assets/profile.jpeg") as ImageProvider,
            fit: BoxFit.cover,
          ),
        ),
      );
    });
  }
}

class _UserInfo extends StatelessWidget {
  const _UserInfo();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            controller.fullName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            controller.email.value,
            style: const TextStyle(color: Color(0xFFD9D9D9), fontSize: 13),
          ),
        ],
      );
    });
  }
}

class _EditButton extends StatelessWidget {
  const _EditButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutesName.profileDetail);
      },

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(Icons.edit, color: AppColors.primary, size: 14),
            const SizedBox(width: 4),
            Text(
              'Edit',
              style: TextStyle(color: AppColors.primary, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
