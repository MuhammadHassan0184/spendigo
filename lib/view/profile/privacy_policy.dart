// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:spendigo/config/colors.dart';
import 'package:spendigo/widgets/custom_app_bar.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: 'Privacy Policy', showBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
            HeaderCard(),

            SizedBox(height: 16),

            PolicyCard(
              title: 'Information We Collect',
              icon: Icons.lock_outline,
              content:
                  '• Personal Info: Name & email via Firebase\n'
                  '• Financial Data: Income, expenses, budgets\n'
                  '• Media: Transaction images\n'
                  '• Biometrics: Handled by device only',
            ),

            PolicyCard(
              title: 'Data Storage & Security',
              icon: Icons.security,
              content:
                  'Data is محفوظ using Hive (offline storage) and Firebase security standards for backup and sync.',
            ),

            PolicyCard(
              title: 'How We Use Data',
              icon: Icons.analytics_outlined,
              content:
                  '• Track transactions\n'
                  '• Generate reports\n'
                  '• Send alerts\n'
                  '• Backup & restore',
            ),

            PolicyCard(
              title: 'Third-Party Services',
              icon: Icons.cloud_outlined,
              content:
                  '• Firebase (Auth & Sync)\n'
                  '• Hive (Local Database)',
            ),

            PolicyCard(
              title: 'User Rights',
              icon: Icons.verified_user_outlined,
              content:
                  'You can edit, delete, export, or fully control your data anytime.',
            ),

            SizedBox(height: 20),

            ContactSection(),
          ],
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////
/// 🔷 HEADER CARD (Top Highlight)
//////////////////////////////////////////////////////////////////

class HeaderCard extends StatelessWidget {
  const HeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.privacy_tip, color: Colors.white, size: 30),
          const SizedBox(height: 10),
          const Text(
            "Spendigo Privacy Policy",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Your data security is our priority. This policy explains how we handle your information.",
            style: TextStyle(color: Colors.white.withOpacity(0.9), height: 1.4),
          ),
        ],
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////
/// 🔷 POLICY CARD (Reusable)
//////////////////////////////////////////////////////////////////

class PolicyCard extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;

  const PolicyCard({
    super.key,
    required this.title,
    required this.content,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////
/// 🔷 CONTACT SECTION (UPGRADED)
//////////////////////////////////////////////////////////////////

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text(
            "Contact Us",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),

          _item(Icons.business, "The Web Concept"),
          _item(Icons.email, "info@thewebconcept.com"),
          _item(Icons.language, "thewebconcept.com"),
        ],
      ),
    );
  }

  Widget _item(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Text(text),
        ],
      ),
    );
  }
}
