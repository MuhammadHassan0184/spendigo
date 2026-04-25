import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spendigo/config/colors.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final String? svgPath;
  final VoidCallback? onTap;

  const CustomListTile({
    super.key,
    required this.title,
    this.svgPath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(7),
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          shape: BoxShape.circle,
        ),
        child: svgPath != null ? SvgPicture.asset(svgPath!) : null,
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: Icon(Icons.chevron_right, color: AppColors.primary, size: 25),
    );
  }
}
