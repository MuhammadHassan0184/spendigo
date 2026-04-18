// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:spendigo/config/colors.dart';
import 'package:spendigo/widgets/custom_app_bar.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(title: 'Privacy Policy', showBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SectionTitle(title: 'Spendigo Privacy Policy'),
            SizedBox(height: 10),
            SectionText(
              text:
                  'This Privacy Policy describes how Spendigo collects, uses, and protects your information when you use our application.',
            ),

            SizedBox(height: 20),
            SectionTitle(title: '1. Information We Collect'),
            SectionText(
              text:
                  'We may collect personal information such as your name, financial data, and app usage information to improve your experience.',
            ),

            SizedBox(height: 20),
            SectionTitle(title: '2. How We Use Your Information'),
            SectionText(
              text:
                  'Your information is used to manage your expenses, provide insights, improve features, and enhance app performance.',
            ),

            SizedBox(height: 20),
            SectionTitle(title: '3. Data Security'),
            SectionText(
              text:
                  'We implement strong security measures to protect your data. However, no system is 100% secure.',
            ),

            SizedBox(height: 20),
            SectionTitle(title: '4. Third-Party Services'),
            SectionText(
              text:
                  'We may use third-party services that collect information used to identify you. These services follow their own privacy policies.',
            ),

            SizedBox(height: 20),
            SectionTitle(title: '5. User Control'),
            SectionText(
              text:
                  'You can update or delete your data anytime within the app settings.',
            ),

            SizedBox(height: 20),
            SectionTitle(title: '6. Changes to This Policy'),
            SectionText(
              text:
                  'We may update our Privacy Policy from time to time. Changes will be posted on this screen.',
            ),

            SizedBox(height: 20),
            SectionTitle(title: '7. Contact Us'),
            SectionText(
              text:
                  'If you have any questions about this Privacy Policy, contact us at The Web Concept.',
            ),

            SizedBox(height: 10),
            Divider(),
            SizedBox(height: 10),

            ContactSection(),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
    );
  }
}

class SectionText extends StatelessWidget {
  final String text;
  final bool isCenter;

  const SectionText({super.key, required this.text, this.isCenter = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: isCenter ? TextAlign.center : TextAlign.start,
      style: TextStyle(
        fontSize: 14,
        color: AppColors.primary.withOpacity(0.8),
        height: 1.5,
      ),
    );
  }
}

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Row(
            children: [
              // Icon(Icons.person, size: 18),
              // SizedBox(width: 8),
              // Text(
              //   'Muhammad Hassan',
              //   style: TextStyle(fontWeight: FontWeight.bold),
              // ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.business, size: 18),
              SizedBox(width: 8),
              Text('The Web Concept'),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.email, size: 18),
              SizedBox(width: 8),
              Text('info@thewebconcept.com'),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.language, size: 18),
              SizedBox(width: 8),
              Text('thewebconcept.com'),
            ],
          ),
        ],
      ),
    );
  }
}
