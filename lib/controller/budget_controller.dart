import 'package:get/get.dart';

class CreateBudgetController extends GetxController {
  var sliderValue = 80.0.obs;
  var receiveAlert = true.obs;
  var selectedCategory = RxnString();

  final List<String> categories = [
    'Food & Groceries',
    'Transport',
    'Entertainment',
    'Shopping',
    'Health',
    'Education',
    'Bills & Utilities',
    'Other',
  ];

  double get budgetAmount => sliderValue.value * 10;
}