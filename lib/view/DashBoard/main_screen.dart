import 'package:flutter/material.dart';
import 'package:spendigo/view/DashBoard/home.dart';
import 'package:spendigo/view/statistics/statistics_screen.dart';
import 'package:spendigo/view/wallets/wallet_screen.dart';
import 'package:spendigo/widgets/custom_navbar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  final List<Widget> screens = [
    Home(),
    StatisticsScreen(),
    WalletScreen(),
    Center(child: Text("Budgets")),
    Center(child: Text("Profile")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedIndex],

      bottomNavigationBar: CustomBottomNav(
        selectedIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}
