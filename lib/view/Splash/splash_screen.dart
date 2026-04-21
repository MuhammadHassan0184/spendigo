import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendigo/config/routes/routes_name.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      _checkAppState();
    });
  }

  Future<void> _checkAppState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;

    if (!onboardingCompleted) {
      // First time user, show onboarding
      Get.offAllNamed(AppRoutesName.onboarding1);
    } else {
      // Onboarding completed, check auth
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // User is logged in, go to home
        Get.offAllNamed(AppRoutesName.mainScreen);
      } else {
        // User not logged in, go to sign in
        Get.offAllNamed(AppRoutesName.signIn);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/splash_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/spendigo-logo.svg', height: 150),
          ],
        ),
      ),
    );
  }
}