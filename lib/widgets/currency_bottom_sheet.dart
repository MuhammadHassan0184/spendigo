import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendigo/config/colors.dart';
import 'package:spendigo/controller/currency_controller.dart';

class CurrencyBottomSheet extends StatelessWidget {
  const CurrencyBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CurrencyController>();
    controller.searchQuery.value = ""; // Reset search

    return Container(
      height: Get.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          // Handle
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Select Currency",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 15),
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              onChanged: (value) => controller.searchQuery.value = value,
              decoration: InputDecoration(
                hintText: "Search country or symbol...",
                prefixIcon: Icon(Icons.search, color: AppColors.primary),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // List
          Expanded(
            child: Obx(() {
              final countries = controller.filteredCountries;
              return ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                itemCount: countries.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = countries[index];
                  final isSelected =
                      controller.selectedCurrency.value == item['symbol'];

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    leading: Text(
                      item['flag']!,
                      style: const TextStyle(fontSize: 24),
                    ),
                    title: Text(
                      item['country']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item['symbol']!,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? AppColors.primary
                                : Colors.black54,
                          ),
                        ),
                        if (isSelected) ...[
                          const SizedBox(width: 10),
                          Icon(
                            Icons.check_circle,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ],
                      ],
                    ),
                    onTap: () => controller.updateCurrency(item['symbol']!),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

void showCurrencyBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const CurrencyBottomSheet(),
  );
}
