import 'package:get/get.dart';
import 'package:hive/hive.dart';

class CurrencyController extends GetxController {
  var selectedCurrency = "Rs.".obs;

  final List<String> currencies = ["Rs.", "\$", "€", "£", "¥", "₩"];

  late Box _box;

  @override
  void onInit() {
    super.onInit();
    _box = Hive.box('settings');
    loadCurrency();
  }

  void loadCurrency() {
    selectedCurrency.value = _box.get('currency', defaultValue: "Rs.");
  }

  void changeCurrency(String currency) {
    selectedCurrency.value = currency;
    _box.put('currency', currency);
  }
}
