import 'package:flutter/material.dart';
import 'package:spendigo/config/colors.dart';
import 'package:spendigo/widgets/custom_app_bar.dart';
import 'package:spendigo/widgets/custom_button.dart';
import 'package:spendigo/widgets/custom_textfield.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportFeedback extends StatefulWidget {
  const ReportFeedback({super.key});

  @override
  State<ReportFeedback> createState() => _ReportFeedbackState();
}

class _ReportFeedbackState extends State<ReportFeedback> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  Future<void> sendEmail() async {
    final String name = nameController.text.trim();
    final String email = emailController.text.trim();
    final String note = noteController.text.trim();

    // ✅ Validation
    if (name.isEmpty || email.isEmpty || note.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields"),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // ✅ Email format check
    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Enter a valid email address"),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'info@thewebconcept.com',
      query: Uri.encodeFull(
        'subject=User Feedback&body=Name: $name\nEmail: $email\n\nNote:\n$note',
      ),
    );

    try {
      await launchUrl(emailUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Something went wrong",),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(title: "Report's & FeedBack", showBackButton: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 15),

              CustomTextField(
                label: "Name",
                hintText: "Enter your Name",
                controller: nameController,
              ),

              SizedBox(height: 15),

              CustomTextField(
                label: "Email",
                hintText: "Enter your Email",
                controller: emailController,
              ),

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
                  controller: noteController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Type Your Note..",
                    hintStyle: TextStyle(color: AppColors.grey, fontSize: 14),
                    border: InputBorder.none,
                  ),
                ),
              ),

              SizedBox(height: 15),

              CustomButton(text: "Send", onPressed: sendEmail),
            ],
          ),
        ),
      ),
    );
  }
}
