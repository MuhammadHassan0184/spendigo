// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:spendigo/config/routes/routes_name.dart';
import 'package:spendigo/Models/transaction_model.dart';
import 'package:spendigo/config/colors.dart';
import 'package:spendigo/controller/transaction_controller.dart';
import 'package:spendigo/controller/currency_controller.dart';
import 'package:spendigo/widgets/custom_app_bar.dart';

class TransactionDetails extends StatelessWidget {
  final TransactionModel transaction;

  TransactionDetails({super.key, required this.transaction});

  final AddTransactionController controller =
      Get.find<AddTransactionController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentTransaction = controller.transactions.firstWhere(
        (t) => t.date == transaction.date,
        orElse: () => transaction,
      );
      final currency = Get.find<CurrencyController>().selectedCurrency.value;
      final isIncome = currentTransaction.type == "Income";

      return Scaffold(
        backgroundColor: AppColors.white,
        appBar: CustomAppBar(
          title: "Transaction Details",
          showBackButton: true,
          actions: [
            IconButton(
              icon: Icon(Icons.edit, color: AppColors.primary),
              onPressed: () {
                controller.initForEdit(currentTransaction);
                Get.toNamed(AppRoutesName.addTransaction);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                Get.dialog(
                  Dialog(
                    backgroundColor: Colors.transparent,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white, // your app background
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 🔴 Icon
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 28,
                            ),
                          ),

                          SizedBox(height: 15),

                          // 📝 Title
                          Text(
                            "Delete Transaction",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),

                          SizedBox(height: 10),

                          // 📄 Description
                          Text(
                            "Are you sure you want to delete this transaction?",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),

                          SizedBox(height: 20),

                          // 🔘 Buttons
                          Row(
                            children: [
                              // Cancel Button
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),

                              SizedBox(width: 10),

                              // Delete Button
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    Get.back(); // close dialog first

                                    controller.deleteTransaction(
                                      currentTransaction,
                                    );

                                    Future.delayed(
                                      Duration(milliseconds: 100),
                                      () {
                                        Get.offAllNamed(AppRoutesName.home);
                                      },
                                    );
                                  },
                                  child: Text(
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
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            // Re-load transactions from Hive to ensure data is up to date
            await Future.delayed(const Duration(seconds: 1));
            controller.loadTransactions();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: controller
                              .getCategoryColor(currentTransaction.category)
                              .withAlpha(25),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                          color: controller.getCategoryColor(
                            currentTransaction.category,
                          ),
                          size: 40,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        currentTransaction.category,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "${isIncome ? "+" : "-"} $currency ${currentTransaction.amount.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: isIncome ? AppColors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                _buildDetailItem("Type", currentTransaction.type),
                _buildDetailItem(
                  "Date",
                  DateFormat(
                    'MMM dd, yyyy - hh:mm a',
                  ).format(currentTransaction.date),
                ),
                _buildDetailItem("Wallet", currentTransaction.wallet),
                _buildDetailItem("Budget", currentTransaction.budget),
                _buildDetailItem(
                  "Note",
                  currentTransaction.note.isEmpty
                      ? "No note added"
                      : currentTransaction.note,
                ),

                if (currentTransaction.attachmentPath != null) ...[
                  SizedBox(height: 20),
                  Text(
                    "Attachment",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.file(
                      File(currentTransaction.attachmentPath!),
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 100,
                          color: Colors.grey.shade200,
                          child: Center(child: Text("Image not found")),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
