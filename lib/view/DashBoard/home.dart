// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendigo/config/colors.dart';
import 'package:spendigo/config/routes/routes_name.dart';
import 'package:spendigo/controller/profile_controller.dart';
import 'package:spendigo/controller/transaction_controller.dart';
import 'package:spendigo/widgets/custom_fab.dart';
import 'package:spendigo/widgets/home_transaction_tile.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final controller = Get.find<AddTransactionController>();
  final profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              /// ================= HEADER + CARD =================
              Stack(
                clipBehavior: Clip.none,
                children: [
                  /// GREEN HEADER
                  Container(
                    height: height * 0.25,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // SizedBox(height: height * 0.05),
                          SizedBox(height: 25),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Good afternoon,",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  SizedBox(height: 4),

                                  Obx(
                                    () => Text(
                                      profileController.fullName.isEmpty
                                          ? "User"
                                          : profileController.fullName,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white10,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.notifications_none,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// CIRCLE BG
                  Positioned(
                    top: -20,
                    left: -20,
                    child: Image.asset("assets/circle.png", width: 180),
                  ),

                  /// BALANCE CARD
                  Positioned(
                    bottom: -70,
                    left: width * 0.05,
                    right: width * 0.05,
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.26),
                            blurRadius: 10,
                            offset: Offset(2, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total Balance",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              // Icon(Icons.more_horiz, color: Colors.white),
                            ],
                          ),

                          SizedBox(height: 6),

                          Obx(
                            () => Text(
                              "Rs. ${controller.totalBalance.toStringAsFixed(2)}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          SizedBox(height: 16),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.arrow_downward,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        "Income",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  Obx(
                                    () => Text(
                                      "Rs. ${controller.totalIncome.toStringAsFixed(2)}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.arrow_upward,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        "Expenses",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  Obx(
                                    () => Text(
                                      "Rs. ${controller.totalExpense.toStringAsFixed(2)}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              /// ================= CONTENT =================
              Container(
                margin: EdgeInsets.only(top: height * 0.12),
                padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 1),

                    /// INCOME HEADER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Income",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                          onTap: () =>
                              Get.toNamed(AppRoutesName.transactionHistory),
                          child: Text("See all"),
                        ),
                      ],
                    ),

                    SizedBox(height: 10),

                    Obx(() {
                      final list = controller.transactions
                          .where((t) => t.type == "Income")
                          .take(3)
                          .toList();

                      if (list.isEmpty) {
                        return Column(
                          children: [
                            TransactionTile(
                              title: "Salary",
                              subtitle: "Company Ltd.",
                              amount: "+ Rs. 0.00",
                              iconPath: "assets/salary.svg",
                              color: AppColors.green,
                            ),
                            TransactionTile(
                              title: "Pocket Money",
                              subtitle: "Company Ltd.",
                              amount: "+ Rs. 0.00",
                              iconPath: "assets/pocketmoney.svg",
                              color: Colors.blue,
                            ),
                          ],
                        );
                      }

                      return Column(
                        children: list
                            .map(
                              (t) => TransactionTile(
                                title: t.category,
                                subtitle: t.note.isEmpty ? "No note" : t.note,
                                amount: "+ Rs. ${t.amount.toStringAsFixed(2)}",
                                iconPath: controller.getIconPath(t.category),
                                color: controller.getCategoryColor(t.category),
                                isIncome: true,
                              ),
                            )
                            .toList(),
                      );
                    }),

                    SizedBox(height: 10),

                    /// EXPENSE HEADER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Expenses",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                          onTap: () =>
                              Get.toNamed(AppRoutesName.transactionHistory),
                          child: Text("See all"),
                        ),
                      ],
                    ),

                    SizedBox(height: 10),

                    Obx(() {
                      final list = controller.transactions
                          .where((t) => t.type == "Expense")
                          .take(3)
                          .toList();

                      if (list.isEmpty) {
                        return Column(
                          children: [
                            TransactionTile(
                              title: "Entertainment",
                              subtitle: "Company Ltd.",
                              amount: "- Rs. 0.00",
                              iconPath: "assets/entertainment.svg",
                              color: Colors.blue.shade300,
                            ),
                            TransactionTile(
                              title: "Food & Drink",
                              subtitle: "Company Ltd.",
                              amount: "- Rs. 0.00",
                              iconPath: "assets/food.svg",
                              color: AppColors.yellowgreen,
                            ),
                          ],
                        );
                      }

                      return Column(
                        children: list
                            .map(
                              (t) => TransactionTile(
                                title: t.category,
                                subtitle: t.note.isEmpty ? "No note" : t.note,
                                amount: "- Rs. ${t.amount.toStringAsFixed(2)}",
                                iconPath: controller.getIconPath(t.category),
                                color: controller.getCategoryColor(t.category),
                                isIncome: false,
                              ),
                            )
                            .toList(),
                      );
                    }),

                    SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: CustomFAB(
        onTap: () {
          Get.toNamed(AppRoutesName.addTransaction);
        },
      ),
    );
  }
}
