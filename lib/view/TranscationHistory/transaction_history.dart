import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendigo/config/colors.dart';
import 'package:spendigo/controller/transaction_controller.dart';
import 'package:spendigo/controller/currency_controller.dart';
import 'package:spendigo/widgets/custom_app_bar.dart';
import 'package:spendigo/widgets/home_transaction_tile.dart';
import 'package:spendigo/view/TranscationHistory/transaction_details.dart';

class TransactionHistory extends StatelessWidget {
  TransactionHistory({super.key});

  final AddTransactionController controller =
      Get.find<AddTransactionController>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: CustomAppBar(
          title: "Transaction History",
          showBackButton: true,
        ),
        body: Column(
          children: [
            TabBar(
              labelColor: AppColors.primary,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.primary,
              tabs: [
                Tab(text: "Income"),
                Tab(text: "Expense"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [_buildList("Income"), _buildList("Expense")],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(String type) {
    return Obx(() {
      final list = controller.transactions
          .where((t) => t.type == type)
          .toList();
      if (list.isEmpty) {
        return Center(child: Text("No $type transactions yet"));
      }
      return ListView.builder(
        padding: EdgeInsets.all(20),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final t = list[index];
          return TransactionTile(
            title: t.category,
            subtitle: t.note.isEmpty ? "No note" : t.note,
            amount:
                "${type == "Income" ? "+" : "-"} ${Get.find<CurrencyController>().selectedCurrency.value} ${t.amount.toStringAsFixed(2)}",
            iconPath: controller.getIconPath(t.category),
            color: controller.getCategoryColor(t.category),
            isIncome: type == "Income",
            onTap: () {
              Get.to(() => TransactionDetails(transaction: t));
            },
          );
        },
      );
    });
  }
}
