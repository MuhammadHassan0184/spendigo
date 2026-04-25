import 'package:flutter/material.dart';
import 'package:spendigo/config/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? arrowColor;
  final double elevation;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.actions,
    this.backgroundColor,
    this.titleColor,
    this.arrowColor,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,

      // BACK BUTTON
      leading: showBackButton
          ? IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: arrowColor ?? AppColors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          : null,

      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: titleColor ?? AppColors.black,
          fontSize: 21,
        ),
      ),

      centerTitle: true,
      elevation: elevation,
      backgroundColor: backgroundColor ?? Colors.white,

      // ACTIONS (right side icons)
      actions: actions,

      // BETTER UI
      surfaceTintColor: Colors.transparent,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
