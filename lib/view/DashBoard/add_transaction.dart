// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendigo/config/colors.dart';
import 'package:spendigo/view/controller/transaction_controller.dart';
import 'package:spendigo/widgets/custom_app_bar.dart';
import 'package:spendigo/widgets/custom_textfield.dart';

class AddTransaction extends StatelessWidget {
  AddTransaction({super.key});

  final AddTransactionController controller = Get.put(
    AddTransactionController(),
  );

  final TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: CustomAppBar(
        title: "Add Transaction",
        showBackButton: true,
        arrowColor: Colors.white,
        backgroundColor: AppColors.primary,
        titleColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: 10),

                  /// TOGGLE
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildToggle(
                          "Expense",
                          !controller.isIncome.value,
                          () => controller.toggleIncome(false),
                        ),
                        SizedBox(width: 20),
                        _buildToggle(
                          "Income",
                          controller.isIncome.value,
                          () => controller.toggleIncome(true),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "How much?",
                      style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),

                  SizedBox(height: 10),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "\$0",
                      style: TextStyle(
                        fontSize: 48,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            /// BOTTOM
            Container(
              padding: EdgeInsets.all(20),
              constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
              child: Column(
                children: [
                  _buildDropdown("Category", controller.category.value, (val) {
                    controller.category.value = val;
                  }),

                  _buildDropdown("Wallet", controller.wallet.value, (val) {
                    controller.wallet.value = val;
                  }),

                  _buildDropdown("Budget", controller.budget.value, (val) {
                    controller.budget.value = val;
                  }),

                  SizedBox(height: 15),

                  CustomTextField(label: "Note", hintText: "Enter here"),

                  SizedBox(height: 15),

                  Container(
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Center(
                      child: Text(
                        "📎  Add attachment",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  /// REPEAT SWITCH
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Repeat",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              controller.repeat.value
                                  ? controller.repeatType.value
                                  : "Repeat transaction",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          value: controller.repeat.value,
                          onChanged: (val) {
                            controller.toggleRepeat(val);

                            if (val) {
                              _showRepeatDialog(context);
                            }
                          },
                          // ignore: deprecated_member_use
                          activeColor: AppColors.primary,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: () {
                          String type = controller.isIncome.value
                              ? "Income"
                              : "Expense";

                          print("Type: $type");
                          print("Category: ${controller.category.value}");
                          print("Wallet: ${controller.wallet.value}");
                          print("Budget: ${controller.budget.value}");
                          print("Note: ${noteController.text}");
                          print("Repeat: ${controller.repeat.value}");
                          print("Repeat Type: ${controller.repeatType.value}");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          controller.isIncome.value
                              ? "Add Income"
                              : "Add Expense",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// TOGGLE
  Widget _buildToggle(String text, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white70, width: 2),
            ),
            child: selected
                ? Center(
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                : null,
          ),
          SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }

  /// DROPDOWN
  Widget _buildDropdown(
    String label,
    String? value,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 15),
        Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
        SizedBox(height: 15),
        DropdownButtonFormField<String>(
          // ignore: deprecated_member_use
          value: value,
          hint: Text("Select"),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: AppColors.stroke),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: AppColors.stroke, width: 2),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          ),
          items: [
            "One",
            "Two",
            "Three",
          ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  /// REPEAT DIALOG (GETX VERSION)
  void _showRepeatDialog(BuildContext context) {
    List<String> options = [
      "Every day",
      "Every 2 days",
      "Every work day",
      "Every week",
      "Every 2 weeks",
      "Every 4 weeks",
      "Every month",
      "Every 2 months",
      "Every 4 months",
    ];

    showDialog(
      context: context,
      builder: (context) {
        return Obx(
          () => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            contentPadding: EdgeInsets.all(20),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Repeat",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  SizedBox(height: 15),

                  ...options.map((e) {
                    bool isSelected = controller.repeatType.value == e;

                    return InkWell(
                      onTap: () {
                        controller.setRepeatType(e);
                        Get.back();
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              e,
                              style: TextStyle(
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.black,
                              ),
                            ),
                            if (isSelected)
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primary,
                                ),
                                child: Center(
                                  child: CircleAvatar(
                                    radius: 4,
                                    backgroundColor: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
