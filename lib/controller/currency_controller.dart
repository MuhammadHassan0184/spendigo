import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CurrencyController extends GetxController {
  var selectedCurrency = "Rs.".obs;

  final List<String> currencies = ["Rs.", "\$", "€", "£", "¥", "₩"];

  Box get _box {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return Hive.box('settings_$uid');
  }

  @override
  void onInit() {
    super.onInit();
    if (FirebaseAuth.instance.currentUser != null) {
      loadCurrency();
    }
  }

  void loadCurrency() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null && Hive.isBoxOpen('settings_$uid')) {
      selectedCurrency.value = _box.get('currency', defaultValue: "Rs.");
    }
  }

  void changeCurrency(String currency) {
    selectedCurrency.value = currency;
    _box.put('currency', currency);
  }
}
