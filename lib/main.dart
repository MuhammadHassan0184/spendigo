// ignore_for_file: avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spendigo/config/routes/routes.dart';
import 'package:spendigo/firebase_options.dart';
import 'package:spendigo/view/Splash/splash_screen.dart';
import 'package:get/get.dart';
import 'package:spendigo/controller/wallet_controller.dart';
import 'package:spendigo/controller/transaction_controller.dart';
import 'package:spendigo/controller/budget_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await NotificationService.init();
  print("Starting Firebase init...");

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase initialized SUCCESSFULLY!");
  } catch (e) {
    print("Firebase Init Error: $e");
  }

  runApp(const MyApp());
}

// void main() {
//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // Your UI design size (important)
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',

          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),

          getPages: AppRoutes.routes(),
          home: const SplashScreen(),
          initialBinding: GlobalBinding(),
        );
      },
    );
  }
}

class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CreateWalletController(), permanent: true);
    Get.put(AddTransactionController(), permanent: true);
    Get.put(CreateBudgetController(), permanent: true);
  }
}
