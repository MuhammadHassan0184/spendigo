import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spendigo/config/colors.dart';

class WalletTile extends StatelessWidget {
  final String amount;
  final String title;
  final VoidCallback? onTap;

  const WalletTile({
    super.key,
    required this.amount,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.stroke),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(10),
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: SvgPicture.asset(
            "assets/wallet.svg", // fixed icon
            color: AppColors.primary,
          ),
        ),
        title: Text(
          amount,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.grey),
        ),
        trailing: Icon(Icons.keyboard_arrow_right, color: AppColors.grey),
      ),
    );
  }
}
