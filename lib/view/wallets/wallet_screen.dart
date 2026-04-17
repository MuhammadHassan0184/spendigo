// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/utils.dart';
import 'package:spendigo/config/colors.dart';
import 'package:spendigo/config/routes/routes_name.dart';
import 'package:spendigo/view/wallets/graph/total_wealth_graph.dart';
import 'package:spendigo/widgets/custom_app_bar.dart';
import 'package:spendigo/widgets/custom_fab.dart';
import 'package:spendigo/widgets/wallet_tile.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(title: "Wallets"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TotalWealthChart(),
            ),
            SizedBox(height: 15),
            WalletTile(
              amount: "Rs.245,000",
              title: "Wallet Name",
              onTap: () {},
            ),
            SizedBox(height: 15),
            WalletTile(
              amount: "Rs.440,000",
              title: "Second Wallet Name",
              onTap: () {},
            ),
          ],
        ),
      ),
      floatingActionButton: CustomFAB(
        onTap: () {
          Get.toNamed(AppRoutesName.createWallet);
        },
      ),
    );
  }
}
