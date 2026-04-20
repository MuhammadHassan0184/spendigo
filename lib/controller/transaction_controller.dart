import 'package:get/get.dart';

class AddTransactionController extends GetxController {
  var isIncome = false.obs;
  var repeat = false.obs;

  var category = RxnString();
  var wallet = RxnString();
  var budget = RxnString();

  var repeatType = "Every day".obs;

  void toggleIncome(bool value) {
    isIncome.value = value;
  }

  void toggleRepeat(bool value) {
    repeat.value = value;
  }

  void setRepeatType(String value) {
    repeatType.value = value;
  }
}