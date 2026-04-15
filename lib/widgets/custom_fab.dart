import 'package:flutter/material.dart';
import 'package:spendigo/config/colors.dart';

class CustomFAB extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;

  const CustomFAB({
    super.key,
    required this.onTap,
    this.icon = Icons.add,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onTap,
      backgroundColor: AppColors.primary,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(35),
      ),
      child: Icon(
        icon,
        size: 30,
        color: AppColors.white,
      ),
    );
  }
}