
import 'package:get/get.dart';
import 'package:spendigo/config/routes/routes_name.dart';
import 'package:spendigo/view/Auth/ForgotPassword/forgot_password.dart';
import 'package:spendigo/view/Auth/sign_in.dart';
import 'package:spendigo/view/Auth/sign_up.dart';
import 'package:spendigo/view/DashBoard/add_transaction.dart';
import 'package:spendigo/view/DashBoard/home.dart';
import 'package:spendigo/view/Splash/splash_screen.dart';
import 'package:spendigo/view/budgets/budget_screen.dart';
import 'package:spendigo/view/onboarding/onboarding1.dart';
import 'package:spendigo/view/profile/password_screen.dart';
import 'package:spendigo/view/profile/profile.dart';
import 'package:spendigo/view/profile/profile_detail.dart';
import 'package:spendigo/view/statistics/statistics_screen.dart';
import 'package:spendigo/view/wallets/wallet_screen.dart';

class AppRoutes {
  // ignore: strict_top_level_inference
  static routes() => [
    GetPage(name: AppRoutesName.splash, page: () => const SplashScreen()),
    GetPage(name: AppRoutesName.onboarding1, page: () => const Onboarding1(initialPage: 0)),
    GetPage(name: AppRoutesName.onboarding2, page: () => const Onboarding1(initialPage: 1)),
    GetPage(name: AppRoutesName.onboarding3, page: () => const Onboarding1(initialPage: 2)),
    GetPage(name: AppRoutesName.signIn, page: () => const SignIn()),
    GetPage(name: AppRoutesName.signUp, page: () => const Signup()),
    GetPage(name: AppRoutesName.home, page: () => const Home()),
    GetPage(name: AppRoutesName.statistics, page: () => const StatisticsScreen()),
    GetPage(name: AppRoutesName.wallet, page: () => const WalletScreen()),
    GetPage(name: AppRoutesName.budgets, page: () => const BudgetsScreen()),
    GetPage(name: AppRoutesName.profile, page: () => const ProfileScreen()),
    GetPage(name: AppRoutesName.profileDetail, page: () => const ProfileDetail()),
    GetPage(name: AppRoutesName.password, page: () => const PasswordScreen()),
    GetPage(name: AppRoutesName.forgotPassword, page: () => const ForgotPassword()),
    GetPage(name: AppRoutesName.addTransaction, page: () => AddTransaction()),

  ];
}