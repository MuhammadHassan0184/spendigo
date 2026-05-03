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
import 'package:spendigo/controller/currency_controller.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spendigo/Models/transaction_model.dart';
import 'package:spendigo/Models/wallet_model.dart';
import 'package:spendigo/Models/budget_model.dart';
import 'package:spendigo/Models/notification_model.dart';
import 'package:spendigo/controller/notification_controller.dart';
import 'package:spendigo/services/notification_service.dart';
import 'package:spendigo/services/localization_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.init();
  print("Starting Firebase init...");

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      print("Firebase initialized SUCCESSFULLY!");
    }
  } catch (e) {
    print("Firebase Init Error: $e");
  }

  // Initialize Hive
  await Hive.initFlutter(); // Prepares the device's local path for storage.

  // Register Adapters
  Hive.registerAdapter(
    TransactionModelAdapter(),
  ); // Tells Hive which custom models to expect. Without this, Hive wouldn't know how to read your WalletModel.
  Hive.registerAdapter(WalletModelAdapter());
  Hive.registerAdapter(BudgetModelAdapter());
  Hive.registerAdapter(NotificationModelAdapter());

  await Hive.openBox('settings');

  runApp(const MyApp());
}

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
          title: 'Spendigo',
          translations: LocalizationService(),
          locale: LocalizationService.getCurrentLocale(),
          fallbackLocale: LocalizationService.fallbackLocale,
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
    Get.put(CurrencyController(), permanent: true);
    Get.put(NotificationController(), permanent: true);
  }
}
