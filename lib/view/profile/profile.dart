// ignore_for_file: avoid_print, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendigo/config/colors.dart';
import 'package:spendigo/config/routes/routes_name.dart';
import 'package:spendigo/controller/profile_controller.dart';
import 'package:spendigo/services/auth_service.dart';
import 'package:spendigo/services/hive_service.dart';
import 'package:spendigo/widgets/setting_tile.dart';
import 'package:spendigo/services/localization_service.dart';
import 'package:spendigo/services/biometric_service.dart';
import 'package:spendigo/services/backup_service.dart';
import 'package:share_plus/share_plus.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
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

              /// ================= SETTINGS SECTION =================
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
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Text(
                        'settings'.tr,
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    CustomListTile(
                      title: "password".tr,
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(height: 1, color: AppColors.stroke),
                    ),
                    CustomListTile(
                      title: "bug_report".tr,
                      svgPath: "assets/report.svg",
                      onTap: () {
                        Get.toNamed(AppRoutesName.reportFeedback);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(height: 1, color: AppColors.stroke),
                    ),
                    CustomListTile(
                      title: "rate_us".tr,
                      svgPath: "assets/star.svg",
                      onTap: () {},
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(height: 1, color: AppColors.stroke),
                    ),
                    CustomListTile(
                      title: "share_with_friends".tr,
                      svgPath: "assets/share.svg",
                      onTap: () {
                        Share.share(
                          'Manage your expenses easily with Spendigo 🚀\nDownload now: https://play.google.com/store/apps/details?id=com.yourapp.package',
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(height: 1, color: AppColors.stroke),
                    ),
                    CustomListTile(
                      title: "privacy_policy".tr,
                      svgPath: "assets/privacy.svg",
                      onTap: () {
                        Get.toNamed(AppRoutesName.privacyPolicyScreen);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(height: 1, color: AppColors.stroke),
                    ),
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(7),
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.language,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        "language".tr,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: AppColors.primary,
                        size: 25,
                      ),
                      onTap: () {
                        Get.dialog(
                          Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 20,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Header
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.language,
                                      color: AppColors.primary,
                                      size: 30,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    "select_language".tr,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 20),

                                  // Language List
                                  ...LocalizationService.langs.map((lang) {
                                    final bool isSelected =
                                        LocalizationService.getCurrentLocale() ==
                                        LocalizationService.getLocaleFromLang(
                                          lang,
                                        );

                                    return GestureDetector(
                                      onTap: () {
                                        LocalizationService.changeLocale(lang);
                                        Get.back();
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                          bottom: 12,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? AppColors.primary.withOpacity(
                                                  0.05,
                                                )
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: isSelected
                                                ? AppColors.primary
                                                : Colors.grey.shade200,
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              lang,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: isSelected
                                                    ? FontWeight.bold
                                                    : FontWeight.w500,
                                                color: isSelected
                                                    ? AppColors.primary
                                                    : AppColors.black,
                                              ),
                                            ),
                                            const Spacer(),
                                            if (isSelected)
                                              Icon(
                                                Icons.check_circle,
                                                color: AppColors.primary,
                                                size: 20,
                                              )
                                            else
                                              Icon(
                                                Icons.circle_outlined,
                                                color: Colors.grey.shade300,
                                                size: 20,
                                              ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),

                                  const SizedBox(height: 8),
                                  TextButton(
                                    onPressed: () => Get.back(),
                                    child: Text(
                                      "cancel".tr,
                                      style: TextStyle(
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              /// ================= SECURITY SECTION =================
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
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Text(
                        'security'.tr,
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    StatefulBuilder(
                      builder: (context, setState) {
                        return ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(7),
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.fingerprint,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            "biometric_lock".tr,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          trailing: Switch(
                            value: BiometricService.isBiometricEnabled(),
                            onChanged: (value) async {
                              await BiometricService.setBiometricEnabled(value);
                              setState(() {});
                            },
                            activeColor: AppColors.primary,
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 5),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              /// ================= BACKUP SECTION =================
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
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Text(
                        'data_management'.tr,
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    CustomListTile(
                      title: "backup_data".tr,
                      svgPath: "assets/share.svg",
                      iconColor: AppColors.primary,
                      onTap: () => BackupService.exportBackup(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(height: 1, color: AppColors.stroke),
                    ),
                    CustomListTile(
                      title: "restore_data".tr,
                      svgPath: "assets/wallet.svg",
                      iconColor: AppColors.primary,
                      onTap: () => BackupService.importBackup(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // logout Button
              GestureDetector(
                onTap: () async {
                  HiveService.clearAllControllers(); // Clear UI state before firebase logout
                  await _authService.logout(); // logout from firebase
                  LocalizationService.resetToDefault(); // reset locale to default
                  Get.offAllNamed(
                    AppRoutesName.signIn,
                  ); // clear stack & go login
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
                        'logout'.tr,
                        style: const TextStyle(
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
          child: Text(
            'profile'.tr,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        PositionedDirectional(
          top: -20,
          start: -20,
          child: IgnorePointer(
            child: Image.asset("assets/circle.png", width: 180),
          ),
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
                : const AssetImage("assets/profilem.jpg") as ImageProvider,
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
              'edit'.tr,
              style: TextStyle(color: AppColors.primary, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
