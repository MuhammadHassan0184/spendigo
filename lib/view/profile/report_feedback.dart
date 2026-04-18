import 'package:flutter/material.dart';
import 'package:spendigo/config/colors.dart';
import 'package:spendigo/widgets/custom_app_bar.dart';
import 'package:spendigo/widgets/custom_button.dart';
import 'package:spendigo/widgets/custom_textfield.dart';

class ReportFeedback extends StatelessWidget {
  const ReportFeedback({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(title: "Report's & FeedBack", showBackButton: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 15),
            CustomTextField(label: "Name", hintText: "Enter your Name"),
            SizedBox(height: 15),
            CustomTextField(label: "Email", hintText: "Enter your Email"),
            SizedBox(height: 15),
            Row(
              children: [
                Text(
                  "Note",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 13),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.stroke),
                borderRadius: BorderRadius.circular(17),
              ),
              child: TextField(
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Type Your Note..",
                  hintStyle: TextStyle(color: AppColors.grey, fontSize: 14),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 15),
            CustomButton(text: "Send", onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
