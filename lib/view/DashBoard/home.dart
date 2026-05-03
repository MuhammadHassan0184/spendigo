// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendigo/config/colors.dart';
import 'package:spendigo/config/routes/routes_name.dart';
import 'package:spendigo/controller/profile_controller.dart';
import 'package:spendigo/controller/transaction_controller.dart';
import 'package:spendigo/controller/currency_controller.dart';
import 'package:spendigo/controller/notification_controller.dart';
import 'package:spendigo/widgets/custom_fab.dart';
import 'package:spendigo/widgets/home_transaction_tile.dart';
import 'package:spendigo/view/TranscationHistory/transaction_details.dart';
import 'package:spendigo/widgets/currency_bottom_sheet.dart';
import 'package:spendigo/widgets/pulse_animation.dart';

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
                          SizedBox(height: 25),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "good_afternoon".tr,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  SizedBox(height: 4),

                                  Obx(
                                    () => Text(
                                      profileController.fullName.isEmpty
                                          ? "user".tr
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

                              Row(
                                children: [
                                  /// Report icon
                                  GestureDetector(
                                    onTap: () =>
                                        Get.toNamed(AppRoutesName.reports),
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.white10,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.assessment_outlined,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  /// notification icon
                                  Obx(() {
                                    final notifCtrl =
                                        Get.find<NotificationController>();
                                    final count = notifCtrl.unreadCount;
                                    return GestureDetector(
                                      onTap: () => Get.toNamed(
                                        AppRoutesName.notificationHistory,
                                      ),
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              color: Colors.white10,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: const Icon(
                                              Icons.notifications_none,
                                              color: Colors.white,
                                            ),
                                          ),
                                          if (count > 0)
                                            Positioned(
                                              top: -5,
                                              right: -5,
                                              child: Container(
                                                padding: const EdgeInsets.all(
                                                  3,
                                                ),
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFFFF6B6B),
                                                  shape: BoxShape.circle,
                                                ),
                                                constraints:
                                                    const BoxConstraints(
                                                      minWidth: 18,
                                                      minHeight: 18,
                                                    ),
                                                child: Text(
                                                  count > 99 ? '99+' : '$count',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// CIRCLE BG
                  PositionedDirectional(
                    top: -20,
                    start: -20,
                    child: IgnorePointer(
                      child: Image.asset("assets/circle.png", width: 180),
                    ),
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
                                "total_balance".tr,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 6),

                          Obx(() {
                            final currencyController =
                                Get.find<CurrencyController>();
                            return Row(
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        currencyController.markHintAsSeen();
                                        showCurrencyBottomSheet(context);
                                      },
                                      child: Obx(() {
                                        final content = Text(
                                          "${currencyController.selectedCurrency.value} ",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 26,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );

                                        return !currencyController
                                                .hasSeenHint
                                                .value
                                            ? PulseAnimation(child: content)
                                            : content;
                                      }),
                                    ),
                                  ],
                                ),
                                Text(
                                  controller.totalBalance.toStringAsFixed(2),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            );
                          }),

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
                                        "income".tr,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  Obx(() {
                                    final currencyController =
                                        Get.find<CurrencyController>();
                                    return Text(
                                      "${currencyController.selectedCurrency.value} ${controller.totalIncome.toStringAsFixed(2)}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  }),
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
                                        "expense".tr,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  Obx(() {
                                    final currencyController =
                                        Get.find<CurrencyController>();
                                    return Text(
                                      "${currencyController.selectedCurrency.value} ${controller.totalExpense.toStringAsFixed(2)}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  }),
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
                    /// INCOME HEADER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "income".tr,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                          onTap: () =>
                              Get.toNamed(AppRoutesName.transactionHistory),
                          child: Text("see_all".tr),
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
                        return TransactionTile(
                          title: "income".tr,
                          subtitle: "Company Ltd.",
                          amount: "+ Rs. 0.00",
                          iconPath: "assets/salary.svg",
                          color: AppColors.green,
                        );
                      }

                      return Column(
                        children: list
                            .map(
                              (t) => TransactionTile(
                                title: t.category,
                                subtitle: t.note.isEmpty
                                    ? "no_note".tr
                                    : t.note,
                                amount:
                                    "+ ${Get.find<CurrencyController>().selectedCurrency.value} ${t.amount.toStringAsFixed(2)}",
                                iconPath: controller.getIconPath(t.category),
                                color: controller.getCategoryColor(t.category),
                                isIncome: true,
                                onTap: () {
                                  Get.to(
                                    () => TransactionDetails(transaction: t),
                                  );
                                },
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
                          "expenses".tr,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                          onTap: () =>
                              Get.toNamed(AppRoutesName.transactionHistory),
                          child: Text("see_all".tr),
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
                              title: "expenses".tr,
                              subtitle: "Company Ltd.",
                              amount: "- Rs. 0.00",
                              iconPath: "assets/entertainment.svg",
                              color: Colors.blue.shade300,
                            ),
                          ],
                        );
                      }

                      return Column(
                        children: list
                            .map(
                              (t) => TransactionTile(
                                title: t.category,
                                subtitle: t.note.isEmpty
                                    ? "no_note".tr
                                    : t.note,
                                amount:
                                    "- ${Get.find<CurrencyController>().selectedCurrency.value} ${t.amount.toStringAsFixed(2)}",
                                iconPath: controller.getIconPath(t.category),
                                color: controller.getCategoryColor(t.category),
                                isIncome: false,
                                onTap: () {
                                  Get.to(
                                    () => TransactionDetails(transaction: t),
                                  );
                                },
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
          controller.clearFields();
          Get.toNamed(AppRoutesName.addTransaction);
        },
      ),
    );
  }
}
