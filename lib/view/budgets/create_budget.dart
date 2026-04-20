// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendigo/config/colors.dart';
import 'package:spendigo/controller/budget_controller.dart';
import 'package:spendigo/widgets/custom_app_bar.dart';
import 'package:spendigo/widgets/custom_button.dart';

class CreateBudget extends StatelessWidget {
  const CreateBudget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateBudgetController());

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: CustomAppBar(
        title: "Create Budget",
        showBackButton: true,
        arrowColor: Colors.white,
        backgroundColor: AppColors.primary,
        titleColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            /// 🔹 Amount Display
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Obx(
                    () => Column(
                      mainAxisSize: MainAxisSize.min, // ✅ IMPORTANT FIX
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'How much do you want to spend?',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$${controller.budgetAmount.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.w700,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            /// 🔹 Bottom Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔹 Category Dropdown
                  const Text(
                    'Category',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),

                  Obx(
                    () => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          hint: const Text('Select'),
                          value: controller.selectedCategory.value,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: controller.categories
                              .map(
                                (cat) => DropdownMenuItem(
                                  value: cat,
                                  child: Text(cat),
                                ),
                              )
                              .toList(),
                          onChanged: (val) =>
                              controller.selectedCategory.value = val,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 🔹 Switch
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Receive Alert',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Receive alert when it reaches\nsome point.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF9E9E9E),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Obx(
                        () => Switch(
                          value: controller.receiveAlert.value,
                          onChanged: (val) =>
                              controller.receiveAlert.value = val,
                          activeColor: AppColors.primary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  /// 🔹 Slider
                  Obx(
                    () => SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: AppColors.primary,
                        inactiveTrackColor: const Color(0xFFE0E0E0),
                        thumbColor: Colors.white,
                        thumbShape: _BudgetThumbShape(
                          label: '${controller.sliderValue.value.toInt()}%',
                        ),
                        overlayColor: const Color(0xFF2F7E79).withOpacity(0.15),
                        trackHeight: 6,
                      ),
                      child: Slider(
                        min: 0,
                        max: 100,
                        value: controller.sliderValue.value,
                        onChanged: (val) => controller.sliderValue.value = val,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 🔹 Button
                  CustomButton(
                    text: "Create Budget",
                    onPressed: () {
                      // your logic
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 🔹 Thumb Shape (unchanged)
class _BudgetThumbShape extends SliderComponentShape {
  final String label;
  const _BudgetThumbShape({required this.label});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => const Size(56, 28);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: 52, height: 26),
      const Radius.circular(13),
    );
    canvas.drawRRect(rrect, Paint()..color = const Color(0xFF2F7E79));

    final tp = TextPainter(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
  }
}
