// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendigo/config/colors.dart';
import 'package:spendigo/config/routes/routes_name.dart';
import 'package:spendigo/controller/wallet_controller.dart';
import 'package:spendigo/controller/currency_controller.dart';
import 'package:spendigo/view/wallets/graph/total_wealth_graph.dart';
import 'package:spendigo/widgets/custom_app_bar.dart';
import 'package:spendigo/widgets/custom_fab.dart';
import 'package:spendigo/widgets/wallet_tile.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Put or find the controller
    final controller = Get.put(CreateWalletController());

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
            const SizedBox(height: 15),

            Obx(() {
              if (controller.wallets.isEmpty) {
                return Column(
                  children: [
                    WalletTile(
                      amount:
                          "${Get.find<CurrencyController>().selectedCurrency.value} 0.00",
                      title: "No Wallets Added",
                      onTap: () {},
                    ),
                  ],
                );
              }
              return Column(
                children: controller.wallets.map((wallet) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: WalletTile(
                      amount:
                          "${Get.find<CurrencyController>().selectedCurrency.value} ${wallet.balance.toStringAsFixed(2)}",
                      title: wallet.name,
                      onTap: () {},
                    ),
                  );
                }).toList(),
              );
            }),
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
