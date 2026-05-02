import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CurrencyController extends GetxController {
  var selectedCurrency = "Rs.".obs;
  var searchQuery = "".obs;

  // Comprehensive list of countries and currencies
  final List<Map<String, String>> countryCurrencies = [
    {"country": "Pakistan", "symbol": "Rs.", "flag": "🇵🇰"},
    {"country": "United States", "symbol": "\$", "flag": "🇺🇸"},
    {"country": "European Union", "symbol": "€", "flag": "🇪🇺"},
    {"country": "United Kingdom", "symbol": "£", "flag": "🇬🇧"},
    {"country": "India", "symbol": "₹", "flag": "🇮🇳"},
    {"country": "Japan", "symbol": "¥", "flag": "🇯🇵"},
    {"country": "South Korea", "symbol": "₩", "flag": "🇰🇷"},
    {"country": "United Arab Emirates", "symbol": "AED", "flag": "🇦🇪"},
    {"country": "Saudi Arabia", "symbol": "SAR", "flag": "🇸🇦"},
    {"country": "Canada", "symbol": "C\$", "flag": "🇨🇦"},
    {"country": "Australia", "symbol": "A\$", "flag": "🇦🇺"},
    {"country": "Turkey", "symbol": "₺", "flag": "🇹🇷"},
    {"country": "Russia", "symbol": "₽", "flag": "🇷🇺"},
    {"country": "China", "symbol": "元", "flag": "🇨🇳"},
    {"country": "Singapore", "symbol": "S\$", "flag": "🇸🇬"},
    {"country": "Malaysia", "symbol": "RM", "flag": "🇲🇾"},
    {"country": "Indonesia", "symbol": "Rp", "flag": "🇮🇩"},
    {"country": "Thailand", "symbol": "฿", "flag": "🇹🇭"},
    {"country": "Vietnam", "symbol": "₫", "flag": "🇻🇳"},
    {"country": "Brazil", "symbol": "R\$", "flag": "🇧🇷"},
    {"country": "Mexico", "symbol": "\$", "flag": "🇲🇽"},
    {"country": "Argentina", "symbol": "\$", "flag": "🇦🇷"},
    {"country": "South Africa", "symbol": "R", "flag": "🇿🇦"},
    {"country": "Nigeria", "symbol": "₦", "flag": "🇳🇬"},
    {"country": "Egypt", "symbol": "E£", "flag": "🇪🇬"},
    {"country": "Switzerland", "symbol": "CHF", "flag": "🇨🇭"},
    {"country": "Norway", "symbol": "kr", "flag": "🇳🇴"},
    {"country": "Sweden", "symbol": "kr", "flag": "🇸🇪"},
    {"country": "New Zealand", "symbol": "NZ\$", "flag": "🇳🇿"},
    {"country": "Philippines", "symbol": "₱", "flag": "🇵🇭"},
    {"country": "Bangladesh", "symbol": "৳", "flag": "🇧🇩"},
    {"country": "Sri Lanka", "symbol": "Rs.", "flag": "🇱🇰"},
    {"country": "Qatar", "symbol": "QR", "flag": "🇶🇦"},
    {"country": "Kuwait", "symbol": "KD", "flag": "🇰🇼"},
    {"country": "Bahrain", "symbol": "BD", "flag": "🇧🇭"},
    {"country": "Oman", "symbol": "OMR", "flag": "🇴🇲"},
    {"country": "Jordan", "symbol": "JOD", "flag": "🇯🇴"},
    {"country": "Poland", "symbol": "zł", "flag": "🇵🇱"},
    {"country": "Denmark", "symbol": "kr.", "flag": "🇩🇰"},
    {"country": "Czech Republic", "symbol": "Kč", "flag": "🇨🇿"},
    {"country": "Hungary", "symbol": "Ft", "flag": "🇭🇺"},
  ];

  List<Map<String, String>> get filteredCountries {
    if (searchQuery.isEmpty) return countryCurrencies;
    return countryCurrencies
        .where(
          (c) =>
              c['country']!.toLowerCase().contains(
                searchQuery.value.toLowerCase(),
              ) ||
              c['symbol']!.toLowerCase().contains(
                searchQuery.value.toLowerCase(),
              ),
        )
        .toList();
  }

  var hasSeenHint = false.obs;

  Box get _box {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return Hive.box('settings_$uid');
  }

  @override
  void onInit() {
    super.onInit();
    _initData();
  }

  Future<void> _initData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      if (!Hive.isBoxOpen('settings_$uid')) {
        await Hive.openBox('settings_$uid');
      }
      await loadCurrency();
      await checkHintStatus();
    }
  }

  Future<void> checkHintStatus() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      if (!Hive.isBoxOpen('settings_$uid')) {
        await Hive.openBox('settings_$uid');
      }
      hasSeenHint.value = _box.get('hasSeenCurrencyHint', defaultValue: false);
    }
  }
  

  void markHintAsSeen() {
    if (!hasSeenHint.value) {
      hasSeenHint.value = true;
      _box.put('hasSeenCurrencyHint', true);
    }
  }

  Future<void> loadCurrency() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      if (!Hive.isBoxOpen('settings_$uid')) {
        await Hive.openBox('settings_$uid');
      }
      selectedCurrency.value = _box.get('currency', defaultValue: "Rs.");
    }
  }

  Future<void> updateCurrency(String symbol) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      if (!Hive.isBoxOpen('settings_$uid')) {
        await Hive.openBox('settings_$uid');
      }
      selectedCurrency.value = symbol;
      await _box.put('currency', symbol);
      markHintAsSeen(); // Hide hint if they change currency
      Get.back(); // Close bottom sheet
    }
  }
}
