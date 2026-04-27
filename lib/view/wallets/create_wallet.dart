// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendigo/config/colors.dart';
import 'package:spendigo/controller/wallet_controller.dart';
import 'package:spendigo/controller/currency_controller.dart';
import 'package:spendigo/widgets/custom_app_bar.dart';
import 'package:spendigo/widgets/custom_button.dart';
import 'package:spendigo/widgets/custom_textfield.dart';

class CreateWallet extends StatelessWidget {
  const CreateWallet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateWalletController());

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.primary,
      appBar: CustomAppBar(
        title: "Create Wallet",
        showBackButton: true,
        arrowColor: Colors.white,
        backgroundColor: AppColors.primary,
        titleColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 🔹 Balance Section
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Balance',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(() {
                                final cur = Get.find<CurrencyController>().selectedCurrency.value;
                                return Text(
                                  '$cur ',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 48,
                                    fontWeight: FontWeight.w700,
                                    height: 1.1,
                                  ),
                                );
                              }),
                              Expanded(
                                child: TextField(
                                  controller: controller.amountController,
                                  keyboardType: TextInputType.number,
                                  cursorColor: Colors.white,
                                  onChanged: (val) => controller.updateSliderFromAmount(val),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 48,
                                    fontWeight: FontWeight.w700,
                                    height: 1.1,
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    /// 🔹 White Card
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(28),
                          topRight: Radius.circular(28),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Name Field
                          CustomTextField(
                            label: "Name",
                            hintText: "Enter Here",
                            controller: controller.nameController,
                          ),

                          const SizedBox(height: 20),

                          /// 🔹 Switch
                          Row(
                            children: [
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Receive Alert',
                                      style: TextStyle(
                                        fontSize: 15,
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
                                  label:
                                      '${controller.sliderValue.value.toInt()}%',
                                ),
                                overlayColor: const Color(
                                  0xFF2F7E79,
                                ).withOpacity(0.15),
                                trackHeight: 6,
                              ),
                              child: Slider(
                                min: 0,
                                max: 100,
                                value: controller.sliderValue.value,
                                onChanged: (val) =>
                                    controller.sliderValue.value = val,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// 🔹 Button
                          CustomButton(
                            text: "Create Wallet",
                            onPressed: () {
                              controller.createWallet();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 🔹 Custom Thumb Shape (unchanged)
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
