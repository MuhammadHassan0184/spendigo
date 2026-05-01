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
                children: controller.wallets.asMap().entries.map((entry) {
                  int index = entry.key;
                  var wallet = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: WalletTile(
                      amount:
                          "${Get.find<CurrencyController>().selectedCurrency.value} ${wallet.balance.toStringAsFixed(2)}",
                      title: wallet.name,
                      onTap: () {
                        controller.initForEdit(wallet, index);
                        Get.toNamed(AppRoutesName.createWallet);
                      },
                      onLongPress: () {
                        _showDeleteDialog(controller, index, wallet.name);
                      },
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
          controller.clearFields();
          Get.toNamed(AppRoutesName.createWallet);
        },
      ),
    );
  }

  void _showDeleteDialog(
    CreateWalletController controller,
    int index,
    String walletName,
  ) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🔴 Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.delete, color: Colors.red, size: 28),
              ),

              const SizedBox(height: 15),

              // 📝 Title
              const Text(
                "Delete Wallet",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 10),

              // 📄 Description
              Text(
                "Are you sure you want to delete '$walletName'?",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),

              const SizedBox(height: 20),

              // 🔘 Buttons
              Row(
                children: [
                  // Cancel Button
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Delete Button
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6B6B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Get.back(); // close dialog first

                        controller.deleteWallet(index);

                        // optional delay (same as your transaction dialog)
                        Future.delayed(const Duration(milliseconds: 100), () {
                          // agar navigation chahiye ho to yahan add karo
                        });
                      },
                      child: const Text(
                        "Delete",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
